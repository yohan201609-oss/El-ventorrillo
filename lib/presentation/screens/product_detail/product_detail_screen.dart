import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/currency_formatter.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/domain/models/product.dart';
import 'package:el_ventorrillo/presentation/providers/product_provider.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  String _getCategoryLabel(ProductCategory category) {
    switch (category) {
      case ProductCategory.joyeria:
        return 'Joyería';
      case ProductCategory.dulces:
        return 'Dulces';
      case ProductCategory.arteTaino:
        return 'Arte Taíno';
      case ProductCategory.pinturas:
        return 'Pinturas';
      case ProductCategory.artesaniaGeneral:
        return 'Artesanía General';
      case ProductCategory.ropa:
        return 'Ropa';
      case ProductCategory.electronica:
        return 'Electrónica';
      case ProductCategory.muebles:
        return 'Muebles';
      case ProductCategory.libros:
        return 'Libros';
      case ProductCategory.deportes:
        return 'Deportes';
      case ProductCategory.otros:
        return 'Otros';
    }
  }

  Color _getTypeColor(ProductType type) {
    switch (type) {
      case ProductType.artesanal:
        return AppTheme.amber;
      case ProductType.segundaMano:
        return AppTheme.green;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Hace ${difference.inMinutes} minutos';
      }
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  Future<void> _shareProduct(Product product) async {
    final typeLabel =
        product.type == ProductType.artesanal ? 'Lo Nuestro' : 'El Reguero';
    final categoryLabel = _getCategoryLabel(product.category);

    final shareText = '''
🔔 $typeLabel - ${product.title}

💰 Precio: ${CurrencyFormatter.format(product.price)}
📍 Ubicación: ${product.location}
📂 Categoría: $categoryLabel

${product.description}

📱 Descubre más productos en El Ventorrillo
''';

    try {
      await Share.share(
        shareText,
        subject: product.title,
      );
    } catch (e) {
      // El error se maneja silenciosamente ya que Share.share
      // puede lanzar excepciones si el usuario cancela
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              productAsync.whenData((product) {
                if (product != null) {
                  _shareProduct(product);
                }
              });
            },
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Producto no encontrado',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID del producto: $productId',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }

          // Debug: Verificar que el producto se cargó
          debugPrint(
              'ProductDetailScreen: Producto cargado - ${product.title}');
          debugPrint(
              'ProductDetailScreen: Imágenes - ${product.imageUrls.length}');
          debugPrint(
              'ProductDetailScreen: Descripción - ${product.description.substring(0, product.description.length > 50 ? 50 : product.description.length)}...');

          final typeColor = _getTypeColor(product.type);
          final horizontalPadding = Responsive.getHorizontalPadding(context);
          final verticalPadding = Responsive.getVerticalPadding(context);
          final imageHeight = Responsive.isMobile(context) ? 400.0 : 500.0;
          final maxWidth = Responsive.getMaxContentWidth(context);

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Debug: Widget muy visible para verificar renderizado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red, width: 3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🔴 DEBUG VISIBLE - Si ves esto, el contenido se está renderizando',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red.shade900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Título: ${product.title}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Precio: ${CurrencyFormatter.format(product.price)}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.red.shade900),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Imágenes: ${product.imageUrls.length}',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.red.shade900),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                minHeight: 20,
                              ),
                              child: Text(
                                'Descripción: ${product.description}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Galería de imágenes
                      Container(
                        height: imageHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppTheme.gray200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: product.imageUrls.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                  color: AppTheme.gray400,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: PageView.builder(
                                  itemCount: product.imageUrls.length,
                                  itemBuilder: (context, index) {
                                    return CachedNetworkImage(
                                      imageUrl: product.imageUrls[index],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: AppTheme.gray200,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: AppTheme.gray200,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 64,
                                            color: AppTheme.gray400,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),

                      // Información principal
                      Container(
                        color: AppTheme.white,
                        padding: EdgeInsets.all(horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badge de tipo
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                product.type == ProductType.artesanal
                                    ? 'Lo Nuestro'
                                    : 'El Reguero',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Título
                            Text(
                              product.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),

                            const SizedBox(height: 8),

                            // Precio
                            Text(
                              CurrencyFormatter.format(product.price),
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: typeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const SizedBox(height: 16),

                            // Información adicional
                            Row(
                              children: [
                                Expanded(
                                  child: _InfoItem(
                                    icon: Icons.category_outlined,
                                    label: 'Categoría',
                                    value: _getCategoryLabel(product.category),
                                  ),
                                ),
                                Expanded(
                                  child: _InfoItem(
                                    icon: Icons.location_on_outlined,
                                    label: 'Ubicación',
                                    value: product.location,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Fecha de publicación
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(product.createdAt),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: verticalPadding),

                      // Descripción
                      Padding(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                color: Colors.yellow.shade100,
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  product.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: verticalPadding),

                      // Información del vendedor
                      Container(
                        color: AppTheme.white,
                        padding: EdgeInsets.all(horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vendedor',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: typeColor.withOpacity(0.2),
                                  child: Icon(
                                    Icons.person,
                                    color: typeColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.sellerName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Ver perfil',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: typeColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed: () {
                                    // TODO: Navegar al perfil del vendedor
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Perfil del vendedor próximamente'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: Responsive.isMobile(context)
                              ? 100
                              : 120), // Espacio para el botón fijo
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Cargando producto...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'ID: $productId',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        error: (error, stack) {
          // Log del error para debugging
          debugPrint('ProductDetailScreen ERROR: $error');
          debugPrint('ProductDetailScreen STACK: $stack');

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar el producto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID del producto: $productId',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalles del error:',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.invalidate(productByIdProvider(productId));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Volver'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: productAsync.when(
        data: (product) {
          if (product == null) return const SizedBox.shrink();

          final typeColor = _getTypeColor(product.type);

          final horizontalPadding = Responsive.getHorizontalPadding(context);

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = Responsive.isMobile(context);

                  if (isMobile) {
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Usar go en lugar de push para evitar problemas de claves duplicadas
                              context.go(
                                '/chat?recipientId=${Uri.encodeComponent(product.sellerId)}&recipientName=${Uri.encodeComponent(product.sellerName)}&productTitle=${Uri.encodeComponent(product.title)}',
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text('Contactar'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Implementar compra
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Proceso de compra próximamente'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Comprar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: typeColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: Responsive.getMaxContentWidth(context),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Usar go en lugar de push para evitar problemas de claves duplicadas
                                  context.go(
                                    '/chat?recipientId=${Uri.encodeComponent(product.sellerId)}&recipientName=${Uri.encodeComponent(product.sellerName)}&productTitle=${Uri.encodeComponent(product.title)}',
                                  );
                                },
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Contactar'),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: Implementar compra
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Proceso de compra próximamente'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.shopping_cart),
                                label: const Text('Comprar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: typeColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
