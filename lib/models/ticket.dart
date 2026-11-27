/// Una solicitud de soporte técnico.
/// Corresponde a una fila de la tabla "tickets" de Supabase.
class Ticket {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String prioridad;
  final String ubicacion;
  final String estado;
  final String creadoPor;

  /// Es null mientras ningún técnico haya tomado la solicitud.
  final String? asignadoA;

  final DateTime creadoEn;
  final DateTime actualizadoEn;

  const Ticket({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.prioridad,
    required this.ubicacion,
    required this.estado,
    required this.creadoPor,
    required this.asignadoA,
    required this.creadoEn,
    required this.actualizadoEn,
  });

  /// Crea un ticket a partir de la fila que devuelve Supabase.
  factory Ticket.desdeMapa(Map<String, dynamic> mapa) {
    return Ticket(
      id: mapa['id'] as String,
      titulo: mapa['titulo'] as String,
      descripcion: mapa['descripcion'] as String,
      categoria: mapa['categoria'] as String,
      prioridad: mapa['prioridad'] as String,
      ubicacion: mapa['ubicacion'] as String,
      estado: mapa['estado'] as String,
      creadoPor: mapa['creado_por'] as String,
      asignadoA: mapa['asignado_a'] as String?,
      // Supabase guarda en hora universal (UTC); aquí se pasa a la hora local.
      creadoEn: DateTime.parse(mapa['creado_en'] as String).toLocal(),
      actualizadoEn: DateTime.parse(mapa['actualizado_en'] as String).toLocal(),
    );
  }
}