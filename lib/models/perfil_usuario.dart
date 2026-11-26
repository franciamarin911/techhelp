/// Datos de una persona que usa TECHHELP.
/// Corresponde a una fila de la tabla "perfiles" de Supabase.
class PerfilUsuario {
  final String id;
  final String nombreCompleto;
  final String correo;
  final String rol;

  const PerfilUsuario({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.rol,
  });

  /// Crea un perfil a partir de la fila que devuelve Supabase.
  factory PerfilUsuario.desdeMapa(Map<String, dynamic> mapa) {
    return PerfilUsuario(
      id: mapa['id'] as String,
      nombreCompleto: mapa['nombre_completo'] as String,
      correo: mapa['correo'] as String,
      rol: mapa['rol'] as String,
    );
  }
}