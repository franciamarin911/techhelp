/// Reglas para validar lo que escribe la persona en los formularios.
/// Cada función devuelve un mensaje de error, o null si el dato es válido.
class Validaciones {
  Validaciones._();

  static String? validarCorreo(String? valorEscrito) {
    final correo = (valorEscrito ?? '').trim();

    if (correo.isEmpty) {
      return 'Escribe tu correo.';
    }

    final formatoDeCorreo = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!formatoDeCorreo.hasMatch(correo)) {
      return 'Escribe un correo válido, por ejemplo nombre@ejemplo.com';
    }

    return null;
  }

  static String? validarContrasena(String? valorEscrito) {
    if (valorEscrito == null || valorEscrito.isEmpty) {
      return 'Escribe tu contraseña.';
    }
    return null;
  }
}