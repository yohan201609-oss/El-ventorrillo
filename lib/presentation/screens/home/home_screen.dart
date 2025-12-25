import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/presentation/providers/product_provider.dart';
import 'package:el_ventorrillo/domain/models/product.dart';
import 'package:el_ventorrillo/presentation/widgets/product_card.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/widgets/circular_logo_widget.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productTypeFilter = ref.watch(productTypeFilterProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const CircularLogo(size: 50.0),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = Responsive.getHorizontalPadding(context);
          final verticalPadding = Responsive.getVerticalPadding(context);
          final gridColumns = Responsive.getGridColumns(context);
          final spacing = Responsive.getSpacing(context, mobile: 12.0);
          
          return Column(
            children: [
              // Selector de Modo (El Switch)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: SegmentedButton<ProductType>(
                  segments: const [
                    ButtonSegment<ProductType>(
                      value: ProductType.artesanal,
                      label: Text('Lo Nuestro'),
                      icon: Icon(Icons.handshake),
                    ),
                    ButtonSegment<ProductType>(
                      value: ProductType.segundaMano,
                      label: Text('El Reguero'),
                      icon: Icon(Icons.recycling),
                    ),
                  ],
                  selected: {productTypeFilter},
                  onSelectionChanged: (Set<ProductType> newSelection) {
                    ref.read(productTypeFilterProvider.notifier).setFilter(
                          newSelection.first,
                        );
                  },
                  multiSelectionEnabled: false,
                ),
              ),

              // Grid de Productos
              Expanded(
                child: productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: Responsive.isMobile(context) ? 64 : 80,
                              color: AppTheme.gray400,
                            ),
                            SizedBox(height: Responsive.getSpacing(context, mobile: 16.0)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Text(
                                productTypeFilter == ProductType.artesanal
                                    ? 'No hay productos artesanales disponibles'
                                    : 'No hay productos de segunda mano disponibles',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Calcular aspect ratio dinámicamente según el tamaño de pantalla
                    // Aspect ratio más pequeño = más altura para el contenido
                    double aspectRatio;
                    if (Responsive.isMobile(context)) {
                      // Para móviles, usar un aspect ratio que permita ver todo el contenido
                      // 0.6 = más espacio vertical para texto
                      aspectRatio = 0.6;
                    } else if (Responsive.isTablet(context)) {
                      aspectRatio = 0.65;
                    } else {
                      aspectRatio = 0.7;
                    }
                    
                    return GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        Responsive.isMobile(context) ? 80 : 100,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumns,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    );
                  },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar productos',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(productsProvider);
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          return FloatingActionButton.extended(
            onPressed: () {
              context.push('/publish');
            },
            icon: const Icon(Icons.add),
            label: const Text('Publicar'),
            backgroundColor: AppTheme.amber,
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }
}

