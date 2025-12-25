# Instrucciones para Implementar el Logo

## Paso 1: Colocar el archivo del logo

1. Coloca tu archivo de logo en la carpeta `public` del proyecto:
   ```
   el-ventorrillo-web/public/logo_ventorrillo.png
   ```

2. **Formatos soportados:**
   - PNG (recomendado)
   - JPG/JPEG
   - SVG (mejor para escalabilidad)
   - WebP (mejor rendimiento)

3. **Tamaño recomendado:**
   - Mínimo: 200x200px
   - Óptimo: 400x400px o más
   - Para mejor calidad: 800x800px

## Paso 2: Verificar que el logo se muestre

Una vez que coloques el archivo `logo_ventorrillo.png` en la carpeta `public`, el logo aparecerá automáticamente en:

- ✅ **Navbar** (barra de navegación superior)
- ✅ **Footer** (pie de página)

## Paso 3: Si el logo no aparece

1. **Verifica el nombre del archivo:**
   - Debe llamarse exactamente: `logo_ventorrillo.png`
   - Si tu archivo tiene otro nombre, cambia el nombre o actualiza el código

2. **Verifica la ubicación:**
   - El archivo debe estar en: `el-ventorrillo-web/public/logo_ventorrillo.png`
   - NO debe estar en `public/images/` u otra subcarpeta

3. **Si usas otro nombre de archivo:**
   - Edita `components/Navbar.tsx` línea ~79: cambia `/logo_ventorrillo.png` por tu nombre
   - Edita `components/Footer.tsx` línea ~12: cambia `/logo_ventorrillo.png` por tu nombre

## Paso 4: Personalizar el tamaño (opcional)

Si necesitas ajustar el tamaño del logo:

### En el Navbar:
Edita `components/Navbar.tsx` línea ~75:
```tsx
<div className="relative w-10 h-10 flex-shrink-0">
  {/* Cambia w-10 h-10 por el tamaño deseado, ej: w-12 h-12 */}
```

### En el Footer:
Edita `components/Footer.tsx` línea ~11:
```tsx
<div className="relative w-12 h-12 flex-shrink-0">
  {/* Cambia w-12 h-12 por el tamaño deseado */}
```

## Paso 5: Usar formato SVG (recomendado para mejor calidad)

Si tienes el logo en formato SVG:

1. Coloca el archivo como `logo_ventorrillo.svg` en `public/`
2. Actualiza las referencias en los componentes:
   - `components/Navbar.tsx`: cambia `.png` por `.svg`
   - `components/Footer.tsx`: cambia `.png` por `.svg`

## Notas importantes

- El logo se optimiza automáticamente con `next/image`
- El logo tiene `priority` en el Navbar para cargar rápido
- El logo es responsive y se adapta a diferentes tamaños de pantalla
- Si el logo no se encuentra, Next.js mostrará un error en la consola

## Estructura de archivos esperada

```
el-ventorrillo-web/
  ├── public/
  │   └── logo_ventorrillo.png  ← Tu logo aquí
  ├── components/
  │   ├── Navbar.tsx            ← Usa el logo
  │   └── Footer.tsx            ← Usa el logo
  └── ...
```

