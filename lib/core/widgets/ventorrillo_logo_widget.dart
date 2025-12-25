import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar el logo de El Ventorrillo
/// 
/// Por defecto muestra solo la imagen del logo.
/// Si [showText] es true, muestra la imagen junto con el texto "El Ventorrillo".
class VentorrilloLogo extends StatelessWidget {
  /// Altura del logo. Por defecto 40.0 (tamaño óptimo para AppBar)
  final double? height;
  
  /// Ancho del logo. Por defecto 120.0 (formato rectangular)
  final double? width;
  
  /// Ajuste de la imagen. Por defecto BoxFit.contain para mantener proporciones
  final BoxFit fit;
  
  /// Si es true, muestra el texto "El Ventorrillo" al lado del logo
  final bool showText;

  const VentorrilloLogo({
    super.key,
    this.height = 40.0,
    this.width = 120.0,
    this.fit = BoxFit.contain,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calcular el radio de redondeo - usar un valor más grande y visible
    // Para logos grandes, usar un radio más generoso
    final minDimension = (height != null && width != null) 
        ? (height! < width! ? height! : width!) 
        : 40.0;
    // Usar 25% del tamaño menor para un redondeo más visible
    final borderRadius = minDimension * 0.25;
    // Mínimo de 20px y máximo de 40px para que siempre sea visible
    final finalRadius = borderRadius.clamp(20.0, 40.0);
    
    // Contenedor con bordes redondeados usando Container con BoxDecoration
    final logoWidget = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(finalRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(finalRadius),
        child: Image.asset(
          'assets/icons/logo_ventorrillo.png',
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // Widget de fallback si la imagen no se encuentra
            return Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(finalRadius),
              ),
              child: const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );

    // Si showText es true, mostrar logo + texto
    if (showText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logoWidget,
          const SizedBox(width: 8),
          Text(
            'El Ventorrillo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
          ),
        ],
      );
    }

    // Solo mostrar el logo
    return logoWidget;
  }
}

