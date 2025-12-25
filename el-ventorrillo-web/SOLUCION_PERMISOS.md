# Solución Rápida para Error de Permisos

## Error: "Missing or insufficient permissions"

Si estás viendo este error al intentar contactar a un vendedor, sigue estos pasos:

### Solución Rápida (Para Desarrollo)

1. **Ve a Firebase Console:**
   - https://console.firebase.google.com/
   - Selecciona tu proyecto

2. **Ve a Firestore Database → Reglas**

3. **Copia y pega estas reglas (SOLO PARA DESARROLLO):**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Reglas permisivas para desarrollo
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

4. **Haz clic en "Publicar"**

5. **Prueba nuevamente el botón "Contactar Vendedor"**

### ⚠️ IMPORTANTE

Estas reglas son **SOLO PARA DESARROLLO**. Una vez que verifiques que todo funciona:

1. Vuelve a Firebase Console → Firestore → Reglas
2. Copia el contenido del archivo `firestore.rules` (las reglas de producción)
3. Pégalo y publica

### Verificación

Después de cambiar las reglas:

1. Asegúrate de estar **autenticado** en la aplicación
2. Intenta contactar a un vendedor
3. Verifica en la consola del navegador que no haya errores
4. Verifica en Firebase Console → Firestore → Datos que se cree la conversación

### Si el problema persiste

1. Verifica que estés autenticado:
   - Ve a `/login` e inicia sesión
   - Verifica en Firebase Console → Authentication que tu usuario aparezca

2. Limpia la caché del navegador:
   - Presiona `Ctrl + Shift + Delete`
   - Selecciona "Caché" y "Cookies"
   - Limpia y recarga la página

3. Verifica las reglas en Firebase Console:
   - Asegúrate de que las reglas se hayan publicado correctamente
   - Deberías ver un mensaje de confirmación

