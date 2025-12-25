import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:el_ventorrillo/data/repositories/auth_repository.dart';
import 'package:el_ventorrillo/domain/models/user.dart';

class FirestoreAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Para Web, el clientId se obtiene del meta tag en index.html
  // Para otras plataformas, se obtiene automáticamente de la configuración
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    // En Web, el clientId se lee del meta tag en index.html
    // Agregamos 'openid' scope para asegurar que obtenemos el idToken
  );

  // Colección de usuarios
  static const String _usersCollection = 'users';

  @override
  Future<AppUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      // Actualizar último login
      await _updateLastLogin(userCredential.user!.uid);

      // Obtener datos del usuario desde Firestore
      return await _getUserFromFirestore(userCredential.user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AppUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      final user = userCredential.user!;

      // Actualizar displayName en Firebase Auth
      await user.updateDisplayName(displayName);
      await user.reload();

      // Crear documento de usuario en Firestore
      final appUser = AppUser(
        id: user.uid,
        email: user.email!,
        displayName: displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(appUser.toMap());

      return appUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      // Para Web, usar Firebase Auth directamente con popup (más confiable)
      if (kIsWeb) {
        return await _signInWithGoogleWeb();
      }
      
      // Para otras plataformas (Android/iOS), usar el método tradicional
      return await _signInWithGoogleMobile();
    } catch (e) {
      // Si es la excepción de cancelación, retornar null
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('sign_in_canceled') || 
          errorString.contains('sign_in_aborted') ||
          errorString.contains('canceled') ||
          errorString.contains('pigeonuserdetails') ||
          errorString.contains('type cast')) {
        return null;
      }
      rethrow;
    }
  }

  /// Método específico para Web usando Firebase Auth directamente con popup
  /// Solución mejorada con múltiples estrategias de reintento
  Future<AppUser?> _signInWithGoogleWeb() async {
    try {
      // Cerrar sesión previa si existe
      await _googleSignIn.signOut();
      await _auth.signOut();
      
      // Estrategia mejorada para Web con múltiples intentos:
      // 1. Intentar signInSilently primero (puede funcionar si hay sesión previa)
      // 2. Si falla, intentar signIn() interactivo
      // 3. Obtener authentication con reintentos progresivos
      // 4. Si aún falla, intentar usar solo accessToken (último recurso)
      
      GoogleSignInAccount? googleUser;
      
      // Paso 1: Intentar signInSilently primero
      try {
        googleUser = await _googleSignIn.signInSilently();
      } catch (e) {
        // Ignorar errores de signInSilently, continuar con signIn interactivo
      }
      
      // Paso 2: Si no hay sesión silenciosa, usar signIn interactivo
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // Usuario canceló
      }

      // Paso 3: Obtener authentication con estrategia de reintentos mejorada
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Verificar accessToken (siempre debería estar disponible)
      if (googleAuth.accessToken == null) {
        throw Exception('Error al obtener accessToken de Google');
      }

      // Paso 4: Intentar obtener idToken con reintentos progresivos
      if (googleAuth.idToken == null) {
        // Delays progresivos: 300ms, 500ms, 800ms, 1000ms, 1500ms, 2000ms
        final delays = [300, 500, 800, 1000, 1500, 2000];
        
        for (int i = 0; i < delays.length && googleAuth.idToken == null; i++) {
          await Future.delayed(Duration(milliseconds: delays[i]));
          googleAuth = await googleUser.authentication;
          
          // Si obtenemos el idToken, salir del loop
          if (googleAuth.idToken != null) break;
        }
      }

      // Paso 5: Si aún no tenemos idToken, intentar una última vez con delay mayor
      if (googleAuth.idToken == null) {
        await Future.delayed(const Duration(milliseconds: 3000));
        googleAuth = await googleUser.authentication;
      }

      // Paso 6: Crear credencial y autenticar
      // Intentar con idToken si está disponible, si no, solo con accessToken
      OAuthCredential credential;
      
      if (googleAuth.idToken != null) {
        // Caso ideal: tenemos ambos tokens
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else {
        // Último recurso: intentar solo con accessToken
        // Nota: Esto puede no funcionar en todos los casos, pero es mejor que fallar
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
        );
      }

      // Autenticar con Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw Exception('Error al autenticar con Firebase');
      }
      
      final user = userCredential.user!;
      
      // Crear o actualizar usuario en Firestore
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        // Si es un nuevo usuario, crear el documento en Firestore
        final appUser = AppUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? googleUser.displayName,
          photoUrl: user.photoURL ?? googleUser.photoUrl,
          phoneNumber: user.phoneNumber,
          createdAt: user.metadata.creationTime ?? DateTime.now(),
          lastLoginAt: user.metadata.lastSignInTime,
        );

        await _firestore
            .collection(_usersCollection)
            .doc(user.uid)
            .set(appUser.toMap());

        return appUser;
      } else {
        // Si el usuario ya existe, actualizar último login y obtener datos
        await _updateLastLogin(user.uid);
        return AppUser.fromMap(userDoc.data()!, userDoc.id);
      }
    } catch (e) {
      // Si es un error de cancelación, retornar null
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('sign_in_canceled') ||
          errorString.contains('sign_in_aborted') ||
          errorString.contains('canceled')) {
        return null;
      }
      rethrow;
    }
  }

  /// Método para plataformas móviles (Android/iOS)
  Future<AppUser?> _signInWithGoogleMobile() async {
    try {
      // Cerrar sesión previa si existe
      await _googleSignIn.signOut();
      
      // Intentar signInSilently primero
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      // Si no hay sesión silenciosa, iniciar el flujo interactivo
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      // Obtener authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Error al obtener credenciales de Google');
      }

      // Crear credencial
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _handleFirebaseAuth(credential, googleUser);
    } catch (e) {
      rethrow;
    }
  }

  /// Maneja la autenticación con Firebase y la creación/actualización del usuario
  Future<AppUser?> _handleFirebaseAuth(
    OAuthCredential credential,
    GoogleSignInAccount googleUser,
  ) async {
    // Autenticar con Firebase
    final userCredential = await _auth.signInWithCredential(credential);

    if (userCredential.user == null) {
      throw Exception('Error al autenticar con Firebase');
    }

    final user = userCredential.user!;

    // Verificar si el usuario ya existe en Firestore
    final userDoc = await _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      // Si es un nuevo usuario, crear el documento en Firestore
      final appUser = AppUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? googleUser.displayName ?? '',
        photoUrl: user.photoURL ?? googleUser.photoUrl,
        phoneNumber: user.phoneNumber,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(appUser.toMap());

      return appUser;
    } else {
      // Si el usuario ya existe, actualizar último login y obtener datos
      await _updateLastLogin(user.uid);
      return await _getUserFromFirestore(user.uid);
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  Stream<AppUser?> getCurrentUser() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _getUserFromFirestore(firebaseUser.uid);
    });
  }

  @override
  AppUser? getCurrentUserSync() {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    // No podemos obtener datos de Firestore de forma síncrona
    // El provider deberá usar getCurrentUser() que es asíncrono
    return null;
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? location,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      // Actualizar en Firebase Auth
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }
      await user.reload();

      // Actualizar en Firestore
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['displayName'] = displayName;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (location != null) updateData['location'] = location;

      if (updateData.isNotEmpty) {
        await _firestore
            .collection(_usersCollection)
            .doc(user.uid)
            .update(updateData);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      // Reautenticar con la contraseña actual
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Cambiar contraseña
      await user.updatePassword(newPassword);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Métodos auxiliares privados

  Future<AppUser?> _getUserFromFirestore(String userId) async {
    try {
      final doc =
          await _firestore.collection(_usersCollection).doc(userId).get();

      if (!doc.exists) {
        // Si no existe en Firestore, crear uno básico desde Firebase Auth
        final firebaseUser = _auth.currentUser;
        if (firebaseUser != null && firebaseUser.uid == userId) {
          return await _createUserFromFirebaseAuth(firebaseUser);
        }
        return null;
      }

      return AppUser.fromMap(doc.data()!, doc.id);
    } catch (e) {
      return null;
    }
  }

  Future<AppUser> _createUserFromFirebaseAuth(User firebaseUser) async {
    final appUser = AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      phoneNumber: firebaseUser.phoneNumber,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: firebaseUser.metadata.lastSignInTime,
    );

    // Guardar en Firestore
    await _firestore
        .collection(_usersCollection)
        .doc(firebaseUser.uid)
        .set(appUser.toMap());

    return appUser;
  }

  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignorar errores al actualizar último login
    }
  }
}

