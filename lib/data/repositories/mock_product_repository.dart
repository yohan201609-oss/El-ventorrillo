import 'package:el_ventorrillo/data/repositories/product_repository.dart';
import 'package:el_ventorrillo/domain/models/product.dart';

class MockProductRepository implements ProductRepository {
  static final List<Product> _mockProducts = [
    // Productos Artesanales - "Lo Nuestro"
    Product(
      id: '1',
      title: 'Collar de Larimar Auténtico',
      description: 'Hermoso collar de larimar dominicano, piedra única del Caribe. Hecho a mano por artesanos locales.',
      price: 2500,
      imageUrls: ['https://picsum.photos/400/400?random=1'],
      type: ProductType.artesanal,
      category: ProductCategory.joyeria,
      location: 'Santo Domingo',
      sellerId: 'seller1',
      sellerName: 'Artesanías Caribeñas',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isNew: true,
    ),
    Product(
      id: '2',
      title: 'Dulce de Leche Casero',
      description: 'Dulce de leche tradicional dominicano, hecho con receta familiar. Presentación de 500g.',
      price: 350,
      imageUrls: ['https://picsum.photos/400/400?random=2'],
      type: ProductType.artesanal,
      category: ProductCategory.dulces,
      location: 'La Vega',
      sellerId: 'seller2',
      sellerName: 'Dulces de Mamá',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isNew: true,
    ),
    Product(
      id: '3',
      title: 'Máscara Taína Tallada',
      description: 'Máscara artesanal tallada en madera, inspirada en la cultura taína. Pieza única.',
      price: 1800,
      imageUrls: ['https://picsum.photos/400/400?random=3'],
      type: ProductType.artesanal,
      category: ProductCategory.arteTaino,
      location: 'Zona Colonial',
      sellerId: 'seller3',
      sellerName: 'Arte Taíno RD',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      isNew: true,
    ),
    Product(
      id: '4',
      title: 'Pintura Acrílica "Atardecer Caribeño"',
      description: 'Pintura original de artista local, capturando la belleza del atardecer dominicano.',
      price: 4500,
      imageUrls: ['https://picsum.photos/400/400?random=4'],
      type: ProductType.artesanal,
      category: ProductCategory.pinturas,
      location: 'Santiago',
      sellerId: 'seller4',
      sellerName: 'Galería Caribe',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isNew: true,
    ),
    Product(
      id: '5',
      title: 'Pulsera de Conchas Marinas',
      description: 'Pulsera artesanal hecha con conchas marinas auténticas. Perfecta para el verano.',
      price: 450,
      imageUrls: ['https://picsum.photos/400/400?random=5'],
      type: ProductType.artesanal,
      category: ProductCategory.joyeria,
      location: 'Punta Cana',
      sellerId: 'seller5',
      sellerName: 'Accesorios del Mar',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      isNew: true,
    ),
    
    // Productos Segunda Mano - "El Reguero"
    Product(
      id: '6',
      title: 'iPhone 12 Pro - Excelente Estado',
      description: 'iPhone 12 Pro 128GB, en excelente estado. Incluye cargador y funda. Sin rayones.',
      price: 25000,
      imageUrls: ['https://picsum.photos/400/400?random=6'],
      type: ProductType.segundaMano,
      category: ProductCategory.electronica,
      location: 'Santo Domingo',
      sellerId: 'seller6',
      sellerName: 'Juan Pérez',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isNew: false,
    ),
    Product(
      id: '7',
      title: 'Sofá de 3 Plazas - Beige',
      description: 'Sofá cómodo de 3 plazas, color beige. En buen estado, solo cambio de decoración.',
      price: 8500,
      imageUrls: ['https://picsum.photos/400/400?random=7'],
      type: ProductType.segundaMano,
      category: ProductCategory.muebles,
      location: 'Santiago',
      sellerId: 'seller7',
      sellerName: 'María González',
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      isNew: false,
    ),
    Product(
      id: '8',
      title: 'Ropa de Marca - Varias Tallas',
      description: 'Lote de ropa de marca (Zara, H&M) en buen estado. Tallas S, M, L. Varios estilos.',
      price: 2000,
      imageUrls: ['https://picsum.photos/400/400?random=8'],
      type: ProductType.segundaMano,
      category: ProductCategory.ropa,
      location: 'La Vega',
      sellerId: 'seller8',
      sellerName: 'Ana Martínez',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isNew: false,
    ),
    Product(
      id: '9',
      title: 'Bicicleta de Montaña Trek',
      description: 'Bicicleta de montaña Trek, modelo 2020. Bien mantenida, cambio de neumáticos reciente.',
      price: 12000,
      imageUrls: ['https://picsum.photos/400/400?random=9'],
      type: ProductType.segundaMano,
      category: ProductCategory.deportes,
      location: 'Santo Domingo',
      sellerId: 'seller9',
      sellerName: 'Carlos Rodríguez',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      isNew: false,
    ),
    Product(
      id: '10',
      title: 'Libros de Literatura - Colección',
      description: 'Colección de libros de literatura latinoamericana. Incluye García Márquez, Vargas Llosa, etc.',
      price: 1500,
      imageUrls: ['https://picsum.photos/400/400?random=10'],
      type: ProductType.segundaMano,
      category: ProductCategory.libros,
      location: 'Zona Colonial',
      sellerId: 'seller10',
      sellerName: 'Librería Usada',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isNew: false,
    ),
  ];

  @override
  Future<List<Product>> getProducts(ProductType? type) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simular delay de red
    
    if (type == null) {
      return List.from(_mockProducts);
    }
    
    return _mockProducts.where((product) => product.type == type).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockProducts.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _mockProducts[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockProducts.removeWhere((product) => product.id == id);
  }
}

