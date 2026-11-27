import 'package:techhelp/utils/constantes_app.dart';

/// Convierte los valores guardados en la base de datos
/// (por ejemplo "en_proceso") en textos legibles ("En proceso").
class TextosTicket {
  TextosTicket._();

  static const Map<String, String> estadosVisibles = {
    EstadosTicket.pendiente: 'Pendiente',
    EstadosTicket.asignado: 'Asignado',
    EstadosTicket.enProceso: 'En proceso',
    EstadosTicket.resuelto: 'Resuelto',
  };

  static const Map<String, String> prioridadesVisibles = {
    PrioridadesTicket.baja: 'Baja',
    PrioridadesTicket.media: 'Media',
    PrioridadesTicket.alta: 'Alta',
  };

  static String estado(String clave) => estadosVisibles[clave] ?? clave;

  static String prioridad(String clave) => prioridadesVisibles[clave] ?? clave;

  static String categoria(String clave) =>
      CategoriasTicket.nombresVisibles[clave] ?? clave;
}