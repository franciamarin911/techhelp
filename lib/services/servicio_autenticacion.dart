import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techhelp/models/perfil_usuario.dart';
import 'package:techhelp/services/servicio_supabase.dart';
import 'package:techhelp/utils/constantes_app.dart';

/// Error con un mensaje listo para mostrarle a la persona (en español).
class ErrorAutenticacion implements Exception {
  final String mensaje;
  const ErrorAutenticacion(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Inicio de sesión, cierre de sesión y consulta del perfil con su rol.
class ServicioAutenticacion {
  ServicioAutenticacion._();

  static const String _mensajeSinConexion =
      'No se pudo conectar. Revisa tu internet e inténtalo de nuevo.';

  static const List<String> _rolesValidos = [
    Roles.solicitante,
    Roles.tecnico,
    Roles.administrador,
  ];

  /// Indica si hay una sesión guardada en el teléfono.
  static bool get haySesionActiva =>
      ServicioSupabase.cliente.auth.currentSession != null;

  /// Inicia sesión y devuelve el perfil (con su rol).
  static Future<PerfilUsuario> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final respuesta = await ServicioSupabase.cliente.auth.signInWithPassword(
        email: correo.trim(),
        password: contrasena,
      );

      if (respuesta.user == null) {
        throw const ErrorAutenticacion(
          'No se pudo iniciar sesión. Inténtalo de nuevo.',
        );
      }
    } on ErrorAutenticacion {
      rethrow;
    } on AuthException catch (error) {
      throw ErrorAutenticacion(_traducirErrorDeAutenticacion(error));
    } catch (_) {
      throw const ErrorAutenticacion(_mensajeSinConexion);
    }

    // La sesión ya está abierta. Si falla la lectura del perfil,
    // se cierra la sesión para no dejar una cuenta "a medias".
    try {
      return await obtenerPerfilDelUsuarioActual();
    } catch (_) {
      await cerrarSesion();
      rethrow;
    }
  }

  /// Lee el perfil de la persona que tiene la sesión abierta.
  static Future<PerfilUsuario> obtenerPerfilDelUsuarioActual() async {
    final usuarioActual = ServicioSupabase.cliente.auth.currentUser;

    if (usuarioActual == null) {
      throw const ErrorAutenticacion(
        'Tu sesión no está activa. Inicia sesión de nuevo.',
      );
    }

    try {
      final datosDelPerfil = await ServicioSupabase.cliente
          .from('perfiles')
          .select()
          .eq('id', usuarioActual.id)
          .maybeSingle();

      if (datosDelPerfil == null) {
        throw const ErrorAutenticacion(
          'Tu cuenta no tiene un perfil asignado. Contacta al administrador.',
        );
      }

      final perfil = PerfilUsuario.desdeMapa(datosDelPerfil);

      if (!_rolesValidos.contains(perfil.rol)) {
        throw const ErrorAutenticacion(
          'Tu cuenta tiene un rol no reconocido. Contacta al administrador.',
        );
      }

      return perfil;
    } on ErrorAutenticacion {
      rethrow;
    } on PostgrestException {
      throw const ErrorAutenticacion(
        'No se pudo leer tu perfil. Inténtalo de nuevo.',
      );
    } catch (_) {
      throw const ErrorAutenticacion(_mensajeSinConexion);
    }
  }

  /// Cierra la sesión. Si no hay internet, igual se intenta salir sin fallar.
  static Future<void> cerrarSesion() async {
    try {
      await ServicioSupabase.cliente.auth.signOut();
    } catch (_) {
      // Se ignora: lo importante es que la persona vuelva al login.
    }
  }

  static String _traducirErrorDeAutenticacion(AuthException error) {
    final mensajeEnMinuscula = error.message.toLowerCase();

    if (error.code == 'invalid_credentials' ||
        mensajeEnMinuscula.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }

    if (error.code == 'email_not_confirmed' ||
        mensajeEnMinuscula.contains('email not confirmed')) {
      return 'Tu cuenta aún no está confirmada. Contacta al administrador.';
    }

    if (error.code == 'over_request_rate_limit' ||
        mensajeEnMinuscula.contains('rate limit')) {
      return 'Demasiados intentos. Espera unos minutos e inténtalo de nuevo.';
    }

    return 'No se pudo iniciar sesión. Revisa tu conexión a internet e '
        'inténtalo de nuevo.';
  }
}