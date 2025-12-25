import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:el_ventorrillo/firebase_options.dart';
import 'package:el_ventorrillo/core/router/app_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicializar el listener de autenticación para el router
  AppRouter.initAuthListener();
  
  runApp(
    const ProviderScope(
      child: ElVentorrilloApp(),
    ),
  );
}

class ElVentorrilloApp extends ConsumerWidget {
  const ElVentorrilloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    
    // Usar una key única para evitar problemas de GlobalKey duplicado
    return MaterialApp.router(
      key: const ValueKey('main_app'),
      title: 'El Ventorrillo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: themeModeAsync.when(
        data: (mode) => mode,
        loading: () => ThemeMode.light,
        error: (_, __) => ThemeMode.light,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
