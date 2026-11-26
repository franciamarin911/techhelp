import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techhelp/app.dart';
import 'package:techhelp/config/configuracion_supabase.dart';

Future<void> main() async {
  // Necesario antes de usar plugins o código asíncrono al arrancar.
  WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
    url: ConfiguracionSupabase.urlDelProyecto,
    publishableKey: ConfiguracionSupabase.clavePublicable,
  );

  runApp(const AplicacionTechhelp());
}