import 'package:intl/intl.dart';

/// Da formato a las fechas que se muestran en pantalla.
class FormatoFechas {
  FormatoFechas._();

  static final DateFormat _formatoDeFechaYHora = DateFormat('dd/MM/yyyy HH:mm');

  /// Ejemplo: 02/12/2026 14:30
  static String fechaYHora(DateTime fecha) => _formatoDeFechaYHora.format(fecha);
}