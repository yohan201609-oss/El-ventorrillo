import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push('/settings');
            },
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (user) {
          if (user == null) {
            return _buildNotLoggedIn(context);
          }
          return _buildLoggedIn(context, ref, user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildNotLoggedIn(context),
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final verticalPadding = Responsive.getVerticalPadding(context);
        final maxWidth = Responsive.getMaxContentWidth(context);

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.all(verticalPadding * 1.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.redLight,
                    child: Icon(
                      Icons.person,
                      size: 48,
                      color: AppTheme.redDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Usuario',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inicia sesión para acceder a tu perfil',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: const Text('Crear Cuenta'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoggedIn(
    BuildContext context,
    WidgetRef ref,
    user,
  ) {
    final verticalPadding = Responsive.getVerticalPadding(context);
    final maxWidth = Responsive.getMaxContentWidth(context);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          children: [
            // Sección de Perfil
            Padding(
              padding: EdgeInsets.all(verticalPadding * 1.5),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.redLight,
                    backgroundImage: user.photoUrl != null
                        ? CachedNetworkImageProvider(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Icon(
                            Icons.person,
                            size: 48,
                            color: AppTheme.redDark,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? 'Usuario',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (user.location != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user.location!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () async {
                      final signOut = ref.read(signOutProvider.notifier);
                      await signOut.signOut();
                      if (context.mounted) {
                        context.go('/home');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.red,
                      side: const BorderSide(color: AppTheme.red),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Opciones rápidas
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined, color: AppTheme.red),
              title: const Text('Mis Productos'),
              subtitle: const Text('Productos que he publicado'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente: Mis productos')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: AppTheme.red),
              title: const Text('Mensajes'),
              subtitle: const Text('Conversaciones activas'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Usar go en lugar de push para evitar problemas de claves duplicadas
                context.go('/chat');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: AppTheme.red),
              title: const Text('Configuración'),
              subtitle: const Text('Ajustes de la aplicación'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
