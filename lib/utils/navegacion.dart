import 'package:material_ui/material_ui.dart';
import 'package:techhelp/models/perfil_usuario.dart';
import 'package:techhelp/screens/pantalla_bandeja_tecnica.dart';
import 'package:techhelp/screens/pantalla_inicio_sesion.dart';
import 'package:techhelp/screens/pantalla_inicio_solicitante.dart';
import 'package:techhelp/screens/pantalla_panel_administrador.dart';
import 'package:techhelp/services/servicio_autenticacion.dart';
import 'package:techhelp/utils/constantes_app.dart';

/// Devuelve la pantalla principal que corresponde al rol del perfil.
Widget pantallaSegunElRol(PerfilUsuario perfil) {
  switch (perfil.rol) {
    case Roles.tecnico:
      return PantallaBandejaTecnica(perfil: perfil);
    case Roles.administrador:
      return PantallaPanelAdministrador(perfil: perfil);
    default:
      return PantallaInicioSolicitante(perfil: perfil);
  }
}

/// Cierra la sesión y deja al login como única pantalla
/// (así el botón "atrás" no regresa a una pantalla privada).
Future<void> cerrarSesionYVolverAlLogin(BuildContext contexto) async {
  await ServicioAutenticacion.cerrarSesion();

  if (!contexto.mounted) return;

  Navigator.of(contexto).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const PantallaInicioSesion()),
    (ruta) => false,
  );
}