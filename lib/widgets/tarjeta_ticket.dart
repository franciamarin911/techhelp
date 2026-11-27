import 'package:material_ui/material_ui.dart';
import 'package:techhelp/models/ticket.dart';
import 'package:techhelp/utils/formato_fechas.dart';
import 'package:techhelp/utils/textos_ticket.dart';
import 'package:techhelp/widgets/etiqueta_estado.dart';

/// Tarjeta que resume una solicitud dentro de una lista.
class TarjetaTicket extends StatelessWidget {
  final Ticket ticket;

  /// Se ejecuta al tocar la tarjeta. Si es null, la tarjeta no es tocable.
  final VoidCallback? alTocar;

  const TarjetaTicket({super.key, required this.ticket, this.alTocar});

  @override
  Widget build(BuildContext context) {
    final estiloSecundario = TextStyle(
      fontSize: 13,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alTocar,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ticket.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  EtiquetaEstado(estado: ticket.estado),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${TextosTicket.categoria(ticket.categoria)} · '
                '${ticket.ubicacion}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: estiloSecundario,
              ),
              const SizedBox(height: 2),
              Text(
                'Prioridad: ${TextosTicket.prioridad(ticket.prioridad)} · '
                '${FormatoFechas.fechaYHora(ticket.creadoEn)}',
                style: estiloSecundario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}