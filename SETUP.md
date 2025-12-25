# Guía de Configuración - El Ventorrillo

## Requisitos Previos

1. **Flutter SDK**: Asegúrate de tener Flutter instalado (versión >=3.0.0)
   ```bash
   flutter --version
   ```

2. **Dart SDK**: Incluido con Flutter

## Pasos de Instalación

### 1. Instalar Dependencias

```bash
flutter pub get
```

### 2. Generar Código (Riverpod, Freezed, etc.)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Nota**: Si encuentras errores, intenta con:
```bash
flutter pub run build_runner build --delete-conflicting-outputs --verbose
```

### 3. Configurar Fuente Poppins (Opcional)

Para usar la fuente Poppins, agrega el siguiente código en `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: fonts/Poppins-Regular.ttf
        - asset: fonts/Poppins-Medium.ttf
          weight: 500
        - asset: fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: fonts/Poppins-Bold.ttf
          weight: 700
```

Luego descarga la fuente desde [Google Fonts](https://fonts.google.com/specimen/Poppins) y colócala en la carpeta `fonts/`.

**Alternativa**: Si no quieres usar Poppins, el tema usará la fuente del sistema.

### 4. Ejecutar la Aplicación

```bash
# Para desarrollo
flutter run

# Para un dispositivo específico
flutter run -d <device-id>

# Para ver dispositivos disponibles
flutter devices
```

## Configuración de Firebase (Próximamente)

Cuando estés listo para integrar Firebase:

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Instala FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
3. Configura Firebase:
   ```bash
   flutterfire configure
   ```
4. Descomenta la línea de inicialización de Firebase en `lib/main.dart`

## Estructura del Proyecto

```
lib/
├── core/                    # Configuración core
│   ├── router/             # Navegación (GoRouter)
│   ├── theme/              # Tema y colores
│   └── utils/              # Utilidades (formateo, etc.)
├── data/                   # Capa de datos
│   └── repositories/       # Repositorios (Mock y Firebase)
├── domain/                 # Capa de dominio
│   └── models/             # Modelos de negocio
└── presentation/           # Capa de presentación
    ├── providers/          # Providers de Riverpod
    ├── screens/            # Pantallas
    └── widgets/            # Widgets reutilizables
```

## Comandos Útiles

```bash
# Analizar código
flutter analyze

# Formatear código
dart format lib/

# Limpiar build
flutter clean

# Regenerar código después de cambios
flutter pub run build_runner watch
```

## Solución de Problemas

### Error: "Target of URI doesn't exist"
- Ejecuta `flutter pub get` primero
- Luego ejecuta `flutter pub run build_runner build --delete-conflicting-outputs`

### Error: "No devices found"
- Asegúrate de tener un emulador corriendo o un dispositivo conectado
- Para Android: Abre Android Studio y crea/inicia un AVD
- Para iOS: Abre Xcode y configura un simulador

### Error con Riverpod Code Generation
- Asegúrate de tener `build.yaml` en la raíz del proyecto
- Verifica que `riverpod_generator` esté en `dev_dependencies`

