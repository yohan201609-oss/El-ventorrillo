import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';

class MainShellScreen extends StatefulWidget {
  final Widget child;
  
  const MainShellScreen({
    super.key,
    required this.child,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/chat');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determinar el índice actual basado en la ruta
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    
    if (location == '/' || location == '/home') {
      currentIndex = 0;
    } else if (location == '/search') {
      currentIndex = 1;
    } else if (location.startsWith('/chat')) {
      currentIndex = 2;
    } else if (location == '/profile') {
      currentIndex = 3;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = Responsive.isMobile(context);
        
        if (isMobile) {
          return Scaffold(
            body: widget.child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: AppTheme.white,
              elevation: 8,
              indicatorColor: AppTheme.amberLight.withOpacity(0.3),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: 'Buscar',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline),
                  selectedIcon: Icon(Icons.chat_bubble),
                  label: 'Chat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: _onItemTapped,
                  backgroundColor: AppTheme.white,
                  indicatorColor: AppTheme.amberLight.withOpacity(0.3),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search_outlined),
                      selectedIcon: Icon(Icons.search),
                      label: Text('Buscar'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chat_bubble_outline),
                      selectedIcon: Icon(Icons.chat_bubble),
                      label: Text('Chat'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Perfil'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: widget.child),
              ],
            ),
          );
        }
      },
    );
  }
}

