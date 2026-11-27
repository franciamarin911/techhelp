import 'package:material_ui/material_ui.dart';
import 'package:techhelp/utils/constantes_app.dart';
import 'package:techhelp/utils/textos_ticket.dart';

/// Etiqueta de color con el estado de una solicitud.
/// El estado siempre se muestra con texto (no solo con color).
class EtiquetaEstado extends StatelessWidget {
  final String estado;

  const EtiquetaEstado({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final colores = _coloresSegunElEstado(estado);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colores.fondo,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        TextosTicket.estado(estado),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colores.texto,
        ),
      ),
    );
  }

  ({Color fondo, Color texto}) _coloresSegunElEstado(String estado) {
    switch (estado) {
      case EstadosTicket.pendiente:
        return (fondo: const Color(0xFFFEF3C7), texto: const Color(0xFF92400E));
      case EstadosTicket.asignado:
        return (fondo: const Color(0xFFDBEAFE), texto: const Color(0xFF1E40AF));
      case EstadosTicket.enProceso:
        return (fondo: const Color(0xFFEDE9FE), texto: const Color(0xFF5B21B6));
      case EstadosTicket.resuelto:
        return (fondo: const Color(0xFFD1FAE5), texto: const Color(0xFF065F46));
      default:
        return (fondo: const Color(0xFFE2E8F0), texto: const Color(0xFF334155));
    }
  }
}