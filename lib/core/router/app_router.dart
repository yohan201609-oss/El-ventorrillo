import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:el_ventorrillo/presentation/screens/home/home_screen.dart';
import 'package:el_ventorrillo/presentation/screens/main_shell/main_shell_screen.dart';
import 'package:el_ventorrillo/presentation/screens/search/search_screen.dart';
import 'package:el_ventorrillo/presentation/screens/profile/profile_screen.dart';
import 'package:el_ventorrillo/presentation/screens/settings/settings_screen.dart';
import 'package:el_ventorrillo/presentation/screens/publish/publish_product_screen.dart';
import 'package:el_ventorrillo/presentation/screens/product_detail/product_detail_screen.dart';
import 'package:el_ventorrillo/presentation/screens/chat/chat_screen.dart';
import 'package:el_ventorrillo/presentation/screens/chat/chat_list_screen.dart';
import 'package:el_ventorrillo/presentation/screens/auth/login_screen.dart';
import 'package:el_ventorrillo/presentation/screens/auth/register_screen.dart';
import 'package:el_ventorrillo/presentation/screens/legal/terms_and_conditions_screen.dart';
import 'package:el_ventorrillo/presentation/screens/legal/privacy_policy_screen.dart';

class AppRouter {
  // Verificar si Firebase está inicializado
  static bool get _isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Obtener el usuario actual de forma segura
  static User? _getCurrentUser() {
    if (!_isFirebaseInitialized) {
      return null;
    }
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      return null;
    }
  }

  // ValueNotifier para escuchar cambios en el estado de autenticación
  static final ValueNotifier<User?> authStateNotifier = ValueNotifier<User?>(
    _getCurrentUser(),
  );

  static void initAuthListener() {
    if (!_isFirebaseInitialized) {
      return;
    }
    try {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        // Actualizar el notifier solo si el valor realmente cambió
        if (authStateNotifier.value?.uid != user?.uid) {
          authStateNotifier.value = user;
        }
      });
    } catch (e) {
      // Firebase no está inicializado, ignorar
    }
  }

  // Verificar si el usuario está autenticado
  static bool get isAuthenticated {
    return _getCurrentUser() != null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    // Deshabilitar redirect global temporalmente para evitar problemas de claves duplicadas
    // redirect: (context, state) {
    //   final isAuth = isAuthenticated;
    //   final location = state.matchedLocation;
    //   final isLoginPage = location == '/login' || location == '/register';
    //   final isAuthPage = location == '/home' ||
    //                      location == '/' ||
    //                      location == '/search' ||
    //                      location == '/profile' ||
    //                      location.startsWith('/chat') ||
    //                      location == '/publish';

    //   // Si no está autenticado y está intentando acceder a una página protegida
    //   if (!isAuth && isAuthPage) {
    //     return '/login';
    //   }

    //   // Si está autenticado y está en la página de login/register
    //   if (isAuth && isLoginPage) {
    //     return '/home';
    //   }

    //   return null; // No redirigir
    // },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) {
              // Redirigir manualmente basado en el estado de autenticación
              if (isAuthenticated) {
                return const HomeScreen();
              }
              return const LoginScreen();
            },
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/chat',
            name: 'chat',
            pageBuilder: (context, state) {
              // Si hay query parameters, mostrar conversación individual
              final recipientId = state.uri.queryParameters['recipientId'];
              final recipientName = state.uri.queryParameters['recipientName'];
              final productTitle = state.uri.queryParameters['productTitle'];
              
              Widget screen;
              if (recipientId != null || recipientName != null) {
                final chatId = state.uri.queryParameters['chatId'];
                screen = ChatScreen(
                  chatId: chatId,
                  recipientId: recipientId,
                  recipientName: recipientName,
                  productTitle: productTitle,
                );
              } else {
                // Si no hay parámetros, mostrar lista de chats
                screen = const ChatListScreen();
              }
              
              return NoTransitionPage<void>(
                key: state.pageKey,
                child: screen,
              );
            },
            routes: [
              GoRoute(
                path: ':id',
                name: 'chat-conversation',
                pageBuilder: (context, state) {
                  final chatId = state.pathParameters['id']!;
                  final recipientId = state.uri.queryParameters['recipientId'];
                  final recipientName = state.uri.queryParameters['recipientName'];
                  final productTitle = state.uri.queryParameters['productTitle'];
                  return NoTransitionPage<void>(
                    key: state.pageKey,
                    child: ChatScreen(
                      chatId: chatId,
                      recipientId: recipientId,
                      recipientName: recipientName,
                      productTitle: productTitle,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/publish',
        name: 'publish',
        builder: (context, state) => const PublishProductScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/terms-and-conditions',
        name: 'terms-and-conditions',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const TermsAndConditionsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/privacy-policy',
        name: 'privacy-policy',
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const PrivacyPolicyScreen(),
          );
        },
      ),
    ],
  );
}

