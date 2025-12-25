import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/domain/models/product.dart';
import 'package:el_ventorrillo/core/utils/currency_formatter.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  Color _getTypeColor() {
    switch (product.type) {
      case ProductType.artesanal:
        return AppTheme.amber;
      case ProductType.segundaMano:
        return AppTheme.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = isMobile ? 8.0 : 10.0;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppTheme.gray300,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'product-detail',
            pathParameters: {'id': product.id},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen del producto
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imageUrls.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.gray200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.gray200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppTheme.gray400,
                        size: 32,
                      ),
                    ),
                  ),
                  // Badge de tipo
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 6 : 8,
                        vertical: isMobile ? 3 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.type == ProductType.artesanal
                            ? 'Artesanal'
                            : 'Usado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 9 : 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Información del producto
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Título - toma el espacio disponible
                    Expanded(
                      child: Text(
                        product.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 13 : 14,
                              height: 1.3,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Precio - tamaño fijo
                    Padding(
                      padding: EdgeInsets.only(top: isMobile ? 4 : 6),
                      child: Text(
                        CurrencyFormatter.format(product.price),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: _getTypeColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 15 : 16,
                            ),
                      ),
                    ),

                    // Ubicación - tamaño fijo
                    Padding(
                      padding: EdgeInsets.only(top: isMobile ? 4 : 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: isMobile ? 12 : 14,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(width: isMobile ? 2 : 4),
                          Expanded(
                            child: Text(
                              product.location,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontSize: isMobile ? 11 : 12,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

