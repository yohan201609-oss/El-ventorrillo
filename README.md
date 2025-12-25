# El Ventorrillo

Marketplace digital para la República Dominicana que captura la esencia de un puesto de venta local (variedad y cercanía) pero en un entorno digital moderno.

## Características

- **"Lo Nuestro" (Artesanal)**: Venta de productos locales, hechos a mano y culturales
- **"El Reguero" (Segunda Mano)**: Compraventa general de artículos usados

## Stack Tecnológico

- **Frontend**: Flutter (Última versión estable)
- **Lenguaje**: Dart
- **Gestión de Estado**: Riverpod (con Code Generation)
- **Navegación**: GoRouter
- **Backend**: Firebase (Auth, Firestore, Storage, Cloud Functions)
- **Mapas**: Google Maps Flutter

## Instalación

1. Asegúrate de tener Flutter instalado (SDK >=3.0.0)
2. Instala las dependencias:
```bash
flutter pub get
```

3. Genera los archivos de código (Riverpod, Freezed, etc.):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── core/           # Configuración y utilidades core
│   ├── router/     # Configuración de navegación
│   ├── theme/      # Tema y paleta de colores
│   └── utils/      # Utilidades (formateo, etc.)
├── data/           # Capa de datos
│   └── repositories/
├── domain/          # Capa de dominio
│   └── models/
└── presentation/   # Capa de presentación
    ├── providers/  # Providers de Riverpod
    ├── screens/    # Pantallas
    └── widgets/    # Widgets reutilizables
```

## Paleta de Colores

- **Base**: Blancos limpios y grises suaves
- **Colores Patrios de República Dominicana**:
  - **Rojo Patrio** (#CE1126): Para "Lo Nuestro" (Artesanales)
  - **Azul Patrio** (#002D62): Para "El Reguero" (Segunda Mano)

## Próximas Funcionalidades

- [ ] Onboarding y Autenticación
- [ ] Publicar productos (Montar tu Ventorrillo)
- [ ] Chat integrado para negociación
- [ ] Integración con Google Maps
- [ ] Integración completa con Firebase

