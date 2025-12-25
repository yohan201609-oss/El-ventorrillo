import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_ventorrillo/data/repositories/product_repository.dart';
import 'package:el_ventorrillo/domain/models/product.dart';

class FirestoreProductRepository implements ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colección de productos
  static const String _productsCollection = 'products';

  @override
  Future<List<Product>> getProducts(ProductType? type) async {
    try {
      Query query = _firestore.collection(_productsCollection);

      // Filtrar por tipo si se especifica
      if (type != null) {
        query = query.where('type', isEqualTo: type.name);
      }

      // Ordenar por fecha de creación (más recientes primero)
      // Nota: Si usas where + orderBy, necesitas un índice compuesto en Firestore
      // Si hay error, intentamos sin orderBy primero
      try {
        query = query.orderBy('createdAt', descending: true);
        final snapshot = await query.get();
        
        return snapshot.docs.map((doc) {
          try {
            return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          } catch (e) {
            // Si hay error al parsear un producto, lo omitimos
            return null;
          }
        }).whereType<Product>().toList();
      } catch (e) {
        // Si falla con orderBy, intentamos sin ordenar
        if (e.toString().contains('index') || e.toString().contains('Index')) {
          // Intentar sin orderBy
          Query fallbackQuery = _firestore.collection(_productsCollection);
          if (type != null) {
            fallbackQuery = fallbackQuery.where('type', isEqualTo: type.name);
          }
          final snapshot = await fallbackQuery.get();
          
          var products = snapshot.docs.map((doc) {
            try {
              return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
            } catch (e) {
              return null;
            }
          }).whereType<Product>().toList();
          
          // Ordenar manualmente
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return products;
        }
        rethrow;
      }
    } on FirebaseException catch (e) {
      // Errores específicos de Firebase
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permiso para leer productos. Verifica las reglas de Firestore.');
      } else if (e.code == 'unavailable') {
        throw Exception('Firestore no está disponible. Verifica tu conexión.');
      }
      throw Exception('Error de Firebase: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener productos: $e');
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore
          .collection(_productsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return Product.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Error al obtener producto: $e');
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verificar que el sellerId coincida con el usuario autenticado
      if (product.sellerId != user.uid) {
        throw Exception('No puedes crear productos para otro usuario');
      }

      await _firestore
          .collection(_productsCollection)
          .doc(product.id)
          .set(product.toMap());
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verificar que el usuario sea el vendedor
      final existingDoc = await _firestore
          .collection(_productsCollection)
          .doc(product.id)
          .get();

      if (!existingDoc.exists) {
        throw Exception('El producto no existe');
      }

      final existingProduct = Product.fromMap(existingDoc.data()!, product.id);
      if (existingProduct.sellerId != user.uid) {
        throw Exception('No tienes permiso para editar este producto');
      }

      await _firestore
          .collection(_productsCollection)
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verificar que el usuario sea el vendedor
      final doc = await _firestore
          .collection(_productsCollection)
          .doc(id)
          .get();

      if (!doc.exists) {
        throw Exception('El producto no existe');
      }

      final product = Product.fromMap(doc.data()!, id);
      if (product.sellerId != user.uid) {
        throw Exception('No tienes permiso para eliminar este producto');
      }

      await _firestore.collection(_productsCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }
}

