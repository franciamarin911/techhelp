import 'package:material_ui/material_ui.dart';

class PantallaNuevoTicket extends StatelessWidget {
  const PantallaNuevoTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Aquí irá el formulario de nueva solicitud (Etapa 6).'),
      ),
    );
  }
}