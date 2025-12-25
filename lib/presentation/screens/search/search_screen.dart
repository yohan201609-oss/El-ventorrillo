import 'package:flutter/material.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: Responsive.isMobile(context) ? 64 : 80,
                  color: AppTheme.gray400,
                ),
                SizedBox(height: Responsive.getSpacing(context, mobile: 16.0)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.getHorizontalPadding(context),
                  ),
                  child: Text(
                    'Búsqueda de productos',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Responsive.getSpacing(context, mobile: 8.0)),
                Text(
                  'Próximamente',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

