import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: FutureBuilder<String>(
        future: _loadTermsAndConditions(),
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

  Future<String> _loadTermsAndConditions() async {
    try {
      return await rootBundle.loadString('TERMINOS_Y_CONDICIONES.md');
    } catch (e) {
      // Si no se puede cargar desde assets, usar contenido embebido
      return _getEmbeddedContent();
    }
  }

  String _getEmbeddedContent() {
    return '''# Términos y Condiciones de Uso - El Ventorrillo

**Última actualización:** [Fecha]

## 1. Aceptación de los Términos

Al acceder y utilizar la aplicación móvil "El Ventorrillo" (en adelante, "la Aplicación" o "el Servicio"), usted acepta estar sujeto a estos Términos y Condiciones de Uso. Si no está de acuerdo con alguna parte de estos términos, no debe utilizar la Aplicación.

## 2. Descripción del Servicio

El Ventorrillo es una plataforma digital de marketplace que permite a los usuarios:

- **"Lo Nuestro"**: Publicar y adquirir productos artesanales, hechos a mano y culturales locales
- **"El Reguero"**: Publicar y adquirir artículos de segunda mano

La Aplicación facilita la conexión entre compradores y vendedores, pero no participa directamente en las transacciones comerciales entre usuarios.

## 3. Registro y Cuenta de Usuario

### 3.1 Requisitos de Registro

Para utilizar la Aplicación, debe:
- Ser mayor de 18 años o tener el consentimiento de un padre o tutor legal
- Proporcionar información veraz, precisa y completa
- Mantener la seguridad de su cuenta y contraseña
- Notificar inmediatamente cualquier uso no autorizado de su cuenta

### 3.2 Responsabilidad de la Cuenta

Usted es responsable de:
- Todas las actividades que ocurran bajo su cuenta
- Mantener la confidencialidad de sus credenciales de acceso
- Cualquier daño o pérdida resultante del uso no autorizado de su cuenta

## 4. Uso de la Aplicación

### 4.1 Uso Permitido

Puede utilizar la Aplicación para:
- Publicar productos legítimos para la venta
- Buscar y adquirir productos publicados por otros usuarios
- Comunicarse con otros usuarios a través del sistema de chat integrado
- Compartir contenido relacionado con productos y servicios

### 4.2 Uso Prohibido

Está prohibido:
- Publicar productos ilegales, falsificados, robados o que infrinjan derechos de propiedad intelectual
- Publicar contenido ofensivo, discriminatorio, difamatorio o que viole derechos de terceros
- Utilizar la Aplicación para actividades fraudulentas o engañosas
- Interferir con el funcionamiento de la Aplicación o intentar acceder a sistemas no autorizados
- Publicar información personal de terceros sin su consentimiento
- Utilizar la Aplicación para spam, publicidad no autorizada o actividades comerciales no permitidas
- Vender productos prohibidos por la ley dominicana o internacional
- Manipular precios, crear cuentas falsas o realizar cualquier actividad que perjudique la integridad del marketplace

## 5. Publicación de Productos

### 5.1 Responsabilidad del Vendedor

Al publicar un producto, usted garantiza que:
- Es el propietario legítimo del producto o tiene autorización para venderlo
- La descripción del producto es precisa y veraz
- Las imágenes publicadas corresponden al producto real
- El producto cumple con todas las leyes y regulaciones aplicables
- El producto no está prohibido por estos términos

### 5.2 Contenido de las Publicaciones

Las publicaciones deben incluir:
- Descripción clara y precisa del producto
- Precio justo y razonable
- Imágenes reales del producto
- Estado del producto (nuevo, usado, etc.)
- Ubicación (si aplica)

### 5.3 Modificación y Eliminación

El Ventorrillo se reserva el derecho de:
- Revisar, modificar o eliminar cualquier publicación que viole estos términos
- Suspender o cancelar cuentas que infrinjan las políticas
- Rechazar o eliminar contenido sin previo aviso

## 6. Transacciones entre Usuarios

### 6.1 Relación entre Comprador y Vendedor

El Ventorrillo actúa únicamente como plataforma de conexión. No somos parte de ninguna transacción entre usuarios y no garantizamos:
- La calidad, seguridad o legalidad de los productos
- La veracidad de las descripciones de los productos
- La capacidad de los usuarios para completar una transacción
- Que los usuarios completarán una transacción

### 6.2 Responsabilidad de las Transacciones

Los usuarios son responsables de:
- Negociar los términos de la transacción (precio, método de pago, entrega, etc.)
- Verificar la identidad y credenciales del otro usuario
- Realizar los pagos de forma segura
- Resolver cualquier disputa directamente con el otro usuario

### 6.3 Métodos de Pago

El Ventorrillo no procesa pagos directamente. Los usuarios deben acordar métodos de pago seguros entre ellos. Recomendamos:
- Utilizar métodos de pago seguros y rastreables
- Evitar transferencias a cuentas desconocidas
- Verificar la identidad del comprador/vendedor antes de completar la transacción

## 7. Sistema de Chat

### 7.1 Uso del Chat

El sistema de chat está diseñado para:
- Comunicarse sobre productos y transacciones
- Negociar términos de compra/venta
- Coordinar entregas y pagos

### 7.2 Conducta en el Chat

Está prohibido:
- Enviar mensajes ofensivos, amenazantes o acosadores
- Compartir información personal no autorizada
- Utilizar el chat para spam o publicidad no solicitada
- Intentar eludir restricciones de comunicación

## 8. Propiedad Intelectual

### 8.1 Contenido del Usuario

Al publicar contenido en la Aplicación, usted:
- Retiene la propiedad de su contenido
- Otorga a El Ventorrillo una licencia no exclusiva, mundial, libre de regalías para usar, mostrar y distribuir su contenido en la Aplicación
- Garantiza que tiene todos los derechos necesarios sobre el contenido publicado

### 8.2 Propiedad de El Ventorrillo

Todos los derechos de propiedad intelectual sobre la Aplicación, incluyendo diseño, código, logotipos y marcas, pertenecen a El Ventorrillo o sus licenciantes.

## 9. Privacidad

El uso de la Aplicación también está sujeto a nuestra Política de Privacidad, que describe cómo recopilamos, usamos y protegemos su información personal. Al utilizar la Aplicación, usted acepta las prácticas descritas en la Política de Privacidad.

## 10. Limitación de Responsabilidad

### 10.1 Exención de Garantías

La Aplicación se proporciona "tal cual" y "según disponibilidad". No garantizamos que:
- La Aplicación esté libre de errores o interrupciones
- Los resultados obtenidos sean precisos o confiables
- Los productos publicados cumplan con las descripciones

### 10.2 Limitación de Daños

En la máxima medida permitida por la ley, El Ventorrillo no será responsable de:
- Daños directos, indirectos, incidentales o consecuentes
- Pérdida de beneficios, datos o uso
- Daños resultantes de transacciones entre usuarios
- Problemas técnicos o interrupciones del servicio

## 11. Indemnización

Usted acepta indemnizar y eximir de responsabilidad a El Ventorrillo, sus afiliados, directores, empleados y agentes de cualquier reclamo, daño, obligación, pérdida, responsabilidad, costo o deuda, y gastos (incluyendo honorarios de abogados) que surjan de:
- Su uso de la Aplicación
- Su violación de estos Términos
- Su violación de cualquier derecho de terceros
- Contenido que publique en la Aplicación

## 12. Modificaciones de los Términos

Nos reservamos el derecho de modificar estos Términos en cualquier momento. Las modificaciones entrarán en vigor cuando se publiquen en la Aplicación. Su uso continuado de la Aplicación después de las modificaciones constituye su aceptación de los nuevos términos.

## 13. Suspensión y Terminación

### 13.1 Terminación por el Usuario

Puede cerrar su cuenta en cualquier momento a través de la configuración de la Aplicación.

### 13.2 Terminación por El Ventorrillo

Podemos suspender o terminar su acceso a la Aplicación inmediatamente, sin previo aviso, si:
- Viola estos Términos y Condiciones
- Realiza actividades fraudulentas o ilegales
- Crea riesgo o exposición legal para El Ventorrillo
- Infringe los derechos de otros usuarios

## 14. Ley Aplicable y Jurisdicción

Estos Términos se rigen por las leyes de la República Dominicana. Cualquier disputa relacionada con estos términos o la Aplicación será resuelta en los tribunales competentes de la República Dominicana.

## 15. Disposiciones Generales

### 15.1 Divisibilidad

Si alguna disposición de estos Términos se considera inválida o inaplicable, las disposiciones restantes permanecerán en pleno vigor y efecto.

### 15.2 Renuncia

El hecho de que El Ventorrillo no ejerza o haga valer cualquier derecho o disposición de estos Términos no constituirá una renuncia a tal derecho o disposición.

### 15.3 Acuerdo Completo

Estos Términos constituyen el acuerdo completo entre usted y El Ventorrillo respecto al uso de la Aplicación.

## 16. Contacto

Si tiene preguntas sobre estos Términos y Condiciones, puede contactarnos a través de:
- Email: [email de contacto]
- Aplicación: A través de la sección de ayuda o soporte

---

**Al utilizar El Ventorrillo, usted reconoce que ha leído, entendido y acepta estar sujeto a estos Términos y Condiciones de Uso.**''';
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

