// app/publicar/page.tsx
'use client';

import { useState, useRef, DragEvent, FormEvent } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/hooks/useAuth';
import { uploadProductImages } from '@/lib/storage';
import { createProduct } from '@/lib/firestore';
import { ProductType, ProductCategory } from '@/types/product';
import { getCategoryLabel } from '@/lib/utils';
import AuthGuard from '@/components/AuthGuard';

// Forzar renderizado dinámico (no prerenderizar)
export const dynamic = 'force-dynamic';
import { 
  Upload, 
  X, 
  Image as ImageIcon, 
  ArrowRight, 
  ArrowLeft,
  Check,
  Loader2
} from 'lucide-react';

type Step = 1 | 2 | 3;

export default function PublishProductPage() {
  const router = useRouter();
  const { user, userProfile } = useAuth();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [currentStep, setCurrentStep] = useState<Step>(1);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [uploadProgress, setUploadProgress] = useState(0);

  // Formulario
  const [images, setImages] = useState<File[]>([]);
  const [imagePreviews, setImagePreviews] = useState<string[]>([]);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [type, setType] = useState<ProductType>(ProductType.ARTESANAL);
  const [category, setCategory] = useState<ProductCategory>(ProductCategory.JOYERIA);
  const [location, setLocation] = useState('');
  const [isNew, setIsNew] = useState(true);

  // Obtener categorías disponibles según el tipo
  const availableCategories = type === ProductType.ARTESANAL
    ? [
        ProductCategory.JOYERIA,
        ProductCategory.DULCES,
        ProductCategory.ARTE_TAINO,
        ProductCategory.PINTURAS,
        ProductCategory.ARTESANIA_GENERAL,
      ]
    : [
        ProductCategory.ROPA,
        ProductCategory.ELECTRONICA,
        ProductCategory.MUEBLES,
        ProductCategory.LIBROS,
        ProductCategory.DEPORTES,
        ProductCategory.OTROS,
      ];

  // Manejar selección de archivos
  const handleFileSelect = (files: FileList | null) => {
    if (!files) return;

    const newFiles: File[] = [];
    const newPreviews: string[] = [];

    Array.from(files).forEach((file) => {
      if (images.length + newFiles.length >= 5) {
        setError('Solo puedes subir hasta 5 imágenes');
        return;
      }

      if (!file.type.startsWith('image/')) {
        setError(`${file.name} no es una imagen válida`);
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        setError(`${file.name} es demasiado grande. Máximo 5MB`);
        return;
      }

      newFiles.push(file);
      const reader = new FileReader();
      reader.onload = (e) => {
        if (e.target?.result) {
          newPreviews.push(e.target.result as string);
          if (newPreviews.length === newFiles.length) {
            setImagePreviews([...imagePreviews, ...newPreviews]);
          }
        }
      };
      reader.readAsDataURL(file);
    });

    setImages([...images, ...newFiles]);
    setError('');
  };

  // Drag and drop
  const handleDragOver = (e: DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.stopPropagation();
  };

  const handleDrop = (e: DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    e.stopPropagation();
    handleFileSelect(e.dataTransfer.files);
  };

  // Eliminar imagen
  const removeImage = (index: number) => {
    setImages(images.filter((_, i) => i !== index));
    setImagePreviews(imagePreviews.filter((_, i) => i !== index));
  };

  // Validar paso 1 (imágenes)
  const validateStep1 = (): boolean => {
    if (images.length === 0) {
      setError('Debes subir al menos una imagen');
      return false;
    }
    return true;
  };

  // Validar paso 2 (detalles)
  const validateStep2 = (): boolean => {
    if (!title.trim() || title.trim().length < 3) {
      setError('El título debe tener al menos 3 caracteres');
      return false;
    }
    if (!description.trim() || description.trim().length < 10) {
      setError('La descripción debe tener al menos 10 caracteres');
      return false;
    }
    const priceNum = parseFloat(price);
    if (!price || isNaN(priceNum) || priceNum <= 0) {
      setError('El precio debe ser un número mayor a 0');
      return false;
    }
    if (!location.trim()) {
      setError('Debes especificar una ubicación');
      return false;
    }
    return true;
  };

  // Siguiente paso
  const handleNext = () => {
    setError('');
    if (currentStep === 1) {
      if (validateStep1()) {
        setCurrentStep(2);
      }
    } else if (currentStep === 2) {
      if (validateStep2()) {
        setCurrentStep(3);
      }
    }
  };

  // Paso anterior
  const handlePrevious = () => {
    setError('');
    if (currentStep === 2) {
      setCurrentStep(1);
    } else if (currentStep === 3) {
      setCurrentStep(2);
    }
  };

  // Publicar producto
  const handlePublish = async () => {
    if (!user || !userProfile) {
      setError('Debes estar autenticado para publicar un producto');
      return;
    }

    setError('');
    setLoading(true);
    setUploadProgress(0);

    try {
      // Subir imágenes
      setUploadProgress(30);
      const imageUrls = await uploadProductImages(images, user.uid);
      setUploadProgress(60);

      // Crear producto
      const productId = await createProduct({
        title: title.trim(),
        description: description.trim(),
        price: parseFloat(price),
        imageUrls,
        type,
        category,
        location: location.trim(),
        sellerId: user.uid,
        sellerName: userProfile.displayName,
        isNew,
      });

      setUploadProgress(100);

      // Redirigir al producto
      router.push(`/producto/${productId}`);
    } catch (err: any) {
      setError(err.message || 'Error al publicar el producto');
      setLoading(false);
      setUploadProgress(0);
    }
  };

  return (
    <AuthGuard requireAuth={true}>
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          {/* Header */}
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-900 mb-2">Publicar Producto</h1>
            <p className="text-gray-600">Completa los pasos para publicar tu producto</p>
          </div>

          {/* Indicador de pasos */}
          <div className="mb-8">
            <div className="flex items-center justify-between">
              {[1, 2, 3].map((step) => (
                <div key={step} className="flex items-center flex-1">
                  <div className="flex flex-col items-center flex-1">
                    <div
                      className={`w-12 h-12 rounded-full flex items-center justify-center font-bold text-lg transition-colors ${
                        currentStep === step
                          ? 'bg-[#002D62] text-white'
                          : currentStep > step
                          ? 'bg-green-500 text-white'
                          : 'bg-gray-200 text-gray-600'
                      }`}
                    >
                      {currentStep > step ? (
                        <Check className="w-6 h-6" />
                      ) : (
                        step
                      )}
                    </div>
                    <span className="mt-2 text-sm font-medium text-gray-700">
                      {step === 1 ? 'Fotos' : step === 2 ? 'Detalles' : 'Publicar'}
                    </span>
                  </div>
                  {step < 3 && (
                    <div
                      className={`flex-1 h-1 mx-2 ${
                        currentStep > step ? 'bg-green-500' : 'bg-gray-200'
                      }`}
                    />
                  )}
                </div>
              ))}
            </div>
          </div>

          {/* Mensaje de error */}
          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
              <p className="text-sm text-red-800">{error}</p>
            </div>
          )}

          {/* Progress bar durante upload */}
          {loading && (
            <div className="mb-6">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-medium text-gray-700">Publicando producto...</span>
                <span className="text-sm text-gray-600">{uploadProgress}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-gradient-to-r from-[#CE1126] to-[#002D62] h-2 rounded-full transition-all duration-300"
                  style={{ width: `${uploadProgress}%` }}
                />
              </div>
            </div>
          )}

          {/* Contenido del formulario */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            {/* Paso 1: Fotos */}
            {currentStep === 1 && (
              <div className="space-y-6">
                <h2 className="text-2xl font-bold text-gray-900">1. Sube las fotos de tu producto</h2>
                <p className="text-gray-600">Puedes subir hasta 5 imágenes (máximo 5MB cada una)</p>

                {/* Área de drag & drop */}
                <div
                  onDragOver={handleDragOver}
                  onDrop={handleDrop}
                  className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center hover:border-[#002D62] transition-colors cursor-pointer"
                  onClick={() => fileInputRef.current?.click()}
                >
                  <input
                    ref={fileInputRef}
                    type="file"
                    multiple
                    accept="image/*"
                    onChange={(e) => handleFileSelect(e.target.files)}
                    className="hidden"
                  />
                  <Upload className="w-12 h-12 text-gray-400 mx-auto mb-4" />
                  <p className="text-lg font-medium text-gray-700 mb-2">
                    Arrastra imágenes aquí o haz clic para seleccionar
                  </p>
                  <p className="text-sm text-gray-500">
                    PNG, JPG, GIF hasta 5MB
                  </p>
                </div>

                {/* Preview de imágenes */}
                {imagePreviews.length > 0 && (
                  <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
                    {imagePreviews.map((preview, index) => (
                      <div key={index} className="relative group">
                        <div className="aspect-square rounded-lg overflow-hidden bg-gray-100">
                          <img
                            src={preview}
                            alt={`Preview ${index + 1}`}
                            className="w-full h-full object-cover"
                          />
                        </div>
                        <button
                          type="button"
                          onClick={() => removeImage(index)}
                          className="absolute top-2 right-2 bg-red-500 text-white rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
                        >
                          <X className="w-4 h-4" />
                        </button>
                        {index === 0 && (
                          <span className="absolute bottom-2 left-2 bg-[#002D62] text-white text-xs px-2 py-1 rounded">
                            Principal
                          </span>
                        )}
                      </div>
                    ))}
                  </div>
                )}
              </div>
            )}

            {/* Paso 2: Detalles */}
            {currentStep === 2 && (
              <div className="space-y-6">
                <h2 className="text-2xl font-bold text-gray-900">2. Detalles del producto</h2>

                {/* Tipo de producto */}
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Tipo de Producto *
                  </label>
                  <div className="grid grid-cols-2 gap-4">
                    <button
                      type="button"
                      onClick={() => {
                        setType(ProductType.ARTESANAL);
                        setCategory(ProductCategory.JOYERIA);
                      }}
                      className={`px-4 py-3 rounded-lg font-medium transition-colors ${
                        type === ProductType.ARTESANAL
                          ? 'bg-[#F59E0B] text-white'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      Lo Nuestro
                    </button>
                    <button
                      type="button"
                      onClick={() => {
                        setType(ProductType.SEGUNDA_MANO);
                        setCategory(ProductCategory.ROPA);
                      }}
                      className={`px-4 py-3 rounded-lg font-medium transition-colors ${
                        type === ProductType.SEGUNDA_MANO
                          ? 'bg-[#10B981] text-white'
                          : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                      }`}
                    >
                      El Reguero
                    </button>
                  </div>
                </div>

                {/* Categoría */}
                <div>
                  <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-2">
                    Categoría *
                  </label>
                  <select
                    id="category"
                    value={category}
                    onChange={(e) => setCategory(e.target.value as ProductCategory)}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62]"
                  >
                    {availableCategories.map((cat) => (
                      <option key={cat} value={cat}>
                        {getCategoryLabel(cat)}
                      </option>
                    ))}
                  </select>
                </div>

                {/* Título */}
                <div>
                  <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-2">
                    Título del Producto *
                  </label>
                  <input
                    id="title"
                    type="text"
                    value={title}
                    onChange={(e) => setTitle(e.target.value)}
                    placeholder="Ej: Collar de ámbar artesanal"
                    maxLength={100}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62]"
                  />
                  <p className="mt-1 text-xs text-gray-500">{title.length}/100 caracteres</p>
                </div>

                {/* Descripción */}
                <div>
                  <label htmlFor="description" className="block text-sm font-medium text-gray-700 mb-2">
                    Descripción *
                  </label>
                  <textarea
                    id="description"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Describe tu producto en detalle..."
                    rows={6}
                    maxLength={1000}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62] resize-none"
                  />
                  <p className="mt-1 text-xs text-gray-500">{description.length}/1000 caracteres</p>
                </div>

                {/* Precio */}
                <div>
                  <label htmlFor="price" className="block text-sm font-medium text-gray-700 mb-2">
                    Precio (RD$) *
                  </label>
                  <div className="relative">
                    <span className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-500">
                      RD$
                    </span>
                    <input
                      id="price"
                      type="number"
                      value={price}
                      onChange={(e) => setPrice(e.target.value)}
                      placeholder="0"
                      min="1"
                      step="1"
                      className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62]"
                    />
                  </div>
                </div>

                {/* Ubicación */}
                <div>
                  <label htmlFor="location" className="block text-sm font-medium text-gray-700 mb-2">
                    Ubicación *
                  </label>
                  <input
                    id="location"
                    type="text"
                    value={location}
                    onChange={(e) => setLocation(e.target.value)}
                    placeholder="Ej: Santo Domingo, Distrito Nacional"
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62]"
                  />
                </div>

                {/* Estado (solo para artesanales) */}
                {type === ProductType.ARTESANAL && (
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Estado
                    </label>
                    <div className="flex gap-4">
                      <label className="flex items-center">
                        <input
                          type="radio"
                          checked={isNew}
                          onChange={() => setIsNew(true)}
                          className="mr-2"
                        />
                        <span>Nuevo</span>
                      </label>
                      <label className="flex items-center">
                        <input
                          type="radio"
                          checked={!isNew}
                          onChange={() => setIsNew(false)}
                          className="mr-2"
                        />
                        <span>Usado</span>
                      </label>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Paso 3: Resumen y publicar */}
            {currentStep === 3 && (
              <div className="space-y-6">
                <h2 className="text-2xl font-bold text-gray-900">3. Revisa y publica</h2>
                <p className="text-gray-600">Revisa la información antes de publicar</p>

                {/* Resumen */}
                <div className="bg-gray-50 rounded-lg p-6 space-y-4">
                  <div>
                    <h3 className="font-semibold text-gray-900 mb-2">Imágenes ({images.length})</h3>
                    <div className="grid grid-cols-5 gap-2">
                      {imagePreviews.slice(0, 5).map((preview, index) => (
                        <div key={index} className="aspect-square rounded-lg overflow-hidden bg-gray-200">
                          <img
                            src={preview}
                            alt={`Preview ${index + 1}`}
                            className="w-full h-full object-cover"
                          />
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="grid grid-cols-2 gap-4 pt-4 border-t border-gray-200">
                    <div>
                      <p className="text-sm text-gray-500">Título</p>
                      <p className="font-medium text-gray-900">{title}</p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500">Precio</p>
                      <p className="font-medium text-gray-900">RD$ {parseFloat(price).toLocaleString()}</p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500">Tipo</p>
                      <p className="font-medium text-gray-900">
                        {type === ProductType.ARTESANAL ? 'Lo Nuestro' : 'El Reguero'}
                      </p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500">Categoría</p>
                      <p className="font-medium text-gray-900">{getCategoryLabel(category)}</p>
                    </div>
                    <div>
                      <p className="text-sm text-gray-500">Ubicación</p>
                      <p className="font-medium text-gray-900">{location}</p>
                    </div>
                    {type === ProductType.ARTESANAL && (
                      <div>
                        <p className="text-sm text-gray-500">Estado</p>
                        <p className="font-medium text-gray-900">{isNew ? 'Nuevo' : 'Usado'}</p>
                      </div>
                    )}
                  </div>

                  <div className="pt-4 border-t border-gray-200">
                    <p className="text-sm text-gray-500 mb-2">Descripción</p>
                    <p className="text-gray-700 whitespace-pre-wrap">{description}</p>
                  </div>
                </div>
              </div>
            )}

            {/* Botones de navegación */}
            <div className="mt-8 flex items-center justify-between pt-6 border-t border-gray-200">
              <button
                type="button"
                onClick={handlePrevious}
                disabled={currentStep === 1 || loading}
                className="flex items-center gap-2 px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <ArrowLeft className="w-5 h-5" />
                Anterior
              </button>

              {currentStep < 3 ? (
                <button
                  type="button"
                  onClick={handleNext}
                  disabled={loading}
                  className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Siguiente
                  <ArrowRight className="w-5 h-5" />
                </button>
              ) : (
                <button
                  type="button"
                  onClick={handlePublish}
                  disabled={loading}
                  className="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {loading ? (
                    <>
                      <Loader2 className="w-5 h-5 animate-spin" />
                      Publicando...
                    </>
                  ) : (
                    <>
                      <Check className="w-5 h-5" />
                      Publicar Producto
                    </>
                  )}
                </button>
              )}
            </div>
          </div>
        </div>
      </div>
    </AuthGuard>
  );
}

