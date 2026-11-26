import 'package:material_ui/material_ui.dart';
import 'package:techhelp/screens/pantalla_bandeja_tecnica.dart';
import 'package:techhelp/screens/pantalla_inicio_solicitante.dart';
import 'package:techhelp/screens/pantalla_panel_administrador.dart';
import 'package:techhelp/services/servicio_supabase.dart';
import 'package:techhelp/utils/tema_app.dart';

class PantallaInicioSesion extends StatefulWidget {
  const PantallaInicioSesion({super.key});

  @override
  State<PantallaInicioSesion> createState() => _EstadoPantallaInicioSesion();
}

class _EstadoPantallaInicioSesion extends State<PantallaInicioSesion> {
  bool _estaProbandoConexion = false;
  String? _mensajeResultadoConexion;

  Future<void> _probarConexion() async {
    setState(() {
      _estaProbandoConexion = true;
      _mensajeResultadoConexion = null;
    });

    final resultado = await ServicioSupabase.probarConexion();

    if (!mounted) return;
    setState(() {
      _estaProbandoConexion = false;
      _mensajeResultadoConexion = resultado;
    });
  }

  void _abrirPantalla(Widget pantalla) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
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
              const Text(
                'Aquí irá el formulario de inicio de sesión (Etapa 5).',
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Zona de pruebas (temporal)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _estaProbandoConexion ? null : _probarConexion,
                        child: Text(
                          _estaProbandoConexion
                              ? 'Probando...'
                              : 'Probar conexión con Supabase',
                        ),
                      ),
                      if (_mensajeResultadoConexion != null) ...[
                        const SizedBox(height: 12),
                        Text(_mensajeResultadoConexion!),
                      ],
                      const Divider(height: 32),
                      OutlinedButton(
                        onPressed: () =>
                            _abrirPantalla(const PantallaInicioSolicitante()),
                        child: const Text('Ver pantalla de solicitante'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () =>
                            _abrirPantalla(const PantallaBandejaTecnica()),
                        child: const Text('Ver pantalla de técnico'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () =>
                            _abrirPantalla(const PantallaPanelAdministrador()),
                        child: const Text('Ver pantalla de administrador'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Prototipo académico independiente. No es una plataforma '
                'oficial. Datos ficticios.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}