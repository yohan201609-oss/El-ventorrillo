# Configurar CORS para Firebase Storage

## 🔴 Problema

Las imágenes de Firebase Storage no se cargan en desarrollo local (`localhost`) debido a errores de CORS:

```
Access to image at 'https://firebasestorage.googleapis.com/...' from origin 'http://localhost:51083' 
has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

## ✅ Solución: Configurar CORS en Firebase Storage

### Opción 1: Usando Google Cloud Console (Recomendado)

1. **Abre Google Cloud Console**:
   - Ve a: https://console.cloud.google.com/
   - Selecciona tu proyecto: `el-ventorrillo`

2. **Navega a Cloud Storage**:
   - En el menú lateral, busca "Cloud Storage" → "Buckets"
   - O ve directamente a: https://console.cloud.google.com/storage/browser

3. **Selecciona tu bucket**:
   - Busca el bucket: `el-ventorrillo.firebasestorage.app`
   - Haz clic en el nombre del bucket

4. **Configura CORS**:
   - Haz clic en la pestaña **"Configuration"** o **"Configuración"**
   - Busca la sección **"CORS configuration"** o **"Configuración CORS"**
   - Haz clic en **"Edit CORS configuration"** o **"Editar configuración CORS"**

5. **Agrega la siguiente configuración**:

```json
[
  {
    "origin": ["http://localhost:*", "https://localhost:*"],
    "method": ["GET", "HEAD"],
    "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
    "maxAgeSeconds": 3600
  },
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]
```

6. **Guarda los cambios**

### Opción 2: Usando gsutil (Línea de comandos)

1. **Instala Google Cloud SDK** (si no lo tienes):
   - Descarga desde: https://cloud.google.com/sdk/docs/install
   - O usa: `curl https://sdk.cloud.google.com | bash`

2. **Autentica gsutil**:
   ```bash
   gcloud auth login
   gcloud config set project el-ventorrillo
   ```

3. **Crea un archivo `cors.json`** en la raíz del proyecto:

```json
[
  {
    "origin": ["http://localhost:*", "https://localhost:*"],
    "method": ["GET", "HEAD"],
    "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
    "maxAgeSeconds": 3600
  },
  {
    "origin": ["*"],
    "method": ["GET", "HEAD"],
    "responseHeader": ["Content-Type"],
    "maxAgeSeconds": 3600
  }
]
```

4. **Aplica la configuración CORS**:
   ```bash
   gsutil cors set cors.json gs://el-ventorrillo.firebasestorage.app
   ```

5. **Verifica la configuración**:
   ```bash
   gsutil cors get gs://el-ventorrillo.firebasestorage.app
   ```

### Opción 3: Configuración para Producción también

Si quieres que funcione tanto en desarrollo como en producción, usa esta configuración:

```json
[
  {
    "origin": [
      "http://localhost:*",
      "https://localhost:*",
      "https://tu-dominio.com",
      "https://www.tu-dominio.com"
    ],
    "method": ["GET", "HEAD"],
    "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
    "maxAgeSeconds": 3600
  }
]
```

Reemplaza `tu-dominio.com` con tu dominio de producción.

## 🔍 Verificación

Después de configurar CORS:

1. **Espera unos minutos** para que los cambios se propaguen
2. **Recarga la aplicación** en el navegador (Ctrl+Shift+R o Cmd+Shift+R)
3. **Verifica en la consola del navegador** que no haya más errores de CORS
4. **Las imágenes deberían cargarse correctamente**

## 📝 Notas Importantes

1. **Los cambios pueden tardar unos minutos** en aplicarse
2. **En producción**, asegúrate de agregar tu dominio real a la lista de orígenes permitidos
3. **No uses `"origin": ["*"]` en producción** por razones de seguridad
4. **Solo permite métodos necesarios** (GET y HEAD para lectura de imágenes)

## 🆘 Si el Problema Persiste

1. **Verifica que el bucket sea correcto**: El nombre debe ser `el-ventorrillo.firebasestorage.app`
2. **Limpia la caché del navegador**: Ctrl+Shift+Delete
3. **Prueba en modo incógnito**: Para descartar problemas de caché
4. **Verifica los permisos**: Asegúrate de tener permisos de administrador en el proyecto

## 🔗 Referencias

- [Firebase Storage CORS Documentation](https://firebase.google.com/docs/storage/web/download-files#cors_configuration)
- [Google Cloud Storage CORS](https://cloud.google.com/storage/docs/configuring-cors)

