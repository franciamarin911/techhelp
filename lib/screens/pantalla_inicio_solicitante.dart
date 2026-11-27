import 'package:material_ui/material_ui.dart';
import 'package:techhelp/models/perfil_usuario.dart';
import 'package:techhelp/models/ticket.dart';
import 'package:techhelp/screens/pantalla_nuevo_ticket.dart';
import 'package:techhelp/services/servicio_tickets.dart';
import 'package:techhelp/utils/navegacion.dart';
import 'package:techhelp/widgets/tarjeta_ticket.dart';

class PantallaInicioSolicitante extends StatefulWidget {
  final PerfilUsuario perfil;

  const PantallaInicioSolicitante({super.key, required this.perfil});

  @override
  State<PantallaInicioSolicitante> createState() =>
      _EstadoPantallaInicioSolicitante();
}

class _EstadoPantallaInicioSolicitante
    extends State<PantallaInicioSolicitante> {
  late Future<List<Ticket>> _futuroDeLosTickets;

  @override
  void initState() {
    super.initState();
    _futuroDeLosTickets = ServicioTickets.listarMisTickets();
  }

  void _recargarLaLista() {
    setState(() {
      _futuroDeLosTickets = ServicioTickets.listarMisTickets();
    });
  }

  /// Se usa al deslizar hacia abajo: espera a que termine la carga.
  Future<void> _actualizarDeslizando() async {
    _recargarLaLista();
    try {
      await _futuroDeLosTickets;
    } catch (_) {
      // El error ya se muestra en pantalla; aquí solo se termina el giro.
    }
  }

  Future<void> _abrirFormularioDeNuevaSolicitud() async {
    final seCreoUnaSolicitud = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PantallaNuevoTicket()),
    );

    if (seCreoUnaSolicitud != true || !mounted) return;

    _recargarLaLista();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada correctamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _recargarLaLista,
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => cerrarSesionYVolverAlLogin(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                'Hola, ${widget.perfil.nombreCompleto}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(child: _construirContenidoDeLaLista()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: _abrirFormularioDeNuevaSolicitud,
                child: const Text('+ Nueva solicitud'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirContenidoDeLaLista() {
    return FutureBuilder<List<Ticket>>(
      future: _futuroDeLosTickets,
      builder: (contexto, instantanea) {
        if (instantanea.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (instantanea.hasError) {
          final error = instantanea.error;
          final mensaje = error is ErrorTickets
              ? error.mensaje
              : 'Ocurrió un problema al cargar tus solicitudes.';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _recargarLaLista,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(180, 48),
                    ),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        final tickets = instantanea.data ?? [];

        // Estado vacío (con scroll para poder deslizar y actualizar).
        if (tickets.isEmpty) {
          return RefreshIndicator(
            onRefresh: _actualizarDeslizando,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(32),
              children: const [
                SizedBox(height: 60),
                Icon(Icons.inbox_outlined, size: 56),
                SizedBox(height: 12),
                Text(
                  'Aún no tienes solicitudes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'Toca "+ Nueva solicitud" para pedir ayuda técnica.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _actualizarDeslizando,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: tickets.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, posicion) =>
                TarjetaTicket(ticket: tickets[posicion]),
          ),
        );
      },
    );
  }
}