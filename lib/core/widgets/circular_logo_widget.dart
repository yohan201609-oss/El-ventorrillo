import 'package:flutter/material.dart';

/// Widget que muestra el logo de El Ventorrillo en forma circular
/// 
/// Útil para avatares, iconos de perfil, o cuando se necesita
/// una representación circular del logo.
class CircularLogo extends StatelessWidget {
  /// Tamaño del logo circular. Por defecto 50.0
  final double size;

  const CircularLogo({
    super.key,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/icons/logo_ventorrillo.png',
          fit: BoxFit.cover, // Hace que la imagen cubra todo el círculo
          errorBuilder: (context, error, stackTrace) {
            // Widget de fallback si la imagen no se encuentra
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_not_supported,
                color: Colors.grey[600],
                size: size * 0.5,
              ),
            );
          },
        ),
      ),
    );
  }
}

