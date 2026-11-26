import 'package:supabase_flutter/supabase_flutter.dart';

/// Punto único de acceso al cliente de Supabase.
class ServicioSupabase {
  ServicioSupabase._();

  /// Cliente ya inicializado en main.dart.
  static SupabaseClient get cliente => Supabase.instance.client;
}