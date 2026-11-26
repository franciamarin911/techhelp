import 'package:material_ui/material_ui.dart';

/// Tema visual de TECHHELP (Material 3), basado en los bocetos de la Etapa 2.
class TemaApp {
  static const Color colorPrimario = Color(0xFF1D4ED8);
  static const Color colorFondo = Color(0xFFF4F6FA);
  static const Color colorTextoPrincipal = Color(0xFF0F172A);

  static ThemeData get temaClaro {
    final esquemaDeColores = ColorScheme.fromSeed(
      seedColor: colorPrimario,
      brightness: Brightness.light,
    );

    final formaRedondeada = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquemaDeColores,
      scaffoldBackgroundColor: colorFondo,
      appBarTheme: const AppBarTheme(
        backgroundColor: colorFondo,
        foregroundColor: colorTextoPrincipal,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: formaRedondeada,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: formaRedondeada,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}