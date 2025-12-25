# ✅ Verificación Rápida: Google Sign-In

## Estado Actual de tu Configuración

### ✅ Lo que ya está configurado:

1. **Package Name**: `com.ventorrillo.app` ✓
2. **SHA-1 Fingerprint**: `72f17a530f1bebe00ddd1d920f565a8d2d0508e6` ✓ (ya en google-services.json)
3. **google-services.json**: Ubicado correctamente en `android/app/` ✓

### ⚠️ Lo que necesitas verificar:

## Paso 1: Agregar SHA-256 a Firebase Console

Aunque el SHA-1 ya está en el `google-services.json`, es recomendable agregar también el SHA-256 en Firebase Console para evitar problemas:

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **"el-ventorrillo"**
3. Ve a **Configuración del proyecto** (⚙️)
4. En **Tus aplicaciones**, haz clic en tu app Android
5. En **SHA certificate fingerprints**, haz clic en **Agregar huella digital**
6. Pega este SHA-256:
   ```
   A3:ED:DC:C7:FF:BF:17:61:96:5A:C7:47:15:14:D1:18:38:39:28:BC:0E:FB:8B:46:AF:84:65:A1:A5:1B:B7:F5
   ```
7. Guarda

## Paso 2: Verificar que Google Sign-In esté Habilitado

**⚠️ CRÍTICO**: Este es el paso más importante. Sin esto, Google Sign-In no funcionará.

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **"el-ventorrillo"**
3. Ve a **Authentication** → **Sign-in method**
4. Busca **Google** en la lista
5. Verifica que esté **Habilitado** (toggle activado)
6. Si NO está habilitado:
   - Haz clic en **Google**
   - Activa el toggle
   - Ingresa un **Email de soporte del proyecto** (puede ser tu email personal)
   - Haz clic en **Guardar**

## Paso 3: Descargar google-services.json Actualizado

Después de agregar el SHA-256, descarga el archivo actualizado:

1. En Firebase Console → **Configuración del proyecto**
2. En **Tus aplicaciones** → Android app
3. Haz clic en **Descargar google-services.json**
4. Reemplaza el archivo en `android/app/google-services.json`

## Paso 4: Limpiar y Reconstruir

```bash
# Desde la raíz del proyecto
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

## Paso 5: Probar Google Sign-In

1. Ejecuta la app
2. Ve a la pantalla de login
3. Haz clic en **"Continuar con Google"**
4. Deberías ver el selector de cuentas de Google
5. Selecciona una cuenta
6. Deberías iniciar sesión correctamente

---

## 🔍 Si el Error Persiste

### Verificar en Firebase Console:

1. **Project Settings** → **Your apps** → Android app
   - Verifica que el **Package name** sea exactamente: `com.ventorrillo.app`
   - Verifica que ambos SHA-1 y SHA-256 estén listados

2. **Authentication** → **Sign-in method**
   - Verifica que **Google** esté **Enabled** (no solo visible)

3. **Authentication** → **Settings** → **Authorized domains**
   - Para apps móviles, esto no debería ser necesario, pero verifica que no haya restricciones

### Verificar en el Código:

El `google-services.json` debe estar en:
```
android/app/google-services.json
```

Y debe contener el `certificate_hash` que coincide con tu SHA-1.

---

## 📋 Checklist Final

- [ ] SHA-1 agregado en Firebase Console ✓ (ya está en google-services.json)
- [ ] SHA-256 agregado en Firebase Console
- [ ] Google Sign-In habilitado en Authentication → Sign-in method
- [ ] google-services.json actualizado después de agregar SHA-256
- [ ] App reconstruida con `flutter clean` y `flutter run`
- [ ] Google Sign-In funciona correctamente en la app

---

## 🆘 Si Aún No Funciona

El error `GoogleApiManager: Failed to get service from broker` a veces puede ser un **warning no crítico** que no impide que Google Sign-In funcione. 

**Prueba esto:**
1. Intenta usar Google Sign-In en la app
2. Si funciona, el error puede ignorarse (es un warning interno de Google Play Services)
3. Si NO funciona, verifica todos los pasos anteriores

**Errores que SÍ son críticos:**
- `DEVELOPER_ERROR` → Falta configuración en Firebase
- `SIGN_IN_FAILED` → Google Sign-In no está habilitado
- `NETWORK_ERROR` → Problema de conexión

---

## 📞 Información de tu Proyecto

- **Project ID**: `el-ventorrillo`
- **Project Number**: `203743739252`
- **Package Name**: `com.ventorrillo.app`
- **SHA-1**: `72:F1:7A:53:0F:1B:EB:E0:0D:DD:1D:92:0F:56:5A:8D:2D:05:08:E6`
- **SHA-256**: `A3:ED:DC:C7:FF:BF:17:61:96:5A:C7:47:15:14:D1:18:38:39:28:BC:0E:FB:8B:46:AF:84:65:A1:A5:1B:B7:F5`

