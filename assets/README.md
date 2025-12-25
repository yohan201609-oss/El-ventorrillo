# Assets - El Ventorrillo

Esta carpeta contiene todos los recursos estáticos de la aplicación.

## Estructura

```
assets/
├── images/        # Imágenes de productos, banners, placeholders
├── icons/         # Iconos de la aplicación (SVG, PNG)
├── fonts/         # Fuentes personalizadas (Poppins)
└── animations/    # Animaciones Lottie (opcional)
```

## Uso

### Imágenes

Coloca las imágenes de productos, banners y otros recursos visuales en `assets/images/`.

**Ejemplo de uso en código:**
```dart
Image.asset('assets/images/logo.png')
```

### Iconos

Coloca los iconos de la aplicación en `assets/icons/`. Se recomienda usar SVG para mejor escalabilidad.

**Ejemplo de uso en código:**
```dart
SvgPicture.asset('assets/icons/ventorrillo.svg')
```

### Fuentes

Para usar la fuente Poppins:

1. Descarga la fuente desde [Google Fonts - Poppins](https://fonts.google.com/specimen/Poppins)
2. Coloca los archivos `.ttf` en `assets/fonts/`
3. Descomenta la sección `fonts:` en `pubspec.yaml`
4. Ejecuta `flutter pub get`

**Variantes necesarias:**
- Poppins-Regular.ttf (weight: 400)
- Poppins-Medium.ttf (weight: 500)
- Poppins-SemiBold.ttf (weight: 600)
- Poppins-Bold.ttf (weight: 700)

### Animaciones

Si deseas usar animaciones Lottie, coloca los archivos `.json` en `assets/animations/`.

**Nota:** Requiere agregar el paquete `lottie` a `pubspec.yaml` si se desea usar.

## Convenciones

- **Nombres de archivos**: Usa snake_case (ej: `producto_placeholder.png`)
- **Imágenes de productos**: Se almacenan en Firebase Storage, no en assets
- **Iconos**: Preferir SVG sobre PNG cuando sea posible
- **Tamaños**: Optimiza las imágenes antes de agregarlas al proyecto

