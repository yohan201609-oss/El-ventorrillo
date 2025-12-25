import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:el_ventorrillo/data/repositories/auth_repository.dart';
import 'package:el_ventorrillo/data/repositories/firestore_auth_repository.dart';
import 'package:el_ventorrillo/domain/models/user.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return FirestoreAuthRepository();
}

@riverpod
Stream<AppUser?> currentUser(CurrentUserRef ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
}

@riverpod
class SignIn extends _$SignIn {
  @override
  FutureOr<AppUser?> build() => null;

  Future<AppUser?> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);

    try {
      final user = await repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = AsyncValue.data(user);
      return user;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

@riverpod
class SignUp extends _$SignUp {
  @override
  FutureOr<AppUser?> build() => null;

  Future<AppUser?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);

    try {
      final user = await repository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      state = AsyncValue.data(user);
      return user;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

@riverpod
class SignOut extends _$SignOut {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

@riverpod
class UpdateProfile extends _$UpdateProfile {
  @override
  FutureOr<void> build() {}

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? location,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.updateUserProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        location: location,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

@riverpod
class ResetPassword extends _$ResetPassword {
  @override
  FutureOr<void> build() {}

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.resetPassword(email);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

@riverpod
class SignInWithGoogle extends _$SignInWithGoogle {
  @override
  FutureOr<AppUser?> build() => null;

  Future<AppUser?> signInWithGoogle() async {
    state = const AsyncValue.loading();

    final repository = ref.read(authRepositoryProvider);

    try {
      final user = await repository.signInWithGoogle();

      // Si el usuario es null (cancelado), establecer estado como data(null) para salir del loading
      state = AsyncValue.data(user);
      return user;
    } catch (e, stack) {
      // Asegurar que el estado se establece como error para salir del loading
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

