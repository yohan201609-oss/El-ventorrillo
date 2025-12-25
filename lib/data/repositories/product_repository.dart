import 'package:el_ventorrillo/domain/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts(ProductType? type);
  Future<Product?> getProductById(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

