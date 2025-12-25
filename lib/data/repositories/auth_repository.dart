import 'package:el_ventorrillo/domain/models/user.dart';

abstract class AuthRepository {
  // Autenticación
  Future<AppUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AppUser?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AppUser?> signInWithGoogle();

  Future<void> signOut();

  // Usuario actual
  Stream<AppUser?> getCurrentUser();
  AppUser? getCurrentUserSync();

  // Actualizar perfil
  Future<void> updateUserProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? location,
  });

  // Cambiar contraseña
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // Recuperar contraseña
  Future<void> resetPassword(String email);
}

