import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techhelp/models/ticket.dart';
import 'package:techhelp/services/servicio_supabase.dart';

/// Error con un mensaje listo para mostrarle a la persona (en español).
class ErrorTickets implements Exception {
  final String mensaje;
  const ErrorTickets(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Crear y consultar solicitudes de soporte técnico.
class ServicioTickets {
  ServicioTickets._();

  static const String _mensajeSinConexion =
      'No se pudo conectar. Revisa tu internet e inténtalo de nuevo.';

  static const String _mensajeSesionInactiva =
      'Tu sesión no está activa. Inicia sesión de nuevo.';

  /// Guarda una solicitud nueva a nombre de la persona con la sesión abierta.
  ///
  /// Solo se envían los campos que la persona puede escribir.
  /// El estado ("pendiente") y las fechas los pone la base de datos.
  static Future<void> crearTicket({
    required String titulo,
    required String descripcion,
    required String categoria,
    required String prioridad,
    required String ubicacion,
  }) async {
    final usuarioActual = ServicioSupabase.cliente.auth.currentUser;

    if (usuarioActual == null) {
      throw const ErrorTickets(_mensajeSesionInactiva);
    }

    try {
      await ServicioSupabase.cliente.from('tickets').insert({
        'titulo': titulo.trim(),
        'descripcion': descripcion.trim(),
        'categoria': categoria,
        'prioridad': prioridad,
        'ubicacion': ubicacion.trim(),
        'creado_por': usuarioActual.id,
      });
    } on PostgrestException catch (error) {
      throw ErrorTickets(_traducirErrorDeLaBaseDeDatos(error));
    } catch (_) {
      throw const ErrorTickets(_mensajeSinConexion);
    }
  }

  /// Devuelve las solicitudes creadas por la persona con la sesión abierta,
  /// de la más reciente a la más antigua.
  static Future<List<Ticket>> listarMisTickets() async {
    final usuarioActual = ServicioSupabase.cliente.auth.currentUser;

    if (usuarioActual == null) {
      throw const ErrorTickets(_mensajeSesionInactiva);
    }

    try {
      final filasDeLaBaseDeDatos = await ServicioSupabase.cliente
          .from('tickets')
          .select()
          .eq('creado_por', usuarioActual.id)
          .order('creado_en', ascending: false);

      return filasDeLaBaseDeDatos
          .map((fila) => Ticket.desdeMapa(fila))
          .toList();
    } on PostgrestException catch (error) {
      throw ErrorTickets(_traducirErrorDeLaBaseDeDatos(error));
    } catch (_) {
      throw const ErrorTickets(_mensajeSinConexion);
    }
  }

  static String _traducirErrorDeLaBaseDeDatos(PostgrestException error) {
    // 42501 = la seguridad (RLS) no permite la acción.
    if (error.code == '42501') {
      return 'No tienes permiso para realizar esta acción.';
    }

    // 23514 = algún dato no cumple las reglas de la tabla.
    if (error.code == '23514') {
      return 'Algún dato no cumple las reglas permitidas. '
          'Revisa lo que escribiste.';
    }

    return 'Ocurrió un problema con el servidor. Inténtalo de nuevo.';
  }
}