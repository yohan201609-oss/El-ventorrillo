import 'package:flutter/material.dart';

/// Utilidades para diseño responsive
class Responsive {
  /// Breakpoints para diferentes tamaños de pantalla
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1920;

  /// Obtiene el ancho de la pantalla
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtiene la altura de la pantalla
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Verifica si es móvil
  static bool isMobile(BuildContext context) {
    return width(context) < mobile;
  }

  /// Verifica si es tablet
  static bool isTablet(BuildContext context) {
    return width(context) >= mobile && width(context) < tablet;
  }

  /// Verifica si es desktop
  static bool isDesktop(BuildContext context) {
    return width(context) >= tablet && width(context) < desktop;
  }

  /// Verifica si es desktop grande
  static bool isLargeDesktop(BuildContext context) {
    return width(context) >= desktop;
  }

  /// Obtiene el número de columnas para el grid según el tamaño de pantalla
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else if (isDesktop(context)) {
      return 4;
    } else {
      return 5;
    }
  }

  /// Obtiene el padding horizontal según el tamaño de pantalla
  static double getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else if (isDesktop(context)) {
      return 32.0;
    } else {
      return 48.0;
    }
  }

  /// Obtiene el padding vertical según el tamaño de pantalla
  static double getVerticalPadding(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 20.0;
    } else {
      return 24.0;
    }
  }

  /// Obtiene el tamaño de fuente escalado según el tamaño de pantalla
  static double getScaledFontSize(BuildContext context, double baseSize) {
    final width = Responsive.width(context);
    if (width < mobile) {
      return baseSize;
    } else if (width < tablet) {
      return baseSize * 1.1;
    } else if (width < desktop) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.3;
    }
  }

  /// Obtiene el ancho máximo del contenido según el tamaño de pantalla
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 800;
    } else if (isDesktop(context)) {
      return 1200;
    } else {
      return 1400;
    }
  }

  /// Obtiene el spacing entre elementos según el tamaño de pantalla
  static double getSpacing(BuildContext context, {double mobile = 8.0, double? tablet, double? desktop}) {
    if (isMobile(context)) {
      return mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile * 1.5;
    } else {
      return desktop ?? mobile * 2;
    }
  }

  /// Widget que adapta el contenido según el tamaño de pantalla
  static Widget responsive({
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
    required BuildContext context,
  }) {
    if (isLargeDesktop(context) && desktop != null) {
      return desktop;
    } else if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }
}

