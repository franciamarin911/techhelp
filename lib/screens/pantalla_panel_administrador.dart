import 'package:material_ui/material_ui.dart';
import 'package:techhelp/models/perfil_usuario.dart';
import 'package:techhelp/screens/pantalla_detalle_ticket.dart';
import 'package:techhelp/utils/navegacion.dart';

class PantallaPanelAdministrador extends StatelessWidget {
  final PerfilUsuario perfil;

  const PantallaPanelAdministrador({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel administrador'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => cerrarSesionYVolverAlLogin(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hola, ${perfil.nombreCompleto}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text('Rol: ${perfil.rol}'),
            const SizedBox(height: 16),
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