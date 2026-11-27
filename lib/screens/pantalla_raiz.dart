import 'package:material_ui/material_ui.dart';
import 'package:techhelp/models/perfil_usuario.dart';
import 'package:techhelp/screens/pantalla_inicio_sesion.dart';
import 'package:techhelp/services/servicio_autenticacion.dart';
import 'package:techhelp/utils/navegacion.dart';

/// Primera pantalla al abrir la app. Decide a dónde ir:
/// - Sin sesión guardada: al login.
/// - Con sesión guardada: a la pantalla de su rol.
class PantallaRaiz extends StatefulWidget {
  const PantallaRaiz({super.key});

  @override
  State<PantallaRaiz> createState() => _EstadoPantallaRaiz();
}

class _EstadoPantallaRaiz extends State<PantallaRaiz> {
  late Future<PerfilUsuario?> _futuroDelPerfil;

  @override
  void initState() {
    super.initState();
    _futuroDelPerfil = _determinarPerfilInicial();
  }

  /// Devuelve null cuando no hay sesión (hay que mostrar el login).
  Future<PerfilUsuario?> _determinarPerfilInicial() async {
    if (!ServicioAutenticacion.haySesionActiva) return null;
    return ServicioAutenticacion.obtenerPerfilDelUsuarioActual();
  }

  void _reintentar() {
    setState(() {
      _futuroDelPerfil = _determinarPerfilInicial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PerfilUsuario?>(
      future: _futuroDelPerfil,
      builder: (contexto, instantanea) {
        if (instantanea.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (instantanea.hasError) {
          final error = instantanea.error;
          final mensaje = error is ErrorAutenticacion
              ? error.mensaje
              : 'Ocurrió un problema al abrir tu sesión.';

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      mensaje,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _reintentar,
                      child: const Text('Reintentar'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => cerrarSesionYVolverAlLogin(contexto),
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final perfil = instantanea.data;
        if (perfil == null) {
          return const PantallaInicioSesion();
        }

        return pantallaSegunElRol(perfil);
      },
    );
  }
}