import 'package:equatable/equatable.dart';

enum ProductType {
  artesanal, // "Lo Nuestro"
  segundaMano, // "El Reguero"
}

enum ProductCategory {
  // Artesanales
  joyeria,
  dulces,
  arteTaino,
  pinturas,
  artesaniaGeneral,

  // Segunda Mano
  ropa,
  electronica,
  muebles,
  libros,
  deportes,
  otros,
}

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final int price; // en pesos dominicanos
  final List<String> imageUrls;
  final ProductType type;
  final ProductCategory category;
  final String location; // Ej: "La Vega", "Zona Colonial"
  final String sellerId;
  final String sellerName;
  final DateTime createdAt;
  final bool isNew; // Para artesanales, si es nuevo o usado

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.type,
    required this.category,
    required this.location,
    required this.sellerId,
    required this.sellerName,
    required this.createdAt,
    this.isNew = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        imageUrls,
        type,
        category,
        location,
        sellerId,
        sellerName,
        createdAt,
        isNew,
      ];

  // Métodos para serialización con Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'type': type.name,
      'category': category.name,
      'location': location,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'createdAt': createdAt.toIso8601String(),
      'isNew': isNew,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    // Helper para convertir valores a String de forma segura en Flutter Web
    String _safeString(dynamic value, [String defaultValue = '']) {
      if (value == null) return defaultValue;
      if (value is String) return value;
      return value.toString();
    }

    // Helper para convertir valores a int de forma segura
    int _safeInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return Product(
      id: id,
      title: _safeString(map['title']),
      description: _safeString(map['description']),
      price: _safeInt(map['price']),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      type: ProductType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ProductType.artesanal,
      ),
      category: ProductCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ProductCategory.otros,
      ),
      location: _safeString(map['location']),
      sellerId: _safeString(map['sellerId']),
      sellerName: _safeString(map['sellerName']),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      isNew: map['isNew'] ?? true,
    );
  }
}
