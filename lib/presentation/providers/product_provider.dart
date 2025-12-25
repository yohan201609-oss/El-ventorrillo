import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:el_ventorrillo/data/repositories/firestore_product_repository.dart';
import 'package:el_ventorrillo/data/repositories/mock_product_repository.dart';
import 'package:el_ventorrillo/data/repositories/product_repository.dart';
import 'package:el_ventorrillo/domain/models/product.dart';

part 'product_provider.g.dart';

// Variable para cambiar entre Firestore y Mock
// Cambia a false para usar datos mock si hay problemas con Firestore
const bool _useFirestore = true;

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  if (_useFirestore) {
    return FirestoreProductRepository();
  } else {
    return MockProductRepository();
  }
}

@riverpod
class ProductTypeFilter extends _$ProductTypeFilter {
  @override
  ProductType build() => ProductType.artesanal; // Por defecto mostrar "Lo Nuestro"

  void setFilter(ProductType type) {
    state = type;
  }
}

@riverpod
Future<List<Product>> products(ProductsRef ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final filter = ref.watch(productTypeFilterProvider);
  
  return await repository.getProducts(filter);
}

@riverpod
Future<Product?> productById(ProductByIdRef ref, String productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductById(productId);
}

