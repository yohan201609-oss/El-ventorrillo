# Guía de Despliegue en Vercel - El Ventorrillo Web

Esta guía te ayudará a desplegar `el-ventorrillo-web` en Vercel paso a paso.

## Prerrequisitos

- Cuenta en [Vercel](https://vercel.com) (gratis)
- Código subido a GitHub
- Configuración de Firebase completa

## Paso 1: Preparar el Repositorio

Asegúrate de que tu código está en GitHub y el directorio `el-ventorrillo-web` está en el repositorio.

## Paso 2: Importar Proyecto en Vercel

1. Ve a [vercel.com](https://vercel.com) e inicia sesión
2. Haz clic en "Add New..." → "Project"
3. Selecciona el repositorio `El-ventorrillo` (o `yohan201609-oss/El-ventorrillo`)
4. En la configuración del proyecto:
   - **Root Directory**: Selecciona `el-ventorrillo-web` (importante)
   - **Framework Preset**: Next.js (debería detectarse automáticamente)
   - **Build Command**: `npm run build` (por defecto)
   - **Output Directory**: `.next` (por defecto)

## Paso 3: Configurar Variables de Entorno

Antes de hacer el despliegue, configura las variables de entorno en Vercel:

1. En la pantalla de configuración del proyecto, ve a la sección "Environment Variables"
2. Añade cada una de estas variables:

### Variables Requeridas de Firebase:

```
NEXT_PUBLIC_FIREBASE_API_KEY=tu_api_key_aqui
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=tu-proyecto.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=tu-proyecto-id
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=tu-proyecto.appspot.com
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=123456789
NEXT_PUBLIC_FIREBASE_APP_ID=1:123456789:web:abcdef
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=G-XXXXXXXXXX (opcional)
```

### Cómo Obtener los Valores de Firebase:

1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Selecciona tu proyecto
3. Ve a **Project Settings** (ícono de engranaje) → **General**
4. En la sección "Your apps", selecciona tu app web
5. Copia los valores del objeto `firebaseConfig`

### Variables Opcionales:

```
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=tu_google_maps_api_key (si utilizas Google Maps)
```

**Nota importante**: Marca todas las variables para los tres ambientes:
- ✅ Production
- ✅ Preview  
- ✅ Development

## Paso 4: Configurar Dominios Autorizados en Firebase

Después del primer despliegue, necesitas añadir tu dominio de Vercel a Firebase:

1. Ve a Firebase Console → **Authentication** → **Settings** → **Authorized domains**
2. Haz clic en "Add domain"
3. Añade tu dominio de Vercel (ej: `tu-proyecto.vercel.app`)
4. Si tienes un dominio personalizado, también añádelo

## Paso 5: Desplegar

1. Haz clic en el botón **"Deploy"**
2. Vercel construirá y desplegará tu aplicación
3. Una vez completado, recibirás una URL (ej: `https://tu-proyecto.vercel.app`)

## Paso 6: Verificar el Despliegue

1. Visita la URL proporcionada por Vercel
2. Verifica que la aplicación carga correctamente
3. Prueba la autenticación con Firebase
4. Revisa la consola del navegador para errores

## Actualizaciones Futuras

Una vez configurado, cada push a la rama `main` desplegará automáticamente en producción. Los pushes a otras ramas crearán deployments de preview.

## Comandos Útiles de Vercel CLI

Si prefieres usar la CLI:

```bash
# Instalar Vercel CLI
npm i -g vercel

# Iniciar sesión
vercel login

# Desplegar (desde el directorio el-ventorrillo-web)
cd el-ventorrillo-web
vercel

# Desplegar en producción
vercel --prod

# Ver variables de entorno
vercel env ls

# Añadir variable de entorno
vercel env add NEXT_PUBLIC_FIREBASE_API_KEY
```

## Solución de Problemas

### Error: "Firebase not initialized"
- Verifica que todas las variables de entorno `NEXT_PUBLIC_FIREBASE_*` estén configuradas
- Asegúrate de que las variables están marcadas para el ambiente correcto

### Error: "Auth domain not authorized"
- Añade tu dominio de Vercel en Firebase Console → Authentication → Settings → Authorized domains

### Error de Build
- Revisa los logs de build en Vercel Dashboard
- Verifica que todas las dependencias estén en `package.json`
- Asegúrate de que el "Root Directory" está configurado como `el-ventorrillo-web`

### Variables de entorno no funcionan
- Verifica que las variables empiezan con `NEXT_PUBLIC_` (requerido para Next.js)
- Asegúrate de hacer un nuevo deployment después de añadir variables

## Recursos

- [Documentación de Vercel](https://vercel.com/docs)
- [Next.js en Vercel](https://vercel.com/docs/frameworks/nextjs)
- [Firebase Hosting vs Vercel](https://firebase.google.com/docs/hosting)
