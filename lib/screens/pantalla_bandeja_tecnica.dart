import 'package:material_ui/material_ui.dart';
import 'package:techhelp/screens/pantalla_detalle_ticket.dart';

class PantallaBandejaTecnica extends StatelessWidget {
  const PantallaBandejaTecnica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bandeja técnica'),
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
            const Text(
              'Aquí irán las solicitudes sin asignar y tus casos (Etapa 7).',
            ),
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