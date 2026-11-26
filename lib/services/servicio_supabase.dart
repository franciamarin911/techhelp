import 'package:supabase_flutter/supabase_flutter.dart';

/// Punto único de acceso al cliente de Supabase.
class ServicioSupabase {
  ServicioSupabase._();

  /// Cliente ya inicializado en main.dart.
  static SupabaseClient get cliente => Supabase.instance.client;

  /// Prueba temporal de conectividad (se quita en la Etapa 5).
  ///
  /// Sin sesión iniciada, la base de datos debe RECHAZAR la lectura
  /// (error 42501). Eso demuestra dos cosas: que hay conexión y que
  /// las políticas de seguridad funcionan.
  static Future<String> probarConexion() async {
    try {
      await cliente.from('tickets').select('id').limit(1);
      return 'Conectado, pero la lectura sin sesión NO fue bloqueada. '
          'Revisa la seguridad (RLS) en Supabase.';
    } on PostgrestException catch (error) {
      if (error.code == '42501') {
        return 'Conexión correcta. El servidor respondió y bloqueó la '
            'lectura sin sesión (seguridad activa).';
      }
      return 'El servidor respondió con un problema.\n'
          'Código: ${error.code}\nMensaje: ${error.message}\n'
          'Revisa la clave publicable.';
    } catch (_) {
      return 'No se pudo conectar. Revisa tu internet y la URL del proyecto.';
    }
  }
}