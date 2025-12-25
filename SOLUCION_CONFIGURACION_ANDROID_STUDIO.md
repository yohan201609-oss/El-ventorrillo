# Solución: Error de Configuración en Android Studio

## Problema Detectado

Has encontrado el error: **"Broken configuration due to unavailable plugin or invalid configuration data"**

Esto generalmente ocurre cuando:
1. El plugin de Flutter no está instalado en Android Studio
2. La configuración de ejecución está corrupta
3. El SDK de Flutter no está configurado correctamente

## Solución Paso a Paso

### Paso 1: Verificar que el Plugin de Flutter esté Instalado

1. En Android Studio, ve a **File → Settings** (o **Ctrl+Alt+S**)
2. En el panel izquierdo, ve a **Plugins**
3. Busca "Flutter" en la barra de búsqueda
4. Si NO está instalado:
   - Marca la casilla para habilitarlo
   - Si no aparece, haz clic en "Marketplace" y busca "Flutter"
   - Instálalo (esto también instalará Dart automáticamente)
   - Reinicia Android Studio cuando te lo solicite

### Paso 2: Configurar el SDK de Flutter

1. Ve a **File → Settings** (o **Ctrl+Alt+S**)
2. Navega a **Languages & Frameworks → Flutter**
3. En **"Flutter SDK path"**, especifica la ruta donde tienes Flutter instalado
   - Ejemplo común: `C:\src\flutter`
   - O ejecuta en la terminal: `where flutter` para encontrar la ruta
4. Haz clic en **"Apply"** y luego en **"OK"**

### Paso 3: Eliminar la Configuración Rota (Ya hecho ✅)

Ya he eliminado el archivo de configuración corrupto `.idea/runConfigurations/main_dart.xml`.

### Paso 4: Crear una Nueva Configuración de Ejecución

1. En Android Studio, haz clic en el menú desplegable de configuración (donde dice "Add Configuration...")
2. Selecciona **"Edit Configurations..."**
3. Haz clic en el botón **"+"** (arriba a la izquierda)
4. Selecciona **"Flutter"** (NO "Flutter Test" ni "Dart")
5. Configura los siguientes campos:
   - **Name**: `El Ventorrillo` (o el nombre que prefieras)
   - **Dart entrypoint**: Haz clic en la carpeta y selecciona `lib/main.dart`
     - O escribe manualmente: `$PROJECT_DIR$/lib/main.dart`
   - **Additional run args**: Déjalo vacío (por ahora)
   - **Working directory**: Déjalo vacío (usará el directorio del proyecto)
6. Haz clic en **"Apply"** y luego en **"OK"**

### Paso 5: Solucionar el Problema del Emulador

Si tu emulador muestra "System UI isn't responding":

**Opción A: Reiniciar el Emulador**
1. Cierra el emulador completamente
2. En Android Studio, ve a **Tools → Device Manager**
3. Haz clic en el botón de **Stop** (⏹️) si está corriendo
4. Luego haz clic en **Start** (▶️) para iniciarlo de nuevo

**Opción B: Crear un Nuevo Emulador**
1. Ve a **Tools → Device Manager**
2. Haz clic en **"Create Device"**
3. Selecciona un dispositivo (por ejemplo, Pixel 5)
4. Descarga una imagen del sistema (API 33 o superior)
5. Completa la configuración y haz clic en **"Finish"**
6. Inicia el nuevo emulador

### Paso 6: Ejecutar la Aplicación

**Método 1: Desde Android Studio**
1. Asegúrate de que tu nueva configuración "El Ventorrillo" esté seleccionada
2. Selecciona un dispositivo/emulador del menú desplegable "Select Device"
3. Haz clic en el botón **"Run"** (▶️) o presiona **Shift + F10**

**Método 2: Desde la Terminal (Alternativa)**

Si aún tienes problemas, puedes ejecutar desde la terminal:

1. Abre la terminal integrada: **View → Tool Windows → Terminal**
2. Ejecuta:
   ```bash
   flutter pub get
   flutter devices
   flutter run
   ```

### Paso 7: Si el Problema Persiste

Si después de seguir estos pasos aún ves el error:

1. **Cierra y vuelve a abrir Android Studio**
2. **Invalida cachés y reinicia**:
   - Ve a **File → Invalidate Caches...**
   - Marca todas las opciones
   - Haz clic en **"Invalidate and Restart"**
3. **Verifica Flutter desde la terminal**:
   ```bash
   flutter doctor -v
   ```
4. **Asegúrate de tener las dependencias instaladas**:
   ```bash
   flutter pub get
   ```

## Verificación Rápida

Para verificar que todo está configurado correctamente:

1. ✅ Plugin de Flutter instalado en Android Studio
2. ✅ SDK de Flutter configurado en Settings
3. ✅ Configuración de ejecución Flutter creada (no rota)
4. ✅ Emulador/dispositivo disponible y funcionando
5. ✅ Dependencias instaladas (`flutter pub get`)

## Comandos Útiles

```bash
# Verificar configuración de Flutter
flutter doctor -v

# Ver dispositivos disponibles
flutter devices

# Instalar dependencias
flutter pub get

# Ejecutar la app
flutter run

# Limpiar y reconstruir
flutter clean
flutter pub get
```

¡Deberías poder ejecutar tu aplicación ahora sin problemas!
