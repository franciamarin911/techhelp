// Valores fijos de la app. Deben escribirse EXACTAMENTE igual que en la
// base de datos de Supabase (sin tildes, en minúscula).

class Roles {
  static const String solicitante = 'solicitante';
  static const String tecnico = 'tecnico';
  static const String administrador = 'administrador';
}

class EstadosTicket {
  static const String pendiente = 'pendiente';
  static const String asignado = 'asignado';
  static const String enProceso = 'en_proceso';
  static const String resuelto = 'resuelto';
}

class PrioridadesTicket {
  static const String baja = 'baja';
  static const String media = 'media';
  static const String alta = 'alta';
}

class CategoriasTicket {
  /// Clave guardada en la base de datos -> texto que ve la persona.
  static const Map<String, String> nombresVisibles = {
    'computadora': 'Computadora',
    'proyector': 'Proyector',
    'red_wifi': 'Red / Wi-Fi',
    'impresora': 'Impresora',
    'software': 'Software',
    'otro': 'Otro',
  };
}