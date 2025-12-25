# Guía para Ejecutar el Proyecto en Android Studio

## Pre-requisitos

Antes de empezar, asegúrate de tener instalado:

1. **Flutter SDK** (versión 3.0.0 o superior)
2. **Android Studio** (versión más reciente recomendada)
3. **Android SDK** (instalado a través de Android Studio)
4. **Java JDK 17** (requerido por tu proyecto)

## Paso 1: Verificar la Instalación de Flutter

1. Abre una terminal (PowerShell o CMD)
2. Ejecuta el siguiente comando para verificar que Flutter esté instalado:

```bash
flutter doctor
```

3. Verifica que todo esté configurado correctamente. Debes ver:
   - ✅ Flutter (versión instalada)
   - ✅ Android toolchain
   - ✅ Android Studio
   - ✅ VS Code o Android Studio

## Paso 2: Abrir el Proyecto en Android Studio

### Opción A: Desde Android Studio directamente

1. Abre **Android Studio**
2. Haz clic en **"Open"** o **"File" → "Open"**
3. Navega a la carpeta del proyecto: `D:\El Ventorrillo`
4. Selecciona la carpeta y haz clic en **"OK"**
5. Android Studio detectará que es un proyecto Flutter y te pedirá configurarlo

### Opción B: Desde la terminal

1. Abre una terminal en la carpeta del proyecto
2. Ejecuta:

```bash
android-studio .
```

## Paso 3: Configurar el SDK de Flutter en Android Studio

1. Una vez abierto el proyecto, ve a **"File" → "Settings"** (o **"Android Studio" → "Preferences"** en Mac)
2. Navega a **"Languages & Frameworks" → "Flutter"**
3. En el campo **"Flutter SDK path"**, especifica la ruta donde tienes instalado Flutter
   - Ejemplo: `C:\src\flutter` o donde lo tengas instalado
4. Haz clic en **"Apply"** y luego en **"OK"**

## Paso 4: Instalar Dependencias del Proyecto

1. Abre la terminal integrada de Android Studio (**View → Tool Windows → Terminal**)
2. Ejecuta:

```bash
flutter pub get
```

Esto instalará todas las dependencias necesarias (Firebase, Riverpod, etc.)

## Paso 5: Configurar un Dispositivo o Emulador

### Opción A: Usar un Emulador Android

1. En Android Studio, ve a **"Tools" → "Device Manager"**
2. Haz clic en **"Create Device"** si no tienes ningún emulador
3. Selecciona un dispositivo (por ejemplo, Pixel 5)
4. Selecciona una imagen del sistema (API 33 o superior recomendado)
5. Haz clic en **"Finish"**
6. Inicia el emulador haciendo clic en el botón de ▶️

### Opción B: Usar un Dispositivo Físico

1. Habilita las **Opciones de Desarrollador** en tu dispositivo Android:
   - Ve a **Configuración → Acerca del teléfono**
   - Toca 7 veces en **"Número de compilación"**
2. Habilita **Depuración USB**:
   - Ve a **Configuración → Opciones de desarrollador**
   - Activa **"Depuración USB"**
3. Conecta tu dispositivo a la computadora mediante USB
4. Acepta la solicitud de depuración USB en tu dispositivo

## Paso 6: Verificar que el Dispositivo está Conectado

En la terminal, ejecuta:

```bash
flutter devices
```

Deberías ver tu dispositivo o emulador listado.

## Paso 7: Ejecutar la Aplicación

### Método 1: Desde Android Studio

1. En la parte superior de Android Studio, verás un selector de dispositivos
2. Selecciona tu dispositivo o emulador de la lista
3. Haz clic en el botón de **"Run"** (▶️) o presiona **Shift + F10**

### Método 2: Desde la Terminal

1. Abre la terminal integrada
2. Ejecuta:

```bash
flutter run
```

3. Flutter detectará automáticamente tu dispositivo/emulador y ejecutará la app

## Paso 8: Verificar la Configuración de Firebase

Tu proyecto usa Firebase, así que asegúrate de que:

1. El archivo `android/app/google-services.json` existe (ya está presente ✅)
2. Firebase esté correctamente configurado en tu proyecto de Firebase Console

## Solución de Problemas Comunes

### Error: "Gradle build failed"

Ejecuta:

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error: "SDK not found"

1. Ve a **"File" → "Project Structure"**
2. Verifica que el **Android SDK** esté configurado correctamente
3. Si no, ve a **"File" → "Settings" → "Appearance & Behavior" → "System Settings" → "Android SDK"**

### Error: "Java version"

Tu proyecto requiere Java 17. Verifica tu versión:

```bash
java -version
```

Si no tienes Java 17, instálalo y configúralo en Android Studio:
- **File → Settings → Build, Execution, Deployment → Build Tools → Gradle**
- Cambia el **"Gradle JDK"** a Java 17

### La app no se ejecuta

1. Ejecuta `flutter doctor -v` para ver detalles
2. Verifica que tengas un dispositivo conectado: `flutter devices`
3. Intenta ejecutar en modo verbose: `flutter run -v`

## Comandos Útiles

```bash
# Limpiar el proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Ver dispositivos disponibles
flutter devices

# Ejecutar la app
flutter run

# Ejecutar en modo release (optimizado)
flutter run --release

# Ver información de Flutter
flutter doctor
```

## Notas Importantes

- Tu proyecto usa **Firebase**, así que necesitas conexión a internet para que funcione correctamente
- El proyecto requiere **Java 17** (configurado en build.gradle.kts)
- El `applicationId` es `com.ventorrillo.app` (importante para Firebase)
- Usa **Riverpod** para el manejo de estado
- Usa **Go Router** para la navegación

¡Listo! Deberías poder ejecutar tu aplicación en Android Studio sin problemas.
