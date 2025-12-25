# Cómo Acceder al Marketplace de Android Studio

## Método 1: Desde Settings (Configuración)

1. **Abre Settings (Configuración)**:
   - **Windows/Linux**: `File → Settings` (o presiona `Ctrl + Alt + S`)
   - **Mac**: `Android Studio → Preferences` (o presiona `Cmd + ,`)

2. **Navega a Plugins**:
   - En el panel izquierdo, busca y haz clic en **"Plugins"**
   - Verás dos pestañas: **"Installed"** (instalados) y **"Marketplace"** (o "Browse repositories" en versiones antiguas)

3. **Accede al Marketplace**:
   - Haz clic en la pestaña **"Marketplace"** (en la parte superior del panel de Plugins)

4. **Busca Flutter**:
   - En la barra de búsqueda, escribe: `Flutter`
   - Deberías ver el plugin "Flutter" (creado por Flutter Team)
   - Al instalarlo, también se instalará automáticamente el plugin "Dart"

## Método 2: Desde el Menú Principal

1. **Ve al menú principal de Android Studio**
2. **Selecciona**: `File → Settings` (o `Ctrl + Alt + S`)
3. **Sigue los pasos del Método 1** desde el paso 2

## Pasos para Instalar Flutter desde el Marketplace

1. **Busca "Flutter"** en el Marketplace
2. **Haz clic en el plugin "Flutter"** (debería aparecer como el primero en los resultados)
3. **Haz clic en el botón "Install"** (Instalar)
4. **Acepta la instalación de dependencias**: Android Studio te pedirá instalar también "Dart" (esto es normal y necesario)
5. **Espera a que se instale**: Verás una barra de progreso
6. **Reinicia Android Studio**: Cuando termine la instalación, te pedirá reiniciar Android Studio
   - Haz clic en **"Restart IDE"** o **"Restart"**

## Verificar que Flutter está Instalado

Después de reiniciar:

1. Ve a **File → Settings → Plugins**
2. En la pestaña **"Installed"**, busca "Flutter"
3. Deberías ver:
   - ✅ **Flutter** (con un checkmark verde)
   - ✅ **Dart** (instalado automáticamente)

## Si No Puedes Encontrar el Marketplace

En versiones muy antiguas de Android Studio, el Marketplace podría llamarse:
- **"Browse repositories"** (Explorar repositorios)
- O simplemente busca en la parte superior del diálogo de Plugins

## Si Ya Está Instalado pero No Funciona

Si Flutter ya aparece en "Installed" pero tienes problemas:

1. **Desinstálalo y reinstálalo**:
   - Haz clic en Flutter en la lista de "Installed"
   - Haz clic en "Uninstall" (Desinstalar)
   - Reinicia Android Studio
   - Vuelve a instalarlo desde Marketplace

2. **Verifica que el SDK de Flutter esté configurado**:
   - Ve a **File → Settings → Languages & Frameworks → Flutter**
   - Asegúrate de que **"Flutter SDK path"** esté configurado correctamente

## Resumen Visual de la Ruta

```
Android Studio
  └─> File → Settings (Ctrl+Alt+S)
      └─> Plugins
          └─> Marketplace (pestaña)
              └─> Buscar "Flutter"
                  └─> Install
                      └─> Restart IDE
```

¡Eso es todo! Después de instalar Flutter desde el Marketplace y reiniciar, deberías poder crear configuraciones de ejecución Flutter sin problemas.
