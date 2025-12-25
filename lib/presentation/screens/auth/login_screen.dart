import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/presentation/providers/auth_provider.dart';

/// Pantalla de inicio de sesión mejorada con diseño moderno
/// Incluye: gradientes, animaciones, validación visual, y mejor UX
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _obscurePassword = true;
  bool _emailHasFocus = false;
  bool _passwordHasFocus = false;
  bool _emailIsValid = false;
  bool _passwordIsValid = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Configurar animaciones de entrada
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();

    // Listeners para estados de focus y validación
    _emailFocusNode.addListener(() {
      setState(() {
        _emailHasFocus = _emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _passwordHasFocus = _passwordFocusNode.hasFocus;
      });
    });

    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    final isValid = email.isNotEmpty &&
        email.contains('@') &&
        email.contains('.') &&
        email.length > 5;
    
    if (_emailIsValid != isValid) {
      setState(() {
        _emailIsValid = isValid;
      });
    }
  }

  void _validatePassword() {
    final isValid = _passwordController.text.length >= 6;
    
    if (_passwordIsValid != isValid) {
      setState(() {
        _passwordIsValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Vibrar ligeramente al presionar
    HapticFeedback.lightImpact();
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final signIn = ref.read(signInProvider.notifier);
    final user = await signIn.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (user != null) {
        // Login exitoso, navegar a home usando pushReplacement
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          context.pushReplacement('/home');
        }
      } else {
        // Mostrar error
        final error = ref.read(signInProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getErrorMessage(error),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    HapticFeedback.lightImpact();
    
    try {
      final signInWithGoogle = ref.read(signInWithGoogleProvider.notifier);
      final user = await signInWithGoogle.signInWithGoogle();

      if (!mounted) return;

      if (user != null) {
        // Login exitoso, navegar a home usando pushReplacement
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          context.pushReplacement('/home');
        }
      } else {
        // Verificar si fue cancelado por el usuario o hubo un error
        final state = ref.read(signInWithGoogleProvider);
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getGoogleErrorMessage(state.error),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error inesperado: ${e.toString()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  String _getGoogleErrorMessage(Object? error) {
    if (error == null) return 'Error al iniciar sesión con Google';
    
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Error de conexión. Verifica tu internet';
    } else if (errorString.contains('sign_in_canceled') || 
               errorString.contains('canceled')) {
      return 'Inicio de sesión cancelado';
    } else if (errorString.contains('platform_exception')) {
      return 'Error de plataforma. Verifica la configuración de Google Sign-In';
    } else if (errorString.contains('sign_in_failed')) {
      return 'Error al autenticar. Verifica que Google Sign-In esté habilitado en Firebase';
    }
    return 'Error al iniciar sesión con Google: ${error.toString()}';
  }

  bool _canPop(BuildContext context) {
    return context.canPop();
  }

  String _getErrorMessage(Object? error) {
    if (error == null) return 'Error al iniciar sesión';
    
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('user-not-found') ||
        errorString.contains('wrong-password')) {
      return 'Correo o contraseña incorrectos';
    } else if (errorString.contains('invalid-email')) {
      return 'Correo electrónico inválido';
    } else if (errorString.contains('user-disabled')) {
      return 'Esta cuenta ha sido deshabilitada';
    } else if (errorString.contains('too-many-requests')) {
      return 'Demasiados intentos. Intenta más tarde';
    } else if (errorString.contains('network')) {
      return 'Error de conexión. Verifica tu internet';
    }
    return 'Error al iniciar sesión: ${error.toString()}';
  }

  Future<void> _handleResetPassword() async {
    HapticFeedback.lightImpact();
    
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ingresa tu correo electrónico primero',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    final resetPassword = ref.read(resetPasswordProvider.notifier);
    await resetPassword.resetPassword(_emailController.text.trim());

    if (mounted) {
      final error = ref.read(resetPasswordProvider).error;
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Se ha enviado un correo para restablecer tu contraseña',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error: ${error.toString()}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    HapticFeedback.lightImpact();
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(signInProvider);
    final signInWithGoogleState = ref.watch(signInWithGoogleProvider);
    final isLoading = signInState.isLoading || signInWithGoogleState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // AppBar con gradiente sutil
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        leading: _canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
              )
            : null,
        automaticallyImplyLeading: false,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppTheme.gray800,
                      AppTheme.gray900,
                    ]
                  : [
                      Colors.white,
                      AppTheme.gray50,
                    ],
            ),
          ),
        ),
      ),
      body: Container(
        // Fondo con gradiente suave
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppTheme.gray900,
                    AppTheme.gray800,
                  ]
                : [
                    AppTheme.gray50,
                    Colors.white,
                  ],
            stops: const [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.getHorizontalPadding(context),
                vertical: Responsive.getVerticalPadding(context) * 1.5,
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo con animación y sombra
                          _buildAnimatedLogo(),
                          const SizedBox(height: 2.5 * 16), // 40px
                          
                          // Mensaje de bienvenida
                          _buildWelcomeMessage(),
                          const SizedBox(height: 2.5 * 16), // 40px
                          
                          // Campo de correo electrónico mejorado
                          _buildEmailField(),
                          const SizedBox(height: 1.5 * 16), // 24px
                          
                          // Campo de contraseña mejorado
                          _buildPasswordField(),
                          const SizedBox(height: 0.5 * 16), // 8px
                          
                          // Link de olvidé contraseña
                          _buildForgotPasswordLink(),
                          const SizedBox(height: 2 * 16), // 32px
                          
                          // Botón principal de login con gradiente
                          _buildLoginButton(isLoading, signInState.isLoading),
                          const SizedBox(height: 1.5 * 16), // 24px
                          
                          // Separador
                          _buildSeparator(),
                          const SizedBox(height: 1.5 * 16), // 24px
                          
                          // Botón de Google mejorado
                          _buildGoogleButton(isLoading, signInWithGoogleState.isLoading),
                          const SizedBox(height: 1.5 * 16), // 24px
                          
                          // Link de registro
                          _buildRegisterLink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Logo con animación y sombra moderna
  Widget _buildAnimatedLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.blueDark,
                  AppTheme.blue,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.blue.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.blueDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/icons/logo_ventorrillo.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Mensaje de bienvenida con tipografía mejorada
  Widget _buildWelcomeMessage() {
    return Column(
      children: [
        Text(
          'Bienvenido de vuelta',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Inicia sesión para continuar',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 15,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Campo de correo electrónico con validación visual y animaciones
  Widget _buildEmailField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _emailHasFocus
            ? [
                BoxShadow(
                  color: (_emailIsValid ? Colors.green : AppTheme.red)
                      .withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _emailController,
        builder: (context, value, child) {
          final hasText = value.text.isNotEmpty;
          return TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'ejemplo@correo.com',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: _emailHasFocus
                    ? (_emailIsValid ? Colors.green : AppTheme.red)
                    : AppTheme.textSecondary,
              ),
              suffixIcon: hasText && _emailHasFocus
                  ? Icon(
                      _emailIsValid ? Icons.check_circle : Icons.error_outline,
                      color: _emailIsValid ? Colors.green : AppTheme.red,
                      size: 20,
                    )
                  : null,
          filled: true,
          fillColor: isDark ? AppTheme.gray800 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _emailHasFocus
                  ? (_emailIsValid ? Colors.green : AppTheme.red)
                  : AppTheme.gray300,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.gray300,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _emailIsValid ? Colors.green : AppTheme.red,
              width: 2.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.red,
              width: 2.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          labelStyle: TextStyle(
            color: _emailHasFocus
                ? (_emailIsValid ? Colors.green : AppTheme.red)
                : AppTheme.textSecondary,
            fontSize: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Ingresa tu correo electrónico';
          }
          if (!value.contains('@') || !value.contains('.')) {
            return 'Ingresa un correo electrónico válido';
          }
          return null;
        },
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
      );
        },
      ),
    );
  }

  /// Campo de contraseña con toggle animado y validación visual
  Widget _buildPasswordField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _passwordHasFocus
            ? [
                BoxShadow(
                  color: (_passwordIsValid ? Colors.green : AppTheme.red)
                      .withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _passwordController,
        builder: (context, value, child) {
          final hasText = value.text.isNotEmpty;
          return TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Mínimo 6 caracteres',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: _passwordHasFocus
                    ? (_passwordIsValid ? Colors.green : AppTheme.red)
                    : AppTheme.textSecondary,
              ),
              suffixIcon: hasText
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        key: ValueKey(_obscurePassword),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: _passwordHasFocus
                              ? (_passwordIsValid ? Colors.green : AppTheme.red)
                              : AppTheme.textSecondary,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    )
                  : null,
          filled: true,
          fillColor: isDark ? AppTheme.gray800 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _passwordHasFocus
                  ? (_passwordIsValid ? Colors.green : AppTheme.red)
                  : AppTheme.gray300,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.gray300,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _passwordIsValid ? Colors.green : AppTheme.red,
              width: 2.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.red,
              width: 2.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          labelStyle: TextStyle(
            color: _passwordHasFocus
                ? (_passwordIsValid ? Colors.green : AppTheme.red)
                : AppTheme.textSecondary,
            fontSize: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa tu contraseña';
          }
          if (value.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        },
        onFieldSubmitted: (_) => _handleLogin(),
      );
        },
      ),
    );
  }

  /// Link de olvidé contraseña con estilo mejorado
  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleResetPassword,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: TextStyle(
            color: AppTheme.red,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Botón principal de login con gradiente y animaciones
  Widget _buildLoginButton(bool isLoading, bool isSignInLoading) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.red,
            AppTheme.redDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.red.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : _handleLogin,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            child: isSignInLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  /// Separador con estilo moderno
  Widget _buildSeparator() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.gray300,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'O',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.gray300,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Botón de Google con diseño oficial mejorado
  Widget _buildGoogleButton(bool isLoading, bool isGoogleLoading) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.gray800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gray300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : _handleGoogleSignIn,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isGoogleLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4285F4),
                          Color(0xFF34A853),
                          Color(0xFFFBBC05),
                          Color(0xFFEA4335),
                        ],
                        stops: [0.0, 0.33, 0.66, 1.0],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Text(
                  'Continuar con Google',
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Link de registro con estilo mejorado
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            context.pushReplacement('/register');
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          child: Text(
            'Regístrate',
            style: TextStyle(
              color: AppTheme.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
