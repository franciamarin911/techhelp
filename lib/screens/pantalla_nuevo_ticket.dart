import 'package:material_ui/material_ui.dart';
import 'package:techhelp/services/servicio_tickets.dart';
import 'package:techhelp/utils/constantes_app.dart';
import 'package:techhelp/utils/textos_ticket.dart';
import 'package:techhelp/utils/validaciones.dart';

class PantallaNuevoTicket extends StatefulWidget {
  const PantallaNuevoTicket({super.key});

  @override
  State<PantallaNuevoTicket> createState() => _EstadoPantallaNuevoTicket();
}

class _EstadoPantallaNuevoTicket extends State<PantallaNuevoTicket> {
  final _claveDelFormulario = GlobalKey<FormState>();
  final _controladorDelTitulo = TextEditingController();
  final _controladorDeLaDescripcion = TextEditingController();
  final _controladorDeLaUbicacion = TextEditingController();

  String? _categoriaElegida;
  String _prioridadElegida = PrioridadesTicket.media;

  bool _estaGuardando = false;
  String? _mensajeDeError;

  @override
  void dispose() {
    _controladorDelTitulo.dispose();
    _controladorDeLaDescripcion.dispose();
    _controladorDeLaUbicacion.dispose();
    super.dispose();
  }

  Future<void> _enviarSolicitud() async {
    FocusScope.of(context).unfocus();

    final formularioEsValido = _claveDelFormulario.currentState!.validate();
    if (!formularioEsValido) return;

    setState(() {
      _estaGuardando = true;
      _mensajeDeError = null;
    });

    try {
      await ServicioTickets.crearTicket(
        titulo: _controladorDelTitulo.text,
        descripcion: _controladorDeLaDescripcion.text,
        categoria: _categoriaElegida!,
        prioridad: _prioridadElegida,
        ubicacion: _controladorDeLaUbicacion.text,
      );

      if (!mounted) return;

      // "true" le avisa a la pantalla anterior que se creó una solicitud.
      Navigator.of(context).pop(true);
    } on ErrorTickets catch (error) {
      if (!mounted) return;
      setState(() {
        _mensajeDeError = error.mensaje;
        _estaGuardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorDelError = Theme.of(context).colorScheme.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _claveDelFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _controladorDelTitulo,
                  enabled: !_estaGuardando,
                  maxLength: 80,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ej. Proyector no enciende',
                  ),
                  validator: Validaciones.validarTitulo,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _controladorDeLaDescripcion,
                  enabled: !_estaGuardando,
                  maxLength: 500,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Cuéntanos qué ocurre',
                    alignLabelWithHint: true,
                  ),
                  validator: Validaciones.validarDescripcion,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _categoriaElegida,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  hint: const Text('Selecciona una categoría'),
                  items: CategoriasTicket.nombresVisibles.entries
                      .map(
                        (categoria) => DropdownMenuItem<String>(
                          value: categoria.key,
                          child: Text(categoria.value),
                        ),
                      )
                      .toList(),
                  onChanged: _estaGuardando
                      ? null
                      : (valor) => setState(() => _categoriaElegida = valor),
                  validator: Validaciones.validarOpcionElegida,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _prioridadElegida,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Prioridad'),
                  items: TextosTicket.prioridadesVisibles.entries
                      .map(
                        (prioridad) => DropdownMenuItem<String>(
                          value: prioridad.key,
                          child: Text(prioridad.value),
                        ),
                      )
                      .toList(),
                  onChanged: _estaGuardando
                      ? null
                      : (valor) {
                          if (valor == null) return;
                          setState(() => _prioridadElegida = valor);
                        },
                  validator: Validaciones.validarOpcionElegida,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _controladorDeLaUbicacion,
                  enabled: !_estaGuardando,
                  maxLength: 80,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Ubicación',
                    hintText: 'Ej. Aula 204, Laboratorio 3, Biblioteca',
                  ),
                  validator: Validaciones.validarUbicacion,
                ),
                const SizedBox(height: 8),
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
                  onPressed: _estaGuardando ? null : _enviarSolicitud,
                  child: _estaGuardando
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : const Text('Enviar solicitud'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed:
                      _estaGuardando ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}