import 'package:material_ui/material_ui.dart';
import 'package:techhelp/services/servicio_autenticacion.dart';
import 'package:techhelp/utils/navegacion.dart';
import 'package:techhelp/utils/tema_app.dart';
import 'package:techhelp/utils/validaciones.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _EstadoPantallaInicioSesion();
}

class _EstadoPantallaInicioSesion extends State<PantallaInicioSesion> {
  final _claveDelFormulario = GlobalKey<FormState>();
  final _controladorDelCorreo = TextEditingController();
  final _controladorDeLaContrasena = TextEditingController();

  bool _estaIniciandoSesion = false;
  bool _ocultarContrasena = true;
  String? _mensajeDeError;

  @override
  void dispose() {
    _controladorDelCorreo.dispose();
    _controladorDeLaContrasena.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    FocusScope.of(context).unfocus();

    final formularioEsValido = _claveDelFormulario.currentState!.validate();
    if (!formularioEsValido) return;

    setState(() {
      _estaIniciandoSesion = true;
      _mensajeDeError = null;
    });

    try {
      final perfil = await ServicioAutenticacion.iniciarSesion(
        correo: _controladorDelCorreo.text,
        contrasena: _controladorDeLaContrasena.text,
      );

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => pantallaSegunElRol(perfil)),
        (ruta) => false,
      );
    } on ErrorAutenticacion catch (error) {
      if (!mounted) return;
      setState(() {
        _mensajeDeError = error.mensaje;
        _estaIniciandoSesion = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorDelError = Theme.of(context).colorScheme.error;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _claveDelFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 56),
                const Text(
                  'TECHHELP',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: TemaApp.colorPrimario,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Soporte técnico para la comunidad universitaria'),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _controladorDelCorreo,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enableSuggestions: false,
                  enabled: !_estaIniciandoSesion,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    hintText: 'nombre@ejemplo.com',
                  ),
                  validator: Validaciones.validarCorreo,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controladorDeLaContrasena,
                  obscureText: _ocultarContrasena,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  enabled: !_estaIniciandoSesion,
                  onFieldSubmitted: (_) => _iniciarSesion(),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      tooltip: _ocultarContrasena
                          ? 'Mostrar contraseña'
                          : 'Ocultar contraseña',
                      icon: Icon(
                        _ocultarContrasena
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarContrasena = !_ocultarContrasena;
                        });
                      },
                    ),
                  ),
                  validator: Validaciones.validarContrasena,
                ),
                const SizedBox(height: 16),
                if (_mensajeDeError != null) ...[
                  Text(
                    _mensajeDeError!,
                    style: TextStyle(
                      color: colorDelError,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                FilledButton(
                  onPressed: _estaIniciandoSesion ? null : _iniciarSesion,
                  child: _estaIniciandoSesion
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Prototipo académico independiente. No es una plataforma '
                  'oficial. Datos ficticios.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}