# Guía: Configurar Emulador Android para Flutter

## Configuración Recomendada para tu Proyecto

Tu proyecto "El Ventorrillo" requiere:
- **API Level mínimo**: 33+ (según tu configuración de Gradle)
- **Google Play Services**: ✅ Recomendado (tu app usa Firebase)

## Paso a Paso: Configurar el Emulador

### Paso 1: Configuración Actual (Ya lo tienes casi listo)

**Lo que veo en tu configuración:**
- ✅ Dispositivo: Pixel 7 (Excelente elección)
- ✅ API: 36.1 (Más que suficiente para tu app)
- ✅ Google Play Store: Seleccionado (Perfecto para Firebase)
- ✅ Sistema: Google Play Intel x86_64 Atom System Image

### Paso 2: Completar la Configuración

1. **Revisa la configuración actual**:
   - **Name**: "Pixel 7" (o puedes cambiarlo a "Pixel 7 API 36.1")
   - **System Image**: "Google Play Intel x86_64 Atom System Image API 36.1" ✅
   - **Google Play Services**: Seleccionado ✅

2. **Opciones Adicionales (Tab "Additional settings")**:
   - Haz clic en la pestaña **"Additional settings"** si quieres personalizar:
     - **RAM**: Recomendado 2GB o más (2048 MB está bien)
     - **VM heap**: 512 MB es suficiente
     - **Internal Storage**: 2048 MB mínimo
     - **SD Card**: Opcional, 512 MB si lo necesitas

3. **Haz clic en "Finish"**:
   - Tu configuración está lista ✅
   - Haz clic en el botón azul **"Finish"** para crear el emulador

### Paso 3: Iniciar el Emulador

Después de crear el emulador:

1. En **Device Manager** verás tu nuevo emulador "Pixel 7"
2. Haz clic en el botón **Play (▶️)** para iniciarlo
3. **Primera vez**: Puede tardar 2-5 minutos en iniciar
4. **Siguientes veces**: 30-60 segundos

### Paso 4: Verificar que el Emulador Funciona

1. Espera a que el emulador muestre la pantalla de inicio de Android
2. En Android Studio, en el selector "Select Device", debería aparecer tu emulador
3. Verifica desde la terminal:
   ```bash
   flutter devices
   ```
   Deberías ver algo como:
   ```
   Pixel 7 • emulator-5554 • android-x64 • Android 16.0 (API 36)
   ```

## Configuración Recomendada para Flutter

### Opciones Óptimas:

| Configuración | Valor Recomendado | Tu Valor Actual |
|--------------|-------------------|-----------------|
| Dispositivo | Pixel 5, 6, o 7 | ✅ Pixel 7 |
| API Level | 33-36 | ✅ 36.1 |
| Google Play | ✅ Sí (para Firebase) | ✅ Sí |
| RAM | 2GB (2048 MB) | - |
| Storage | 2048 MB mínimo | - |

## Solución de Problemas Común

### El emulador es muy lento:

1. **Habilita aceleración de hardware**:
   - Verifica que tengas instalado HAXM (Intel) o Hyper-V (Windows)
   - Ve a: **Tools → SDK Manager → SDK Tools**
   - Marca "Intel x86 Emulator Accelerator (HAXM installer)"

2. **Reduce la RAM** si tu PC tiene poca memoria:
   - Edita el emulador: **Device Manager → Editar (lápiz) → Show Advanced Settings**
   - Reduce RAM a 1536 MB

### El emulador no aparece en Flutter:

1. Asegúrate de que el emulador esté completamente iniciado (pantalla de Android visible)
2. Ejecuta en la terminal:
   ```bash
   flutter devices
   ```
3. Si no aparece, reinicia el emulador

### Error "HAXM not installed":

1. Ve a: **Tools → SDK Manager → SDK Tools**
2. Marca "Intel x86 Emulator Accelerator (HAXM installer)"
3. Haz clic en "Apply" y sigue las instrucciones
4. Reinicia Android Studio

## Alternativa: Emulador Más Ligero

Si tu computadora es lenta, puedes crear un emulador más ligero:

1. **Dispositivo**: Pixel 3 o 4 (más pequeño)
2. **API**: 33 o 34 (menos recursos)
3. **Sin Google Play**: Si no necesitas Play Store (pero tu app necesita Firebase, así que mejor con Play)

## Comandos Útiles

```bash
# Ver emuladores disponibles
flutter emulators

# Ver emuladores corriendo
flutter devices

# Iniciar emulador desde terminal
flutter emulators --launch <nombre_emulador>

# Ejecutar app en emulador
flutter run
```

## Siguiente Paso

Una vez que tu emulador esté corriendo:

1. En Android Studio, selecciona el emulador en "Select Device"
2. Crea tu configuración Flutter (si no la tienes)
3. Haz clic en **Run (▶️)** o presiona **Shift + F10**

¡Tu app "El Ventorrillo" debería ejecutarse en el emulador!

## Notas Importantes

- ✅ Tu configuración actual es perfecta para Flutter y Firebase
- ✅ API 36.1 es más que suficiente (tu app requiere API 33+)
- ✅ Google Play es necesario para Firebase (ya lo tienes seleccionado)
- ⚠️ La primera vez que inicies el emulador puede tardar varios minutos
- 💡 Usa el emulador más pequeño si tu PC es lenta

¡Todo está listo! Solo haz clic en "Finish" para crear el emulador.
