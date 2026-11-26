import 'package:material_ui/material_ui.dart';

class PantallaDetalleTicket extends StatelessWidget {
  const PantallaDetalleTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la solicitud')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Aquí irán los datos completos de la solicitud (Etapa 7).'),
      ),
    );
  }
}