import 'package:material_ui/material_ui.dart';
import 'package:techhelp/screens/pantalla_detalle_ticket.dart';
import 'package:techhelp/screens/pantalla_nuevo_ticket.dart';

class PantallaInicioSolicitante extends StatelessWidget {
  const PantallaInicioSolicitante({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
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
            const Text('Aquí irá la lista de tus solicitudes (Etapa 6).'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PantallaDetalleTicket(),
                ),
              ),
              child: const Text('Ver detalle de ejemplo'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PantallaNuevoTicket()),
              ),
              child: const Text('+ Nueva solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}