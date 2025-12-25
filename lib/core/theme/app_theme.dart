import 'package:flutter/material.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';

class AppTheme {
  // Paleta de Colores
  // Base: Blancos limpios y grises suaves
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Colores Patrios de República Dominicana
  // Rojo Patrio (para "Lo Nuestro" - Artesanales)
  static const Color red = Color(0xFFCE1126); // Rojo bermellón
  static const Color redLight = Color(0xFFE63946);
  static const Color redDark = Color(0xFFA00E1E);
  
  // Azul Patrio (para "El Reguero" - Segunda Mano)
  static const Color blue = Color(0xFF002D62); // Azul ultramar
  static const Color blueLight = Color(0xFF1E4A7A);
  static const Color blueDark = Color(0xFF001A3D);

  // Mantener compatibilidad con nombres anteriores
  static const Color amber = red;
  static const Color amberLight = redLight;
  static const Color amberDark = redDark;
  static const Color green = blue;
  static const Color greenLight = blueLight;
  static const Color greenDark = blueDark;

  // Colores de texto
  static const Color textPrimary = gray900;
  static const Color textSecondary = gray600;
  static const Color textTertiary = gray500;

  static ThemeData lightTheme(BuildContext context) {
    // Calcular escala basada en el ancho de la pantalla
    final width = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;
    if (width >= Responsive.desktop) {
      scaleFactor = 1.2;
    } else if (width >= Responsive.tablet) {
      scaleFactor = 1.1;
    }
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: red,
        primary: red,
        secondary: blue,
        tertiary: blue,
        surface: white,
        background: gray50,
        error: redDark,
      ),
      scaffoldBackgroundColor: gray50,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 32 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16 * scaleFactor,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16 * scaleFactor,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14 * scaleFactor,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12 * scaleFactor,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: gray300,
            width: 1.5,
          ),
        ),
        color: white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    // Calcular escala basada en el ancho de la pantalla
    final width = MediaQuery.of(context).size.width;
    double scaleFactor = 1.0;
    if (width >= Responsive.desktop) {
      scaleFactor = 1.2;
    } else if (width >= Responsive.tablet) {
      scaleFactor = 1.1;
    }
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: red,
        primary: redLight,
        secondary: blueLight,
        tertiary: blueLight,
        surface: gray800,
        background: gray900,
        error: redLight,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: gray900,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: gray800,
        foregroundColor: white,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: white,
          letterSpacing: -0.5,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 32 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: white,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28 * scaleFactor,
          fontWeight: FontWeight.bold,
          color: white,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18 * scaleFactor,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16 * scaleFactor,
          fontWeight: FontWeight.w500,
          color: white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16 * scaleFactor,
          fontWeight: FontWeight.normal,
          color: white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14 * scaleFactor,
          fontWeight: FontWeight.normal,
          color: white,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12 * scaleFactor,
          fontWeight: FontWeight.normal,
          color: gray400,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: gray700,
            width: 1.5,
          ),
        ),
        color: gray800,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

