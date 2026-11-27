import 'package:material_ui/material_ui.dart';
import 'package:techhelp/screens/pantalla_raiz.dart';
import 'package:techhelp/utils/tema_app.dart';

class AplicacionTechhelp extends StatelessWidget {
  const AplicacionTechhelp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TECHHELP',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      home: const PantallaRaiz(),
    );
  }
}