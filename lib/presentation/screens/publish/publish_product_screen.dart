import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/domain/models/product.dart';
import 'package:el_ventorrillo/data/services/storage_service.dart';
import 'package:el_ventorrillo/presentation/providers/product_provider.dart';

class PublishProductScreen extends ConsumerStatefulWidget {
  const PublishProductScreen({super.key});

  @override
  ConsumerState<PublishProductScreen> createState() => _PublishProductScreenState();
}

class _PublishProductScreenState extends ConsumerState<PublishProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  ProductType _selectedType = ProductType.artesanal;
  ProductCategory? _selectedCategory;
  bool _isNew = true;
  final List<String> _imageUrls = [];
  bool _isUploadingImage = false;
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  // Categorías según el tipo
  List<ProductCategory> get _availableCategories {
    if (_selectedType == ProductType.artesanal) {
      return [
        ProductCategory.joyeria,
        ProductCategory.dulces,
        ProductCategory.arteTaino,
        ProductCategory.pinturas,
        ProductCategory.artesaniaGeneral,
      ];
    } else {
      return [
        ProductCategory.ropa,
        ProductCategory.electronica,
        ProductCategory.muebles,
        ProductCategory.libros,
        ProductCategory.deportes,
        ProductCategory.otros,
      ];
    }
  }

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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _addImage() async {
    // Verificar si ya se alcanzó el límite de imágenes
    if (_imageUrls.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo puedes agregar hasta 5 imágenes'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verificar si ya se está subiendo una imagen
    if (_isUploadingImage) {
      return;
    }

    try {
      // Mostrar diálogo para elegir fuente de imagen
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Seleccionar Imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      // Seleccionar imagen
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85, // Comprimir imagen para reducir tamaño
      );

      if (pickedFile == null) return;

      setState(() {
        _isUploadingImage = true;
      });

      // Subir imagen a Firebase Storage
      final file = File(pickedFile.path);
      
      // Mostrar diálogo de progreso
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Subiendo imagen...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      try {
        final imageUrl = await _storageService.uploadImage(
          file: file,
          folder: 'products',
        );

        // Cerrar diálogo de progreso
        if (mounted) {
          Navigator.of(context).pop();
        }

        setState(() {
          _imageUrls.add(imageUrl);
          _isUploadingImage = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Imagen agregada exitosamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (uploadError) {
        // Cerrar diálogo de progreso si hay error
        if (mounted) {
          Navigator.of(context).pop();
        }

        setState(() {
          _isUploadingImage = false;
        });

        if (mounted) {
          // Mostrar error detallado
          final errorMessage = uploadError.toString().replaceAll('Exception: ', '');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error al subir imagen'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageUrls.removeAt(index);
    });
  }

  Future<void> _publishProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor agrega al menos una imagen'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para publicar productos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Mostrar diálogo de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Publicando producto...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final repository = ref.read(productRepositoryProvider);
      
      // Crear ID único para el producto
      final productId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Obtener nombre del usuario
      final userName = user.displayName ?? user.email?.split('@').first ?? 'Usuario';

      // Crear el producto
      final product = Product(
        id: productId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        imageUrls: _imageUrls,
        type: _selectedType,
        category: _selectedCategory!,
        location: _locationController.text.trim(),
        sellerId: user.uid,
        sellerName: userName,
        createdAt: DateTime.now(),
        isNew: _isNew,
      );

      // Guardar en Firestore
      await repository.createProduct(product);

      // Invalidar el provider para refrescar la lista
      ref.invalidate(productsProvider);

      // Cerrar diálogo de carga
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Producto publicado exitosamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Regresar a la pantalla anterior
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Cerrar diálogo de carga
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Mostrar error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al publicar producto: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Producto'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: _publishProduct,
              icon: const Icon(Icons.check, size: 20),
              label: const Text('Publicar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.amber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = Responsive.getHorizontalPadding(context);
          final verticalPadding = Responsive.getVerticalPadding(context);
          final maxWidth = Responsive.getMaxContentWidth(context);
          
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(horizontalPadding),
                  children: [
            // Selector de Tipo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de Producto',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<ProductType>(
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
                      selected: {_selectedType},
                      onSelectionChanged: (Set<ProductType> newSelection) {
                        setState(() {
                          _selectedType = newSelection.first;
                          _selectedCategory = null; // Reset categoría al cambiar tipo
                        });
                      },
                      multiSelectionEnabled: false,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Título
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título del Producto',
                hintText: 'Ej: Collar de Larimar Artesanal',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un título';
                }
                if (value.length < 5) {
                  return 'El título debe tener al menos 5 caracteres';
                }
                return null;
              },
              maxLength: 100,
            ),

            const SizedBox(height: 16),

            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Describe tu producto en detalle...',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una descripción';
                }
                if (value.length < 20) {
                  return 'La descripción debe tener al menos 20 caracteres';
                }
                return null;
              },
              maxLength: 1000,
            ),

            const SizedBox(height: 16),

            // Precio
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio (RD\$)',
                hintText: '0',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un precio';
                }
                final price = int.tryParse(value);
                if (price == null || price <= 0) {
                  return 'El precio debe ser mayor a 0';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Categoría
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categoría',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableCategories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return FilterChip(
                          label: Text(_getCategoryLabel(category)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                          selectedColor: AppTheme.amberLight,
                          checkmarkColor: AppTheme.amberDark,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Ubicación
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación',
                hintText: 'Ej: La Vega, Zona Colonial, Santo Domingo',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa una ubicación';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Estado (solo para artesanales)
            if (_selectedType == ProductType.artesanal)
              Card(
                child: SwitchListTile(
                  title: const Text('Producto Nuevo'),
                  subtitle: const Text('Marca si el producto es nuevo'),
                  value: _isNew,
                  onChanged: (value) {
                    setState(() {
                      _isNew = value;
                    });
                  },
                  activeColor: AppTheme.amber,
                ),
              ),

            if (_selectedType == ProductType.artesanal)
              const SizedBox(height: 16),

            // Imágenes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Imágenes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${_imageUrls.length}/5',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_imageUrls.isEmpty)
                      GestureDetector(
                        onTap: _isUploadingImage ? null : _addImage,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppTheme.gray100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.gray300),
                          ),
                          child: Center(
                            child: _isUploadingImage
                                ? const CircularProgressIndicator()
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 48,
                                        color: AppTheme.gray400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Agrega fotos de tu producto',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageUrls.length + (_imageUrls.length < 5 ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _imageUrls.length) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: _isUploadingImage ? null : _addImage,
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: AppTheme.gray100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppTheme.gray300),
                                    ),
                                    child: _isUploadingImage
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : const Icon(Icons.add_photo_alternate),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: AppTheme.gray200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _imageUrls[index].startsWith('http')
                                          ? Image.network(
                                              _imageUrls[index],
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              _imageUrls[index],
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 16,
                                        icon: const Icon(Icons.close, color: Colors.white),
                                        onPressed: () => _removeImage(index),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    if (_imageUrls.length < 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: OutlinedButton.icon(
                          onPressed: _isUploadingImage ? null : _addImage,
                          icon: _isUploadingImage
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.add_photo_alternate),
                          label: Text(_isUploadingImage ? 'Subiendo...' : 'Agregar Imagen'),
                        ),
                      ),
                  ],
                ),
              ),
            ),

                    SizedBox(height: verticalPadding * 1.5),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

