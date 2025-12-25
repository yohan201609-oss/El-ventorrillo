# Guía Rápida de Firebase - El Ventorrillo

Esta es una versión resumida de la guía completa. Para detalles, consulta `FIREBASE_SETUP.md`.

## ⚠️ Importante: NO Necesitas Dominio

**No necesitas un dominio** para usar Firebase con aplicaciones móviles. Solo lo necesitarías si planeas usar la app en web. Para Android/iOS, Firebase funciona perfectamente sin dominio.

## Pasos Rápidos

### 1. Crear Proyecto en Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto llamado "El Ventorrillo"
3. Espera a que se complete la creación

### 2. Configurar Authentication
1. Ve a **Authentication** → **Get started**
2. Ve a **Sign-in method**
3. Habilita **Email/Password**
4. Guarda

### 3. Configurar Firestore
1. Ve a **Firestore Database** → **Create database**
2. Selecciona **Start in test mode** (para desarrollo)
3. Elige ubicación: **us-east1** (más cercana a RD)
4. Habilita

### 4. Instalar y Configurar FlutterFire CLI

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Iniciar sesión en Firebase
firebase login

# Configurar el proyecto
cd "D:\El Ventorrillo"
flutterfire configure
```

Selecciona:
- Tu proyecto de Firebase
- Plataformas: Android, iOS (y otras si las necesitas)

### 5. Habilitar Firebase en el Código

Edita `lib/main.dart` y descomenta:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:el_ventorrillo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(...);
}
```

### 6. Configurar Reglas de Firestore

En Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true;
      allow create: if request.auth != null && request.auth.uid == userId;
      allow update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

Haz clic en **Publish**.

### 7. Probar

```bash
flutter run
```

1. Ve a Perfil → Iniciar Sesión → Regístrate
2. Crea una cuenta de prueba
3. Verifica en Firebase Console que el usuario aparezca en Authentication y Firestore

## Comandos Útiles

```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar con logs detallados
flutter run --verbose
```

## Problemas Comunes

- **"FirebaseApp not initialized"**: Asegúrate de descomentar `Firebase.initializeApp()` en `main.dart`
- **"MissingPluginException"**: Ejecuta `flutter clean` y `flutter pub get`
- **"Permission denied"**: Verifica las reglas de Firestore

Para más detalles, consulta `FIREBASE_SETUP.md`.

