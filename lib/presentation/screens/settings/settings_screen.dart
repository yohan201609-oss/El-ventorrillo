import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/presentation/providers/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _locationEnabled = false;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = Responsive.getHorizontalPadding(context);
          final verticalPadding = Responsive.getVerticalPadding(context);
          final maxWidth = Responsive.getMaxContentWidth(context);
          
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ListView(
                children: [
                  // Sección: Cuenta
                  _buildSectionHeader('Cuenta'),
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Editar Perfil',
            subtitle: 'Información personal y foto',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Editar perfil')),
              );
            },
          ),
          _buildListTile(
            icon: Icons.location_on_outlined,
            title: 'Ubicación',
            subtitle: 'Gestionar ubicación para búsquedas',
            trailing: Switch(
              value: _locationEnabled,
              onChanged: (value) {
                setState(() {
                  _locationEnabled = value;
                });
              },
              activeColor: AppTheme.amber,
            ),
          ),
          _buildListTile(
            icon: Icons.payment_outlined,
            title: 'Métodos de Pago',
            subtitle: 'Tarjetas y formas de pago',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Métodos de pago')),
              );
            },
          ),

          const SizedBox(height: 8),

          // Sección: Notificaciones
          _buildSectionHeader('Notificaciones'),
          _buildListTile(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
            subtitle: 'Activar o desactivar notificaciones',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                  if (!value) {
                    _emailNotifications = false;
                    _pushNotifications = false;
                  }
                });
              },
              activeColor: AppTheme.amber,
            ),
          ),
          if (_notificationsEnabled) ...[
            _buildListTile(
              icon: Icons.email_outlined,
              title: 'Notificaciones por Email',
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
                activeColor: AppTheme.amber,
              ),
            ),
            _buildListTile(
              icon: Icons.phone_android_outlined,
              title: 'Notificaciones Push',
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
                activeColor: AppTheme.amber,
              ),
            ),
          ],

          const SizedBox(height: 8),

          // Sección: Privacidad y Seguridad
          _buildSectionHeader('Privacidad y Seguridad'),
          _buildListTile(
            icon: Icons.lock_outline,
            title: 'Privacidad',
            subtitle: 'Control de datos y privacidad',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Configuración de privacidad')),
              );
            },
          ),
          _buildListTile(
            icon: Icons.security_outlined,
            title: 'Seguridad',
            subtitle: 'Contraseña y autenticación',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Configuración de seguridad')),
              );
            },
          ),

          const SizedBox(height: 8),

          // Sección: Preferencias
          _buildSectionHeader('Preferencias'),
          _buildListTile(
            icon: Icons.language_outlined,
            title: 'Idioma',
            subtitle: _selectedLanguage,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          _buildListTile(
            icon: Icons.dark_mode_outlined,
            title: 'Modo Oscuro',
            subtitle: 'Activar tema oscuro',
            trailing: Switch(
              value: ref.watch(themeModeNotifierProvider).when(
                    data: (mode) => mode == ThemeMode.dark,
                    loading: () => false,
                    error: (_, __) => false,
                  ),
              onChanged: (value) async {
                final themeNotifier = ref.read(themeModeNotifierProvider.notifier);
                await themeNotifier.setThemeMode(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              activeColor: AppTheme.amber,
            ),
          ),

          const SizedBox(height: 8),

          // Sección: Ayuda y Soporte
          _buildSectionHeader('Ayuda y Soporte'),
          _buildListTile(
            icon: Icons.help_outline,
            title: 'Centro de Ayuda',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Centro de ayuda')),
              );
            },
          ),
          _buildListTile(
            icon: Icons.contact_support_outlined,
            title: 'Contactar Soporte',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Contactar soporte')),
              );
            },
          ),
          _buildListTile(
            icon: Icons.description_outlined,
            title: 'Términos y Condiciones',
            onTap: () {
              context.push('/terms-and-conditions');
            },
          ),
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Política de Privacidad',
            onTap: () {
              context.push('/privacy-policy');
            },
          ),

          const SizedBox(height: 8),

          // Sección: Acerca de
          _buildSectionHeader('Acerca de'),
          _buildListTile(
            icon: Icons.info_outline,
            title: 'Versión',
            subtitle: '1.0.0',
          ),
          _buildListTile(
            icon: Icons.star_outline,
            title: 'Calificar App',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Próximamente: Calificar app')),
              );
            },
          ),

          const SizedBox(height: 24),

                  // Botón de Cerrar Sesión
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 8,
                    ),
                    child: OutlinedButton.icon(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

                  SizedBox(height: verticalPadding),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final verticalPadding = Responsive.getVerticalPadding(context);
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        8,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.amber),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Responsive.getHorizontalPadding(context) * 1.5,
        vertical: 4,
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'Español',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Idioma cambiado a Español')),
                );
              },
              activeColor: AppTheme.amber,
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language changed to English')),
                );
              },
              activeColor: AppTheme.amber,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar lógica de cierre de sesión
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesión cerrada')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

