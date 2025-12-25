import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? location; // Ej: "Santo Domingo", "La Vega"
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.location,
    required this.createdAt,
    this.lastLoginAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        location,
        createdAt,
        lastLoginAt,
      ];

  // Método para convertir a Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  // Factory para crear desde Map (desde Firestore)
  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    // Helper para convertir Timestamp o String a DateTime
    DateTime _parseDateTime(dynamic value) {
      if (value == null) {
        throw ArgumentError('DateTime value cannot be null');
      }
      
      // Si es un Timestamp de Firestore
      if (value is Timestamp) {
        return value.toDate();
      }
      
      // Si es un String, parsearlo
      if (value is String) {
        return DateTime.parse(value);
      }
      
      // Si es un DateTime, devolverlo directamente
      if (value is DateTime) {
        return value;
      }
      
      // Intentar convertir a String y parsear
      return DateTime.parse(value.toString());
    }

    // Helper para convertir Timestamp o String a DateTime (nullable)
    DateTime? _parseDateTimeNullable(dynamic value) {
      if (value == null) return null;
      
      // Si es un Timestamp de Firestore
      if (value is Timestamp) {
        return value.toDate();
      }
      
      // Si es un String, parsearlo
      if (value is String) {
        return DateTime.parse(value);
      }
      
      // Si es un DateTime, devolverlo directamente
      if (value is DateTime) {
        return value;
      }
      
      // Intentar convertir a String y parsear
      return DateTime.parse(value.toString());
    }

    return AppUser(
      id: id,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      location: map['location'] as String?,
      createdAt: _parseDateTime(map['createdAt']),
      lastLoginAt: _parseDateTimeNullable(map['lastLoginAt']),
    );
  }

  // Copiar con cambios
  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? location,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

