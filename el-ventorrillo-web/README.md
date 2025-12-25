This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Despliegue en Vercel

### Opción 1: Despliegue desde GitHub (Recomendado)

1. **Sube tu código a GitHub** (si aún no lo has hecho):
   ```bash
   git add .
   git commit -m "Preparar para despliegue en Vercel"
   git push
   ```

2. **Ve a [Vercel](https://vercel.com)** e inicia sesión con tu cuenta de GitHub

3. **Importa el repositorio**:
   - Haz clic en "Add New..." → "Project"
   - Selecciona el repositorio `El-ventorrillo`
   - En "Root Directory", selecciona `el-ventorrillo-web`

4. **Configura las variables de entorno**:
   Antes de desplegar, añade estas variables en la sección "Environment Variables":
   - `NEXT_PUBLIC_FIREBASE_API_KEY`
   - `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN`
   - `NEXT_PUBLIC_FIREBASE_PROJECT_ID`
   - `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET`
   - `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID`
   - `NEXT_PUBLIC_FIREBASE_APP_ID`
   - `NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID` (opcional)
   - `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` (si se utiliza)

5. **Configura el proyecto**:
   - Framework Preset: Next.js
   - Root Directory: `el-ventorrillo-web`
   - Build Command: `npm run build` (por defecto)
   - Output Directory: `.next` (por defecto)

6. **Despliega**: Haz clic en "Deploy"

### Opción 2: Despliegue usando Vercel CLI

1. **Instala Vercel CLI**:
   ```bash
   npm i -g vercel
   ```

2. **Navega al directorio del proyecto web**:
   ```bash
   cd el-ventorrillo-web
   ```

3. **Inicia sesión en Vercel**:
   ```bash
   vercel login
   ```

4. **Despliega**:
   ```bash
   vercel
   ```
   Sigue las instrucciones en la terminal. La primera vez te pedirá:
   - Confirmar el directorio del proyecto
   - Configurar las variables de entorno

5. **Para añadir variables de entorno después**:
   ```bash
   vercel env add NEXT_PUBLIC_FIREBASE_API_KEY
   # Repite para cada variable necesaria
   ```

6. **Para desplegar en producción**:
   ```bash
   vercel --prod
   ```

### Configuración de Firebase

Asegúrate de que las siguientes URLs estén configuradas en Firebase Console:

1. **Authentication → Settings → Authorized domains**: Añade tu dominio de Vercel (ej: `tu-proyecto.vercel.app`)

2. **Firestore Database → Rules**: Configura las reglas de seguridad apropiadas

3. **Storage → Rules**: Configura las reglas de seguridad para Storage

### Variables de Entorno Requeridas

Las siguientes variables de entorno deben estar configuradas en Vercel:

- `NEXT_PUBLIC_FIREBASE_API_KEY` - API Key de Firebase
- `NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN` - Dominio de autenticación (ej: `tu-proyecto.firebaseapp.com`)
- `NEXT_PUBLIC_FIREBASE_PROJECT_ID` - ID del proyecto Firebase
- `NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET` - Bucket de Storage (ej: `tu-proyecto.appspot.com`)
- `NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID` - Sender ID para mensajería
- `NEXT_PUBLIC_FIREBASE_APP_ID` - App ID de Firebase
- `NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID` - Measurement ID (opcional, para Analytics)

**Nota**: Todas las variables que empiezan con `NEXT_PUBLIC_` son expuestas al cliente. Nunca expongas secretos o claves privadas con este prefijo.

### Referencias

- [Vercel Documentation](https://vercel.com/docs)
- [Next.js Deployment](https://nextjs.org/docs/app/building-your-application/deploying)
