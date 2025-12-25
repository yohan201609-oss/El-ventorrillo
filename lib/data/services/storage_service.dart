import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sube una imagen a Firebase Storage y retorna la URL de descarga
  /// 
  /// [file] - El archivo de imagen a subir
  /// [folder] - La carpeta donde se guardará (ej: 'products', 'users')
  /// [fileName] - Nombre del archivo (opcional, se genera automáticamente si no se proporciona)
  Future<String> uploadImage({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      // Verificar que el archivo existe
      if (!await file.exists()) {
        throw Exception('El archivo no existe');
      }

      // Verificar tamaño del archivo (máximo 10MB)
      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception('El archivo es demasiado grande (máximo 10MB)');
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado. Por favor inicia sesión.');
      }

      // Generar nombre único si no se proporciona
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = file.path.split('.').last;
      final finalFileName = fileName ?? '${user.uid}_$timestamp.$extension';

      // Crear referencia en Firebase Storage
      final ref = _storage.ref().child('$folder/$finalFileName');

      // Configurar metadata
      final metadata = SettableMetadata(
        contentType: 'image/$extension',
        customMetadata: {
          'uploadedBy': user.uid,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Subir el archivo con timeout
      final uploadTask = ref.putFile(file, metadata);

      // Esperar con timeout de 60 segundos
      await uploadTask.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica tu conexión a internet.');
        },
      );

      // Verificar que la subida fue exitosa
      final snapshot = await uploadTask;
      if (snapshot.state != TaskState.success) {
        throw Exception('Error al subir la imagen: Estado ${snapshot.state}');
      }

      // Obtener la URL de descarga con timeout
      final downloadUrl = await ref.getDownloadURL().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado al obtener la URL.');
        },
      );

      return downloadUrl;
    } on FirebaseException catch (e) {
      // Errores específicos de Firebase
      String errorMessage = 'Error de Firebase: ';
      switch (e.code) {
        case 'unauthorized':
          errorMessage += 'No tienes permiso para subir archivos. Verifica las reglas de Storage.';
          break;
        case 'canceled':
          errorMessage += 'La subida fue cancelada.';
          break;
        case 'unknown':
          errorMessage += 'Error desconocido. Verifica tu conexión.';
          break;
        default:
          errorMessage += '${e.code}: ${e.message ?? "Error desconocido"}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      // Otros errores
      throw Exception('Error al subir la imagen: ${e.toString()}');
    }
  }

  /// Elimina una imagen de Firebase Storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error al eliminar la imagen: $e');
    }
  }
}

