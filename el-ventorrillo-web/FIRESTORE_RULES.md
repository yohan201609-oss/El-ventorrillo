# Reglas de Seguridad de Firestore

Este archivo contiene las reglas de seguridad necesarias para que la aplicación funcione correctamente.

## Instrucciones para Configurar las Reglas

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a **Firestore Database** → **Reglas** (o **Rules**)
4. Copia y pega el contenido del archivo `firestore.rules`
5. Haz clic en **Publicar** (o **Publish**)

## Estructura de las Reglas

Las reglas están organizadas por colecciones:

### 1. Usuarios (`users`)
- Lectura: Solo usuarios autenticados
- Escritura: Solo el propio usuario puede crear/actualizar/eliminar su perfil

### 2. Productos (`products`)
- Lectura: Pública (cualquiera puede ver productos)
- Escritura: Solo usuarios autenticados, y solo pueden modificar sus propios productos

### 3. Conversaciones (`conversations`)
- Lectura: Solo los participantes pueden leer su conversación
- Escritura: Solo los participantes pueden crear/actualizar conversaciones
- Mensajes: Solo el remitente puede crear/actualizar sus mensajes

### 4. Favoritos (`favorites`)
- Lectura: Solo el usuario puede leer sus propios favoritos
- Escritura: Solo el usuario puede crear/eliminar sus propios favoritos

## Notas Importantes

⚠️ **Para Desarrollo**: Si sigues teniendo problemas con permisos durante el desarrollo, puedes usar temporalmente las reglas permisivas del archivo `firestore.rules.dev`:

1. Copia el contenido de `firestore.rules.dev`
2. Pégalo en Firebase Console → Firestore → Reglas
3. Publica las reglas
4. Prueba la funcionalidad
5. **IMPORTANTE**: Una vez que funcione, vuelve a usar las reglas de producción de `firestore.rules`

⚠️ **Advertencia**: Las reglas permisivas solo deben usarse en desarrollo. Nunca las uses en producción.

## Solución Rápida para Desarrollo

Si necesitas una solución rápida para probar:

1. Ve a Firebase Console → Firestore Database → Reglas
2. Usa temporalmente estas reglas (solo para desarrollo):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. Publica las reglas
4. Prueba la funcionalidad
5. **Vuelve a las reglas de producción** después de probar

## Solución de Problemas

### Error: "Missing or insufficient permissions"

1. Verifica que las reglas estén publicadas correctamente
2. Asegúrate de que el usuario esté autenticado
3. Verifica que el usuario tenga los permisos necesarios según las reglas

### Error al crear conversación

1. Verifica que ambos usuarios estén autenticados
2. Asegúrate de que las reglas de `conversations` estén configuradas
3. Verifica que los `participants` en la conversación incluyan al usuario autenticado

