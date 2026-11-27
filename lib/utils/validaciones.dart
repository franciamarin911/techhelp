/// Reglas para validar lo que escribe la persona en los formularios.
/// Cada función devuelve un mensaje de error, o null si el dato es válido.
class Validaciones {
  Validaciones._();

  // ---- Inicio de sesión ----

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

  // ---- Nueva solicitud ----
  // Los límites son los mismos que tienen los "check" de la base de datos.

  static String? validarTitulo(String? valorEscrito) {
    return _validarTexto(
      valorEscrito,
      mensajeSiEstaVacio: 'Escribe un título para la solicitud.',
      nombreDelCampo: 'El título',
      minimoDeCaracteres: 5,
      maximoDeCaracteres: 80,
    );
  }

  static String? validarDescripcion(String? valorEscrito) {
    return _validarTexto(
      valorEscrito,
      mensajeSiEstaVacio: 'Describe el problema.',
      nombreDelCampo: 'La descripción',
      minimoDeCaracteres: 10,
      maximoDeCaracteres: 500,
    );
  }

  static String? validarUbicacion(String? valorEscrito) {
    return _validarTexto(
      valorEscrito,
      mensajeSiEstaVacio: 'Indica dónde está el problema.',
      nombreDelCampo: 'La ubicación',
      minimoDeCaracteres: 3,
      maximoDeCaracteres: 80,
    );
  }

  /// Para listas desplegables: la persona debe haber elegido una opción.
  static String? validarOpcionElegida(String? opcionElegida) {
    if (opcionElegida == null || opcionElegida.isEmpty) {
      return 'Selecciona una opción.';
    }
    return null;
  }

  static String? _validarTexto(
    String? valorEscrito, {
    required String mensajeSiEstaVacio,
    required String nombreDelCampo,
    required int minimoDeCaracteres,
    required int maximoDeCaracteres,
  }) {
    final texto = (valorEscrito ?? '').trim();

    if (texto.isEmpty) {
      return mensajeSiEstaVacio;
    }

    if (texto.length < minimoDeCaracteres) {
      return '$nombreDelCampo debe tener al menos $minimoDeCaracteres '
          'caracteres.';
    }

    if (texto.length > maximoDeCaracteres) {
      return '$nombreDelCampo no puede pasar de $maximoDeCaracteres '
          'caracteres.';
    }

    return null;
  }
}