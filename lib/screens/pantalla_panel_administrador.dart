import 'package:material_ui/material_ui.dart';
import 'package:techhelp/screens/pantalla_detalle_ticket.dart';

class PantallaPanelAdministrador extends StatelessWidget {
  const PantallaPanelAdministrador({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel administrador'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Navigator.of(context).popUntil((ruta) => ruta.isFirst),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Aquí irán los conteos y la lista general (Etapa 8).'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PantallaDetalleTicket(),
                ),
              ),
              child: const Text('Ver detalle de ejemplo'),
            ),
          ],
        ),
      ),
    );
  }
}