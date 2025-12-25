import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
      ),
      body: FutureBuilder<String>(
        future: _loadPrivacyPolicy(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error al cargar el documento',
                    style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(),
                    style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }

          final content = snapshot.data ?? '';

          return LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = Responsive.getHorizontalPadding(context);
              final verticalPadding = Responsive.getVerticalPadding(context);
              final maxWidth = Responsive.getMaxContentWidth(context);

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: _buildFormattedContent(context, content),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String> _loadPrivacyPolicy() async {
    try {
      return await rootBundle.loadString('POLITICA_DE_PRIVACIDAD.md');
    } catch (e) {
      // Si no se puede cargar desde assets, usar contenido embebido
      return _getEmbeddedContent();
    }
  }

  String _getEmbeddedContent() {
    return '''# Política de Privacidad - El Ventorrillo

**Última actualización:** [Fecha]

## 1. Introducción

El Ventorrillo ("nosotros", "nuestro" o "la Aplicación") se compromete a proteger su privacidad. Esta Política de Privacidad explica cómo recopilamos, usamos, divulgamos y protegemos su información personal cuando utiliza nuestra aplicación móvil.

Al utilizar El Ventorrillo, usted acepta las prácticas descritas en esta Política de Privacidad.

## 2. Información que Recopilamos

### 2.1 Información Proporcionada por Usted

Recopilamos información que usted nos proporciona directamente, incluyendo:

- **Información de Registro**: Nombre, dirección de correo electrónico, contraseña
- **Información de Perfil**: Nombre de usuario, foto de perfil, número de teléfono, ubicación (opcional)
- **Información de Productos**: Descripciones, imágenes, precios, categorías de productos que publica
- **Comunicaciones**: Mensajes enviados a través del sistema de chat de la Aplicación
- **Información de Transacciones**: Historial de compras y ventas (si se registra en la Aplicación)

### 2.2 Información Recopilada Automáticamente

Cuando utiliza la Aplicación, recopilamos automáticamente cierta información:

- **Información del Dispositivo**: Tipo de dispositivo, sistema operativo, identificadores únicos del dispositivo
- **Información de Uso**: Cómo interactúa con la Aplicación, páginas visitadas, funciones utilizadas, tiempo de uso
- **Información de Ubicación**: Ubicación geográfica (si otorga permisos de ubicación)
- **Información Técnica**: Dirección IP, tipo de navegador, proveedor de servicios de Internet
- **Cookies y Tecnologías Similares**: Utilizamos tecnologías de seguimiento para mejorar su experiencia

### 2.3 Información de Terceros

Podemos recibir información sobre usted de terceros, incluyendo:
- Proveedores de servicios de autenticación (como Google Sign-In)
- Servicios de análisis y publicidad
- Plataformas de redes sociales (si se conecta a través de ellas)

## 3. Cómo Utilizamos su Información

Utilizamos la información recopilada para:

### 3.1 Proporcionar y Mejorar el Servicio

- Crear y gestionar su cuenta de usuario
- Procesar sus publicaciones de productos
- Facilitar la comunicación entre usuarios
- Personalizar su experiencia en la Aplicación
- Mejorar y optimizar la funcionalidad de la Aplicación

### 3.2 Comunicación

- Enviarle notificaciones sobre transacciones, mensajes y actualizaciones
- Responder a sus consultas y solicitudes de soporte
- Enviarle información sobre cambios en nuestros términos o políticas (si es necesario)

### 3.3 Seguridad y Prevención de Fraudes

- Detectar y prevenir actividades fraudulentas
- Proteger la seguridad de la Aplicación y de nuestros usuarios
- Cumplir con obligaciones legales

### 3.4 Análisis y Desarrollo

- Analizar el uso de la Aplicación para mejorar nuestros servicios
- Realizar investigaciones y análisis de datos agregados y anónimos
- Desarrollar nuevas funcionalidades

## 4. Compartir su Información

### 4.1 Información Pública

Cierta información puede ser visible públicamente en la Aplicación:

- **Perfil de Usuario**: Nombre de usuario, foto de perfil (si la proporciona)
- **Publicaciones de Productos**: Descripciones, imágenes, precios, ubicación (si la proporciona)
- **Reseñas y Comentarios**: Cualquier reseña o comentario que publique

### 4.2 Compartir con Otros Usuarios

Compartimos información con otros usuarios cuando:

- Publica un producto (visible para todos los usuarios)
- Envía mensajes a través del sistema de chat (visible para el destinatario)
- Interactúa con otros usuarios en la plataforma

### 4.3 Proveedores de Servicios

Podemos compartir información con proveedores de servicios que nos ayudan a operar la Aplicación:

- **Firebase (Google)**: Para autenticación, almacenamiento de datos, hosting de imágenes y funciones en la nube
- **Servicios de Análisis**: Para entender cómo se utiliza la Aplicación
- **Servicios de Infraestructura**: Para alojamiento y mantenimiento técnico

Estos proveedores están obligados a proteger su información y solo pueden usarla para los fines especificados.

### 4.4 Cumplimiento Legal

Podemos divulgar su información si:

- Es requerido por ley, orden judicial o proceso legal
- Es necesario para proteger nuestros derechos, propiedad o seguridad
- Es necesario para proteger los derechos, propiedad o seguridad de nuestros usuarios
- Es necesario para prevenir fraude o investigar posibles violaciones

### 4.5 Transferencias Comerciales

En caso de una fusión, adquisición o venta de activos, su información puede ser transferida como parte de esa transacción.

## 5. Almacenamiento y Seguridad de Datos

### 5.1 Almacenamiento

Sus datos se almacenan utilizando servicios de Firebase (Google Cloud Platform), que pueden estar ubicados fuera de la República Dominicana. Al utilizar la Aplicación, usted consiente la transferencia de sus datos a estos servidores.

### 5.2 Seguridad

Implementamos medidas de seguridad técnicas y organizativas para proteger su información:

- Encriptación de datos en tránsito y en reposo
- Autenticación segura mediante Firebase Authentication
- Reglas de seguridad en Firestore y Storage
- Acceso restringido a información personal

Sin embargo, ningún método de transmisión por Internet o almacenamiento electrónico es 100% seguro. No podemos garantizar la seguridad absoluta de su información.

### 5.3 Retención de Datos

Conservamos su información mientras:

- Su cuenta esté activa
- Sea necesario para proporcionar nuestros servicios
- Sea necesario para cumplir con obligaciones legales
- Sea necesario para resolver disputas y hacer cumplir nuestros acuerdos

Puede solicitar la eliminación de su cuenta y datos en cualquier momento a través de la configuración de la Aplicación.

## 6. Sus Derechos y Opciones

### 6.1 Acceso y Corrección

Puede acceder y actualizar su información personal en cualquier momento a través de la configuración de su perfil en la Aplicación.

### 6.2 Eliminación de Cuenta

Puede eliminar su cuenta en cualquier momento. Al eliminar su cuenta:

- Su perfil y información personal se eliminarán
- Sus publicaciones de productos pueden eliminarse o permanecer anónimas
- Los mensajes en el chat pueden conservarse para fines de seguridad y cumplimiento legal

### 6.3 Permisos del Dispositivo

Puede controlar los permisos que otorga a la Aplicación a través de la configuración de su dispositivo:

- **Ubicación**: Puede desactivar el acceso a la ubicación en la configuración del dispositivo
- **Cámara/Galería**: Puede controlar el acceso a imágenes a través de la configuración del dispositivo
- **Notificaciones**: Puede desactivar las notificaciones push en la configuración del dispositivo

### 6.4 Opt-out de Comunicaciones

Puede optar por no recibir ciertas comunicaciones promocionales, aunque seguiremos enviándole comunicaciones esenciales relacionadas con su cuenta y transacciones.

## 7. Información de Menores

El Ventorrillo no está dirigido a menores de 18 años. No recopilamos intencionalmente información personal de menores de 18 años. Si descubrimos que hemos recopilado información de un menor sin el consentimiento de un padre o tutor, tomaremos medidas para eliminar esa información.

## 8. Cookies y Tecnologías de Seguimiento

Utilizamos cookies y tecnologías similares para:

- Recordar sus preferencias
- Analizar el uso de la Aplicación
- Mejorar la funcionalidad y experiencia del usuario

Puede controlar el uso de cookies a través de la configuración de su dispositivo o navegador.

## 9. Enlaces a Sitios de Terceros

La Aplicación puede contener enlaces a sitios web de terceros. No somos responsables de las prácticas de privacidad de estos sitios. Le recomendamos que revise las políticas de privacidad de cualquier sitio que visite.

## 10. Cambios a esta Política de Privacidad

Podemos actualizar esta Política de Privacidad ocasionalmente. Le notificaremos sobre cambios significativos:

- Publicando la nueva Política de Privacidad en la Aplicación
- Actualizando la fecha de "Última actualización"
- Enviándole una notificación (si es necesario según la ley aplicable)

Su uso continuado de la Aplicación después de los cambios constituye su aceptación de la Política de Privacidad revisada.

## 11. Transferencias Internacionales de Datos

Sus datos pueden ser transferidos y almacenados en servidores ubicados fuera de la República Dominicana, incluyendo servidores de Google Cloud Platform (Firebase) en diferentes países. Al utilizar la Aplicación, usted consiente estas transferencias.

## 12. Ley Aplicable

Esta Política de Privacidad se rige por las leyes de la República Dominicana. Cualquier disputa relacionada con esta política será resuelta de acuerdo con las leyes dominicanas.

## 13. Sus Derechos según la Ley Dominicana

Según la Ley No. 172-13 sobre Protección de Datos Personales de la República Dominicana, usted tiene derecho a:

- Acceder a sus datos personales
- Rectificar datos inexactos o incompletos
- Solicitar la eliminación de sus datos (derecho al olvido)
- Oponerse al procesamiento de sus datos
- Solicitar la portabilidad de sus datos

Para ejercer estos derechos, puede contactarnos a través de los medios indicados en la sección de Contacto.

## 14. Contacto

Si tiene preguntas, inquietudes o solicitudes relacionadas con esta Política de Privacidad o el manejo de sus datos personales, puede contactarnos:

- **Email**: [email de contacto]
- **Aplicación**: A través de la sección de ayuda o soporte en la Aplicación
- **Dirección**: [dirección física si aplica]

Nos comprometemos a responder a sus consultas en un plazo razonable.

## 15. Consentimiento

Al utilizar El Ventorrillo, usted reconoce que ha leído y entendido esta Política de Privacidad y consiente la recopilación, uso y divulgación de su información personal según se describe en esta política.

---

**Última actualización:** [Fecha]

**Versión:** 1.0''';
  }

  Widget _buildFormattedContent(BuildContext context, String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Título principal (#)
      if (line.startsWith('# ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text(
              line.substring(2).trim(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.amber,
                  ),
            ),
          ),
        );
      }
      // Subtítulos (##)
      else if (line.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 12),
            child: Text(
              line.substring(3).trim(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      }
      // Subtítulos menores (###)
      else if (line.startsWith('### ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              line.substring(4).trim(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );
      }
      // Lista con guión
      else if (line.trim().startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    line.trim().substring(2),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      // Texto en negrita (**texto**)
      else if (line.contains('**')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: _buildBoldText(context, line),
          ),
        );
      }
      // Separador (---)
      else if (line.trim() == '---') {
        widgets.add(
          const Divider(height: 32, thickness: 1),
        );
      }
      // Texto normal
      else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              line,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildBoldText(BuildContext context, String text) {
    final parts = text.split('**');
    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        spans.add(TextSpan(text: parts[i]));
      } else {
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: spans,
      ),
    );
  }
}

