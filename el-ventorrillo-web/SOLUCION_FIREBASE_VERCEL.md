# Solución: Error de Conexión a Firebase en Vercel

Si ves el error "Error al cargar los productos. Por favor, verifica tu conexión a Firebase" en tu aplicación desplegada en Vercel, sigue estos pasos:

## Paso 1: Añadir Dominio de Vercel a Firebase

**CRÍTICO**: Debes añadir tu dominio de Vercel a la lista de dominios autorizados en Firebase.

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **"el-ventorrillo"**
3. Ve a **Authentication** → **Settings** (Configuración)
4. Baja hasta la sección **"Authorized domains"** (Dominios autorizados)
5. Haz clic en **"Add domain"** (Añadir dominio)
6. Añade tu dominio de Vercel:
   - `el-ventorrillo.vercel.app` (dominio principal)
   - Si tienes un dominio personalizado, también añádelo
7. Haz clic en **"Add"**

**Nota**: Puede tomar unos minutos para que los cambios surtan efecto.

## Paso 2: Verificar Variables de Entorno en Vercel

Asegúrate de que todas las variables de entorno estén configuradas correctamente:

1. Ve a tu proyecto en [Vercel Dashboard](https://vercel.com/dashboard)
2. Ve a **Settings** → **Environment Variables**
3. Verifica que todas estas variables estén presentes:
   - `NEXT_PUBLIC_FIREBASE_API_KEY`
   - `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN`
   - `NEXT_PUBLIC_FIREBASE_PROJECT_ID`
   - `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET`
   - `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID`
   - `NEXT_PUBLIC_FIREBASE_APP_ID`
   - `NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID` (opcional)

4. Asegúrate de que estén marcadas para los tres ambientes:
   - ✅ Production
   - ✅ Preview
   - ✅ Development

## Paso 3: Verificar Reglas de Firestore

Las reglas de Firestore deben permitir lectura pública de productos:

1. Ve a Firebase Console → **Firestore Database** → **Rules**
2. Verifica que tengas estas reglas para productos:

```javascript
match /products/{productId} {
  allow read: if true;  // Lectura pública
  allow create: if request.auth != null 
                && request.resource.data.sellerId == request.auth.uid;
  allow update: if request.auth != null 
                && resource.data.sellerId == request.auth.uid;
  allow delete: if request.auth != null 
                && resource.data.sellerId == request.auth.uid;
}
```

3. Si no las tienes, cópialas y haz clic en **"Publish"**

## Paso 4: Hacer Redeploy en Vercel

Después de hacer los cambios anteriores:

1. Ve a Vercel Dashboard → Tu proyecto
2. Ve a la pestaña **"Deployments"**
3. Encuentra el último deployment
4. Haz clic en los tres puntos (⋯) → **"Redeploy"**
5. Espera a que se complete el deployment

## Paso 5: Verificar en el Navegador

1. Abre tu aplicación en el navegador: `https://el-ventorrillo.vercel.app`
2. Abre las **Herramientas de Desarrollador** (F12)
3. Ve a la pestaña **Console**
4. Busca errores relacionados con Firebase
5. Si ves errores, compártelos para diagnosticar el problema

## Errores Comunes y Soluciones

### Error: "Firebase: Error (auth/unauthorized-domain)"

**Solución**: El dominio no está en la lista de dominios autorizados. Sigue el **Paso 1**.

### Error: "Missing or insufficient permissions"

**Solución**: Las reglas de Firestore no permiten la lectura. Sigue el **Paso 3**.

### Error: "Firebase: Error (auth/api-key-not-valid)"

**Solución**: La API Key no es correcta. Verifica las variables de entorno en Vercel (Paso 2).

### Error: "Firebase no está configurado"

**Solución**: Las variables de entorno no están configuradas. Sigue el **Paso 2**.

## Verificación Final

Después de seguir todos los pasos:

1. ✅ El dominio de Vercel está en Firebase Authorized domains
2. ✅ Todas las variables de entorno están configuradas en Vercel
3. ✅ Las reglas de Firestore permiten lectura pública de productos
4. ✅ Se hizo un redeploy en Vercel
5. ✅ La aplicación carga sin errores en la consola

Si después de seguir todos estos pasos el problema persiste, verifica:

- Los logs del deployment en Vercel para ver si hay errores durante el build
- La consola del navegador para ver errores específicos de Firebase
- Que las variables de entorno tengan los valores correctos (sin espacios extra, sin comillas)

## Contacto

Si el problema persiste, comparte:
- El error exacto de la consola del navegador
- Una captura de pantalla de las variables de entorno en Vercel (ocultando los valores)
- Una captura de pantalla de los dominios autorizados en Firebase

