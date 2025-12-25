# Configurar Google Sign-In para Web

## 🔴 Problema

Al intentar usar Google Sign-In en Web, aparece el error:

```
ClientID not set. Either set it on a <meta name="google-signin-client_id" content="CLIENT_ID" /> tag, or pass clientId when initializing GoogleSignIn
```

## ✅ Solución

Necesitas obtener el **OAuth 2.0 Client ID** de Firebase y agregarlo a la aplicación.

## 📋 Paso 1: Obtener el Client ID desde Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **"el-ventorrillo"**
3. Ve a **Configuración del proyecto** (⚙️)
4. En la sección **Tus aplicaciones**, busca tu app **Web**
5. Haz clic en la app Web
6. Busca la sección **OAuth 2.0 Client IDs** o **Client IDs**
7. Copia el **Client ID** (tiene el formato: `203743739252-XXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com`)

**Alternativa**: Si no ves el Client ID directamente:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona el proyecto **"el-ventorrillo"**
3. Ve a **APIs & Services** → **Credentials**
4. Busca **OAuth 2.0 Client IDs**
5. Busca el que tiene tipo **Web application**
6. Copia el **Client ID**

## 📋 Paso 2: Agregar el Client ID al HTML

Edita el archivo `web/index.html` y reemplaza el placeholder:

```html
<!-- Reemplaza XXXXXXXXXXXXXXXXXXXX con tu Client ID real -->
<meta name="google-signin-client_id" content="TU_CLIENT_ID_AQUI">
```

**Ejemplo** (con un Client ID ficticio):
```html
<meta name="google-signin-client_id" content="203743739252-abc123def456ghi789jkl.apps.googleusercontent.com">
```

## 📋 Paso 3: Verificar la Configuración

Después de agregar el Client ID:

1. Guarda el archivo `web/index.html`
2. Reinicia la aplicación web:
   ```powershell
   flutter run -d chrome
   ```
3. Intenta iniciar sesión con Google
4. Debería funcionar correctamente

## 🔍 Verificación Adicional

### Verificar que Google Sign-In esté Habilitado

1. En Firebase Console → **Authentication** → **Sign-in method**
2. Verifica que **Google** esté **Habilitado** (toggle activado)
3. Si no está habilitado, actívalo y guarda

### Verificar Dominios Autorizados

1. En Firebase Console → **Authentication** → **Settings** → **Authorized domains**
2. Verifica que `localhost` esté en la lista (debería estar por defecto)
3. Si planeas desplegar en un dominio, agrégalo aquí

## ⚠️ Notas Importantes

1. **El Client ID es diferente para cada plataforma**:
   - Web tiene su propio Client ID
   - Android usa SHA-1/SHA-256 (ya configurado)
   - iOS tiene su propio Client ID

2. **No compartas tu Client ID públicamente** si planeas restringir el acceso, pero para desarrollo local está bien.

3. **Para producción**: Considera restringir los dominios autorizados en Google Cloud Console.

## 🆘 Si Aún No Funciona

### Verificar el formato del Client ID

El Client ID debe tener el formato:
```
NUMERO_PROYECTO-XXXXXXXXXXXX.apps.googleusercontent.com
```

### Verificar que el meta tag esté en el lugar correcto

El meta tag debe estar dentro de `<head>` y antes de `</head>`:

```html
<head>
  ...
  <meta name="google-signin-client_id" content="TU_CLIENT_ID">
  ...
</head>
```

### Limpiar y reconstruir

```powershell
flutter clean
flutter pub get
flutter run -d chrome
```

---

**Última actualización**: Después de agregar el meta tag en `web/index.html`

