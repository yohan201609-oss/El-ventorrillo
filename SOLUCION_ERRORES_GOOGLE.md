# Solución de Errores de Google Services

Este documento explica cómo solucionar los errores que aparecen en el terminal relacionados con Google Services y Firebase.

## ✅ Estado de tu Configuración

Tu `google-services.json` ya tiene configurado:
- ✅ Package name: `com.ventorrillo.app`
- ✅ SHA-1: `72f17a530f1bebe00ddd1d920f565a8d2d0508e6`

**Próximo paso**: Verifica que Google Sign-In esté habilitado en Firebase Authentication.

---

## 🔴 Errores Encontrados

### 1. Error de GoogleApiManager (Crítico para Google Sign-In)

```
E/GoogleApiManager: Failed to get service from broker.
E/GoogleApiManager: java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'
```

**Causa**: El SHA-1/SHA-256 fingerprint no está configurado en Firebase Console, o Google Sign-In no está habilitado correctamente.

**Solución**:

#### Paso 1: Obtener el SHA-1 Fingerprint

Ejecuta uno de estos comandos en la terminal desde la raíz del proyecto:

**Windows (PowerShell):**
```powershell
cd android
.\gradlew signingReport
```

**Windows (CMD) o Linux/Mac:**
```bash
cd android
./gradlew signingReport
```

Busca en la salida algo como:
```
Variant: debug
Config: debug
Store: C:\Users\...\.android\debug.keystore
Alias: AndroidDebugKey
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

#### Paso 2: Agregar SHA-1 y SHA-256 a Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto "El Ventorrillo"
3. Ve a **Configuración del proyecto** (ícono de engranaje)
4. Desplázate hasta **Tus aplicaciones** → **Android app**
5. Haz clic en la app `com.ventorrillo.app`
6. En la sección **SHA certificate fingerprints**, haz clic en **Agregar huella digital**
7. Pega el **SHA-1** que obtuviste
8. Repite para agregar el **SHA-256**
9. Guarda los cambios

#### Paso 3: Verificar Google Sign-In en Firebase

1. En Firebase Console, ve a **Authentication**
2. Ve a la pestaña **Sign-in method**
3. Verifica que **Google** esté habilitado
4. Si no está habilitado:
   - Haz clic en **Google**
   - Activa el toggle
   - Ingresa el **Email de soporte del proyecto** (puede ser tu email)
   - Guarda

#### Paso 4: Descargar google-services.json Actualizado

Después de agregar los fingerprints, descarga el `google-services.json` actualizado:

1. En Firebase Console → **Configuración del proyecto**
2. En **Tus aplicaciones** → Android app
3. Haz clic en **Descargar google-services.json**
4. Reemplaza el archivo en `android/app/google-services.json`

#### Paso 5: Reconstruir la App

```bash
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

---

### 2. Errores de Índices de Firestore (Normal en Desarrollo)

```
W/Firestore: The query requires an index. You can create it here: https://console.firebase.google.com/...
```

**Causa**: Las consultas compuestas en Firestore requieren índices compuestos.

**Solución**:

1. **Opción Automática (Recomendada)**:
   - Haz clic en el link que aparece en el error
   - Firebase te llevará directamente a la página de creación del índice
   - Haz clic en **Crear índice**
   - Espera a que se complete (puede tomar unos minutos)

2. **Opción Manual**:
   - Ve a Firebase Console → **Firestore Database** → **Índices**
   - Haz clic en **Crear índice**
   - Configura los campos según la consulta:
     - Campo: `type` (Ascendente)
     - Campo: `createdAt` (Descendente)
     - Campo: `__name__` (Descendente)
   - Crea el índice

**Nota**: Estos errores son normales durante el desarrollo. Los índices se crean automáticamente cuando Firebase detecta que son necesarios.

---

### 3. Advertencia de OnBackInvokedCallback (Opcional)

```
W/OnBackInvokedCallback: OnBackInvokedCallback is not enabled for the application.
W/OnBackInvokedCallback: Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.
```

**Causa**: Esta es una característica de Android 13+ para mejorar la navegación con gestos.

**Solución (Opcional)**:

Edita `android/app/src/main/AndroidManifest.xml` y agrega en el tag `<application>`:

```xml
<application
    android:label="El Ventorrillo"
    android:name="${applicationName}"
    android:icon="@mipmap/launcher_icon"
    android:enableOnBackInvokedCallback="true">
    <!-- ... resto del contenido ... -->
</application>
```

**Nota**: Esta advertencia no afecta la funcionalidad de la app, es solo una mejora para Android 13+.

---

## 📋 Tus Fingerprints SHA (Para Copiar y Pegar)

Basado en la ejecución de `gradlew signingReport`, tus fingerprints son:

**SHA-1:**
```
72:F1:7A:53:0F:1B:EB:E0:0D:DD:1D:92:0F:56:5A:8D:2D:05:08:E6
```

**SHA-256:**
```
A3:ED:DC:C7:FF:BF:17:61:96:5A:C7:47:15:14:D1:18:38:39:28:BC:0E:FB:8B:46:AF:84:65:A1:A5:1B:B7:F5
```

**⚠️ Importante**: Estos fingerprints son para la keystore de **debug**. Cuando publiques la app, necesitarás agregar también los fingerprints de tu keystore de **producción**.

---

## ✅ Verificación Final

Después de seguir estos pasos, verifica que:

1. ✅ El SHA-1 y SHA-256 están agregados en Firebase Console
2. ✅ Google Sign-In está habilitado en Firebase Authentication
3. ✅ El `google-services.json` está actualizado
4. ✅ Los índices de Firestore están creados (si usas consultas compuestas)
5. ✅ La app se ejecuta sin errores de GoogleApiManager

---

## 🔍 Comandos Útiles

### Obtener SHA-1/SHA-256 (Alternativa con keytool)

Si `gradlew signingReport` no funciona, puedes usar:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**Windows:**
```bash
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### Verificar Package Name

Asegúrate de que el package name en `android/app/build.gradle.kts` coincida con el de Firebase:

```kotlin
applicationId = "com.ventorrillo.app"
```

---

## 📚 Referencias

- [Firebase - Agregar huellas digitales SHA](https://firebase.google.com/docs/android/setup#add-sha)
- [Google Sign-In Setup](https://firebase.google.com/docs/auth/android/google-signin)
- [Firestore Indexes](https://firebase.google.com/docs/firestore/query-data/indexing)

---

## ⚠️ Notas Importantes

1. **SHA-1/SHA-256 son diferentes para Debug y Release**: Si planeas publicar la app, necesitarás agregar también los fingerprints de la keystore de producción.

2. **Los índices de Firestore pueden tardar**: Después de crear un índice, puede tomar varios minutos en estar disponible.

3. **Google Sign-In requiere configuración correcta**: Asegúrate de que el package name, SHA-1, y SHA-256 coincidan exactamente con lo configurado en Firebase.

