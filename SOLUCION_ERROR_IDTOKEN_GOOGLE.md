# Solución: Error al Obtener idToken de Google en Web

## 🔴 Problema

Al intentar iniciar sesión con Google en Web, aparece el error:

```
Error al iniciar sesión con Google: Exception: Error al obtener credenciales de Google
```

**Causa**: En Web, el método `signIn()` de Google Sign-In puede no proporcionar el `idToken` de manera confiable, aunque el `accessToken` se obtenga correctamente.

## ✅ Soluciones Aplicadas

### 1. Agregado Scope 'openid'

Se agregó el scope `'openid'` a GoogleSignIn para asegurar que se solicite el idToken:

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile', 'openid'],  // ← Agregado 'openid'
);
```

### 2. Reintentos para Obtener idToken

Se implementó un sistema de reintentos (hasta 3 intentos) para obtener el idToken:

```dart
// Si el idToken no está disponible, intentar obtenerlo de nuevo
int retryCount = 0;
while (googleAuth.idToken == null && retryCount < 3) {
  await Future.delayed(const Duration(milliseconds: 500));
  googleAuth = await googleUser.authentication;
  retryCount++;
}
```

### 3. Mensajes de Error Mejorados

Se mejoraron los mensajes de error para ser más descriptivos y útiles.

## 🔍 Verificación

### ¿Cómo Saber Si Funciona?

1. **Intenta iniciar sesión con Google**
2. **Si funciona**: El problema está resuelto
3. **Si aún falla**: Sigue las soluciones adicionales abajo

## 🛠️ Soluciones Adicionales

### Solución 1: Limpiar Sesiones de Google

1. Cierra todas las ventanas del navegador
2. Abre una ventana de incógnito
3. Intenta iniciar sesión con Google nuevamente

### Solución 2: Verificar Configuración de Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto **"el-ventorrillo"**
3. Ve a **Authentication** → **Sign-in method**
4. Verifica que **Google** esté **Habilitado**
5. Verifica que el **Email de soporte del proyecto** esté configurado

### Solución 3: Verificar Client ID

1. Verifica que el Client ID en `web/index.html` sea correcto:
   ```html
   <meta name="google-signin-client_id" content="203743739252-9hkomf2sgbjdqtttoa8ieorgb5alkge4.apps.googleusercontent.com">
   ```

2. Verifica en [Google Cloud Console](https://console.cloud.google.com/):
   - Ve a **APIs & Services** → **Credentials**
   - Busca tu OAuth 2.0 Client ID
   - Verifica que esté configurado para **Web application**
   - Verifica que `localhost` esté en **Authorized JavaScript origins**

### Solución 4: Usar Android/iOS para Desarrollo

Si el problema persiste en Web, considera desarrollar principalmente en:
- **Android**: Funciona de manera más confiable
- **iOS**: También funciona bien

Web puede tener problemas de compatibilidad con Google Sign-In que son difíciles de resolver completamente.

## ⚠️ Nota Importante

Según los logs del terminal, Google está deprecando el método `signIn()` en Web:

```
The `signIn` method is discouraged on the web because it can't reliably provide an `idToken`.
Use `signInSilently` and `renderButton` to authenticate your users instead.
```

**Para producción**, considera migrar a `renderButton`, pero esto requeriría cambios significativos en el código.

## 🆘 Si Aún No Funciona

### Opción 1: Usar Firebase Auth Directamente (Avanzado)

Para Web, podrías usar Firebase Auth directamente con popup en lugar de `google_sign_in`:

```dart
// Esto requeriría cambios significativos en el código
// y usar Firebase Auth Web SDK directamente
```

### Opción 2: Desarrollar en Android/iOS

Para una aplicación móvil como El Ventorrillo, se recomienda:
- **Desarrollo principal**: Android/iOS
- **Web**: Solo para pruebas o si es absolutamente necesario

### Opción 3: Reportar el Problema

Si el problema persiste después de todas las soluciones:
1. Verifica que estés usando las versiones más recientes de los paquetes
2. Revisa los issues en el repositorio de [google_sign_in](https://github.com/flutter/plugins/tree/main/packages/google_sign_in)
3. Considera reportar el problema si no existe una solución

## 📋 Checklist de Verificación

- [ ] Scope 'openid' agregado a GoogleSignIn
- [ ] Sistema de reintentos implementado
- [ ] Google Sign-In habilitado en Firebase Console
- [ ] Client ID correcto en `web/index.html`
- [ ] `localhost` en Authorized JavaScript origins
- [ ] Probado en ventana de incógnito
- [ ] Probado después de limpiar sesiones

## ✅ Conclusión

El código ahora intenta obtener el `idToken` de manera más robusta. Si el problema persiste, puede ser una limitación conocida de Google Sign-In en Web con Flutter. En ese caso, considera desarrollar principalmente en Android/iOS donde Google Sign-In funciona de manera más confiable.

---

**Última actualización**: Después de agregar scope 'openid' y sistema de reintentos

