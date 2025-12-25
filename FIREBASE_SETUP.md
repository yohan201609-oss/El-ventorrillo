# Guía de Configuración de Firebase - El Ventorrillo

Esta guía te ayudará a configurar Firebase Authentication y Firestore para el sistema de registro de usuarios de El Ventorrillo.

## 🎯 ¿Necesitas un Dominio?

**¡NO!** No necesitas un dominio para usar Firebase con aplicaciones móviles. Firebase funciona perfectamente sin dominio para:
- ✅ Aplicaciones Android
- ✅ Aplicaciones iOS
- ✅ Aplicaciones de escritorio (Windows, macOS, Linux)

**Solo necesitarías un dominio si:**
- Planeas usar la aplicación en web (navegador)
- Quieres usar funciones específicas de Firebase Hosting

Para esta guía, asumimos que estás creando una **aplicación móvil**, por lo que **NO necesitas dominio**.

## Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Paso 1: Crear Proyecto en Firebase Console](#paso-1-crear-proyecto-en-firebase-console)
3. [Paso 2: Configurar Firebase Authentication](#paso-2-configurar-firebase-authentication)
4. [Paso 3: Configurar Firestore Database](#paso-3-configurar-firestore-database)
5. [Paso 4: Instalar FlutterFire CLI](#paso-4-instalar-flutterfire-cli)
6. [Paso 5: Configurar Firebase en el Proyecto Flutter](#paso-5-configurar-firebase-en-el-proyecto-flutter)
7. [Paso 6: Habilitar Firebase en el Código](#paso-6-habilitar-firebase-en-el-código)
8. [Paso 7: Configurar Reglas de Seguridad de Firestore](#paso-7-configurar-reglas-de-seguridad-de-firestore)
9. [Paso 8: Probar la Configuración](#paso-8-probar-la-configuración)
10. [Solución de Problemas](#solución-de-problemas)

---

## Requisitos Previos

- Cuenta de Google (para acceder a Firebase Console)
- Flutter SDK instalado (versión >=3.0.0)
- Dart SDK (incluido con Flutter)
- Proyecto Flutter configurado y funcionando

**✅ NO necesitas:**
- Un dominio web (solo necesario si planeas usar la app en web)
- Un servidor propio
- Configuración de DNS

---

## Paso 1: Crear Proyecto en Firebase Console

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Haz clic en **"Agregar proyecto"** o **"Add project"**
3. Ingresa el nombre del proyecto: **"El Ventorrillo"** (o el nombre que prefieras)
4. Opcionalmente, puedes habilitar Google Analytics (recomendado para producción)
5. Haz clic en **"Crear proyecto"** o **"Create project"**
6. Espera a que Firebase termine de crear el proyecto (puede tardar unos minutos)
7. Haz clic en **"Continuar"** o **"Continue"** cuando esté listo

---

## Paso 2: Configurar Firebase Authentication

### 2.1 Habilitar Authentication

1. En Firebase Console, ve a **"Authentication"** en el menú lateral
2. Haz clic en **"Comenzar"** o **"Get started"**
3. Ve a la pestaña **"Sign-in method"** o **"Métodos de inicio de sesión"**

### 2.2 Habilitar Email/Password

1. Haz clic en **"Correo electrónico/Contraseña"** o **"Email/Password"**
2. Activa el primer toggle (**"Correo electrónico/Contraseña"**)
3. Opcionalmente, puedes activar el segundo toggle (**"Correo electrónico con enlace"**) si quieres autenticación sin contraseña
4. Haz clic en **"Guardar"** o **"Save"**

### 2.3 Configurar Dominios Autorizados (Opcional - Solo para Web)

**⚠️ Nota Importante**: Los dominios autorizados son **SOLO necesarios si planeas usar la aplicación en web**. Para aplicaciones móviles (Android/iOS), **NO necesitas un dominio**.

1. En la misma sección, desplázate hacia abajo
2. En **"Dominios autorizados"**, verás que `localhost` ya está incluido por defecto
3. Si solo usas la app móvil, **no necesitas hacer nada aquí**
4. Si planeas usar la app en web más adelante, puedes agregar tu dominio cuando lo tengas

---

## Paso 3: Configurar Firestore Database

### 3.1 Crear Base de Datos Firestore

1. En Firebase Console, ve a **"Firestore Database"** en el menú lateral
2. Haz clic en **"Crear base de datos"** o **"Create database"**
3. Selecciona el modo de seguridad:
   - **Modo de prueba** (para desarrollo): Permite lectura/escritura durante 30 días
   - **Modo de producción** (recomendado): Requiere reglas de seguridad desde el inicio
4. Selecciona la ubicación de la base de datos:
   - Para República Dominicana, puedes elegir: **us-east1** (Carolina del Sur, USA) o **southamerica-east1** (São Paulo, Brasil)
   - La ubicación más cercana a RD es **us-east1**
5. Haz clic en **"Habilitar"** o **"Enable"**

### 3.2 Estructura de Datos

La aplicación creará automáticamente la siguiente estructura:

```
firestore/
└── users/
    └── {userId}/
        ├── id: string
        ├── email: string
        ├── displayName: string (opcional)
        ├── photoUrl: string (opcional)
        ├── phoneNumber: string (opcional)
        ├── location: string (opcional)
        ├── createdAt: timestamp
        └── lastLoginAt: timestamp (opcional)
```

---

## Paso 4: Instalar FlutterFire CLI

FlutterFire CLI es una herramienta que facilita la configuración de Firebase en proyectos Flutter.

### 4.1 Instalar FlutterFire CLI

Abre tu terminal y ejecuta:

```bash
dart pub global activate flutterfire_cli
```

### 4.2 Verificar Instalación

```bash
flutterfire --version
```

Deberías ver la versión instalada.

---

## Paso 5: Configurar Firebase en el Proyecto Flutter

### 5.1 Iniciar Sesión en Firebase

```bash
firebase login
```

Esto abrirá tu navegador para autenticarte con tu cuenta de Google.

### 5.2 Configurar Firebase en el Proyecto

1. Navega a la carpeta raíz de tu proyecto Flutter:
   ```bash
   cd "D:\El Ventorrillo"
   ```

2. Ejecuta el comando de configuración:
   ```bash
   flutterfire configure
   ```

3. El CLI te mostrará una lista de proyectos de Firebase. Selecciona el proyecto que creaste.

4. Selecciona las plataformas que quieres configurar:
   - ✅ **Android** (requerido para Android)
   - ✅ **iOS** (requerido para iOS)
   - ✅ **Web** (opcional, si planeas usar la app en web)
   - ✅ **macOS** (opcional)
   - ✅ **Windows** (opcional)
   - ✅ **Linux** (opcional)

5. El CLI generará automáticamente los archivos de configuración:
   - `firebase_options.dart` (en `lib/firebase_options.dart`)
   - `google-services.json` (para Android)
   - `GoogleService-Info.plist` (para iOS)

### 5.3 Sobre el Application ID de Android

El Application ID actual de tu proyecto es: `com.example.el_ventorrillo`

**⚠️ Nota sobre el Application ID:**
- El prefijo `com.example` es un placeholder de ejemplo
- **NO necesitas tener un dominio** para usar un Application ID válido
- Puedes usar cualquier identificador único, por ejemplo:
  - `com.ventorrillo.app`
  - `com.elventorrillo.app`
  - `com.ventorrillo.marketplace`
  - Cualquier otro identificador único que prefieras

**Para cambiar el Application ID (opcional):**
1. Edita `android/app/build.gradle.kts`
2. Cambia `applicationId = "com.example.el_ventorrillo"` por el que prefieras
3. Hazlo **ANTES** de ejecutar `flutterfire configure` para que Firebase use el nuevo ID

**Si ya ejecutaste `flutterfire configure`:**
- Puedes mantener `com.example.el_ventorrillo` para desarrollo
- Cambia el Application ID antes de publicar en producción

### 5.4 Verificar Archivos Generados

Después de la configuración, deberías ver:

```
lib/
└── firebase_options.dart  ← Nuevo archivo generado

android/
└── app/
    └── google-services.json  ← Nuevo archivo generado

ios/
└── Runner/
    └── GoogleService-Info.plist  ← Nuevo archivo generado
```

---

## Paso 6: Habilitar Firebase en el Código

### 6.1 Actualizar main.dart

Abre `lib/main.dart` y descomenta las líneas de Firebase:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';  // ← Descomentar
import 'package:el_ventorrillo/firebase_options.dart';  // ← Agregar esta línea
import 'package:el_ventorrillo/core/router/app_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // ← Agregar esta línea
  );
  
  runApp(
    const ProviderScope(
      child: ElVentorrilloApp(),
    ),
  );
}
```

### 6.2 Verificar Dependencias

Asegúrate de que `pubspec.yaml` tenga las siguientes dependencias (ya deberían estar):

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  cloud_functions: ^4.6.8
```

Si no están, ejecuta:

```bash
flutter pub get
```

---

## Paso 7: Configurar Índices de Firestore

Firestore requiere índices compuestos para queries que combinan `where` con `arrayContains` y `orderBy` en campos diferentes.

### 7.1 Índice para la Colección de Chats

La aplicación necesita un índice compuesto para la colección `chats` que permite buscar conversaciones por participante y ordenarlas por fecha del último mensaje.

**Crear el índice automáticamente:**
- Cuando ejecutes la app y veas el error en los logs, Firebase proporcionará un enlace directo para crear el índice
- Haz clic en el enlace y se creará automáticamente

**Crear el índice manualmente:**
1. Ve a Firebase Console → **Firestore Database** → **Indexes**
2. Haz clic en **"Create Index"** o **"Crear índice"**
3. Configura:
   - **Collection ID**: `chats`
   - **Fields to index**:
     - Campo: `participants` - Tipo: **Array**
     - Campo: `lastMessageTime` - Orden: **Descending**
   - **Query scope**: Collection
4. Haz clic en **"Create"** o **"Crear"**
5. Espera a que el índice se cree (puede tardar unos minutos)

---

## Paso 8: Configurar Reglas de Seguridad de Firestore

Las reglas de seguridad protegen tus datos. Aquí tienes reglas recomendadas para el sistema de usuarios.

### 8.1 Acceder a las Reglas

1. En Firebase Console, ve a **"Firestore Database"**
2. Haz clic en la pestaña **"Reglas"** o **"Rules"**

### 8.2 Reglas Recomendadas para Desarrollo

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Reglas para la colección de usuarios
    match /users/{userId} {
      // Cualquiera puede leer (para desarrollo)
      allow read: if true;
      
      // Solo el usuario autenticado puede escribir su propio documento
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Reglas para chats (si ya las tienes)
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
    
    // Reglas para mensajes (si ya las tienes)
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
    
    // Reglas para productos (si ya las tienes)
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 8.3 Reglas Recomendadas para Producción

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Reglas para la colección de usuarios
    match /users/{userId} {
      // Solo el usuario autenticado puede leer su propio documento
      allow read: if request.auth != null && request.auth.uid == userId;
      
      // Solo el usuario autenticado puede escribir su propio documento
      allow create: if request.auth != null 
                    && request.auth.uid == userId
                    && request.resource.data.id == userId
                    && request.resource.data.email == request.auth.token.email;
      allow update: if request.auth != null 
                    && request.auth.uid == userId
                    && request.resource.data.id == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Reglas para chats
    match /chats/{chatId} {
      allow read: if request.auth != null 
                  && request.auth.uid in resource.data.participants;
      allow create: if request.auth != null;
      allow update: if request.auth != null 
                    && request.auth.uid in resource.data.participants;
    }
    
    // Reglas para mensajes
    match /messages/{messageId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
                    && request.resource.data.senderId == request.auth.uid;
      allow update: if request.auth != null 
                    && resource.data.senderId == request.auth.uid;
    }
    
    // Reglas para productos
    match /products/{productId} {
      allow read: if true;
      allow create: if request.auth != null 
                    && request.resource.data.sellerId == request.auth.uid;
      allow update: if request.auth != null 
                    && resource.data.sellerId == request.auth.uid;
      allow delete: if request.auth != null 
                    && resource.data.sellerId == request.auth.uid;
    }
  }
}
```

### 8.4 Publicar las Reglas

1. Haz clic en **"Publicar"** o **"Publish"** después de escribir las reglas
2. Espera a que se publiquen (puede tardar unos segundos)

---

## Paso 9: Configurar Firebase Storage (Para Subir Imágenes)

Firebase Storage es necesario para que los usuarios puedan subir imágenes de productos.

### 9.1 Habilitar Firebase Storage

1. En Firebase Console, ve a **"Storage"** en el menú lateral
2. Si es la primera vez, haz clic en **"Comenzar"** o **"Get started"**
3. Lee y acepta los términos de servicio
4. Selecciona el modo de seguridad:
   - **Modo de prueba** (para desarrollo): Permite lectura/escritura durante 30 días
   - **Modo de producción** (recomendado): Requiere reglas de seguridad desde el inicio
5. Selecciona la ubicación del bucket (debe coincidir con la de Firestore):
   - Para República Dominicana: **us-east1** (Carolina del Sur, USA)
6. Haz clic en **"Listo"** o **"Done"**

### 9.2 Configurar Reglas de Seguridad de Storage

Las reglas de seguridad controlan quién puede subir y leer archivos.

1. En Firebase Console, ve a **"Storage"** → **"Rules"** o **"Reglas"**

2. **Reglas para Desarrollo** (permisivas, solo para pruebas):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Permitir lectura pública de imágenes de productos
    match /products/{allPaths=**} {
      allow read: if true;
      // Solo usuarios autenticados pueden subir
      allow write: if request.auth != null
                   && request.resource.size < 5 * 1024 * 1024  // Máximo 5MB
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Permitir lectura pública de imágenes de usuarios
    match /users/{allPaths=**} {
      allow read: if true;
      // Solo el usuario autenticado puede subir su propia imagen
      allow write: if request.auth != null
                   && request.resource.size < 5 * 1024 * 1024
                   && request.resource.contentType.matches('image/.*');
    }
  }
}
```

3. **Reglas para Producción** (más seguras):

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Imágenes de productos
    match /products/{userId}/{fileName} {
      // Cualquiera puede leer imágenes de productos
      allow read: if true;
      
      // Solo usuarios autenticados pueden subir
      // El userId en la ruta debe coincidir con el usuario autenticado
      allow write: if request.auth != null
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024  // Máximo 5MB
                   && request.resource.contentType.matches('image/.*');
    }
    
    // Imágenes de perfil de usuarios
    match /users/{userId}/{fileName} {
      // Cualquiera puede leer imágenes de perfil
      allow read: if true;
      
      // Solo el usuario puede subir su propia imagen de perfil
      allow write: if request.auth != null
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024
                   && request.resource.contentType.matches('image/.*');
    }
  }
}
```

**Nota importante:** Las reglas de producción son más estrictas y requieren que el `userId` en la ruta coincida con el usuario autenticado. Si tu código actual no sigue esta estructura, usa las reglas de desarrollo primero.

4. Haz clic en **"Publicar"** o **"Publish"** después de escribir las reglas

### 9.3 Verificar la Configuración

1. Asegúrate de que Storage esté habilitado en Firebase Console
2. Verifica que las reglas estén publicadas correctamente
3. Prueba subir una imagen desde la aplicación

---

## Paso 10: Probar la Configuración

### 9.1 Ejecutar la Aplicación

```bash
flutter run
```

### 10.2 Probar Registro de Usuario

1. Abre la aplicación
2. Ve a la pantalla de perfil
3. Haz clic en "Iniciar Sesión"
4. Haz clic en "Regístrate"
5. Completa el formulario:
   - Nombre: "Usuario de Prueba"
   - Email: "test@ejemplo.com"
   - Contraseña: "password123"
   - Confirmar contraseña: "password123"
6. Haz clic en "Crear Cuenta"

### 10.3 Verificar en Firebase Console

1. Ve a **Authentication** → **Users**
   - Deberías ver el usuario recién creado

2. Ve a **Firestore Database** → **Data**
   - Deberías ver la colección `users` con el documento del usuario

### 10.4 Probar Inicio de Sesión

### 10.5 Probar Subida de Imágenes

1. Ve a la pantalla de **"Publicar Producto"**
2. Haz clic en **"Agregar Imagen"**
3. Selecciona una imagen desde la galería o toma una foto
4. Espera a que se suba (verás un indicador de carga)
5. Verifica en Firebase Console → **Storage** que la imagen aparezca en la carpeta `products/`

1. Cierra sesión
2. Inicia sesión con las credenciales que acabas de crear
3. Verifica que puedas acceder a tu perfil

---

## Solución de Problemas

### Error: "FirebaseApp not initialized"

**Solución:**
- Asegúrate de que `Firebase.initializeApp()` esté en `main.dart` antes de `runApp()`
- Verifica que `firebase_options.dart` existe y está correctamente importado

### Error: "PlatformException(ERROR_INVALID_CREDENTIAL)"

**Solución:**
- Verifica que `google-services.json` (Android) o `GoogleService-Info.plist` (iOS) estén en las ubicaciones correctas
- Ejecuta `flutter clean` y luego `flutter pub get`
- Reconstruye la aplicación

### Error: "MissingPluginException"

**Solución:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "Permission denied" en Firestore

**Solución:**
- Verifica las reglas de seguridad de Firestore
- Asegúrate de que el usuario esté autenticado
- Revisa que las reglas permitan la operación que intentas realizar

### Error: "Email already in use"

**Solución:**
- Este es un error esperado si intentas registrar un email que ya existe
- Usa un email diferente o inicia sesión con el email existente

### La aplicación no se conecta a Firebase

**Solución:**
1. Verifica tu conexión a internet
2. Verifica que el proyecto de Firebase esté activo
3. Revisa los logs de la consola para más detalles:
   ```bash
   flutter run --verbose
   ```

### Problemas con FlutterFire CLI

**Solución:**
```bash
# Reinstalar FlutterFire CLI
dart pub global deactivate flutterfire_cli
dart pub global activate flutterfire_cli

# Reconfigurar
flutterfire configure
```

---

## Recursos Adicionales

- [Documentación oficial de Firebase para Flutter](https://firebase.flutter.dev/)
- [Documentación de Firebase Authentication](https://firebase.google.com/docs/auth)
- [Documentación de Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Reglas de Seguridad de Firestore](https://firebase.google.com/docs/firestore/security/get-started)

---

## Checklist Final

Antes de considerar la configuración completa, verifica:

- [ ] Proyecto creado en Firebase Console
- [ ] Authentication habilitado con Email/Password
- [ ] Firestore Database creado
- [ ] FlutterFire CLI instalado y configurado
- [ ] Archivos de configuración generados (`firebase_options.dart`, `google-services.json`, etc.)
- [ ] Firebase inicializado en `main.dart`
- [ ] Reglas de seguridad de Firestore configuradas
- [ ] Usuario de prueba creado exitosamente
- [ ] Inicio de sesión funcionando
- [ ] Datos del usuario guardándose en Firestore

---

## Notas Importantes

1. **NO necesitas dominio**: Para aplicaciones móviles (Android/iOS), Firebase funciona perfectamente sin necesidad de un dominio web. Solo lo necesitarías si planeas usar la app en navegadores web.

2. **Application ID**: El Application ID actual (`com.example.el_ventorrillo`) es válido para desarrollo. No necesitas cambiar el prefijo `com.example` a menos que vayas a publicar en producción. Si decides cambiarlo, puedes usar cualquier identificador único sin necesidad de tener un dominio (ej: `com.ventorrillo.app`).

3. **Modo de Prueba de Firestore**: Si usas el modo de prueba, las reglas permiten lectura/escritura durante 30 días. Después de ese tiempo, necesitarás configurar reglas de seguridad.

4. **Costos**: Firebase tiene un plan gratuito generoso, pero revisa los límites en [Firebase Pricing](https://firebase.google.com/pricing)

5. **Seguridad**: Nunca expongas tus claves de API o credenciales en el código. Los archivos de configuración generados por FlutterFire CLI son seguros de incluir en el repositorio.

6. **Backup**: Considera hacer backups regulares de tus datos de Firestore, especialmente antes de cambios importantes.

---

¡Felicitaciones! Tu aplicación El Ventorrillo ahora está configurada con Firebase. 🎉

