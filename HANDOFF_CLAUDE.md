# Handoff del Proyecto Rivet (Para Claude / Antigravity)

Este documento contiene toda la información técnica, de contexto, arquitectura, assets y credenciales necesarias para continuar el desarrollo de la aplicación Flutter de **Rivet** de forma fluida y sin fricciones.

---

## 1. Visión General del Proyecto
**Rivet** es una plataforma móvil y web orientada a la remodelación y acabados arquitectónicos en Colombia (inicialmente Cali y alrededores). Conecta a propietarios de viviendas, contratistas/pintores independientes y ferreterías/proveedores de materiales, permitiendo:
- Medición y presupuestación paramétrica de áreas (paredes, techos, acabados).
- Protección de privacidad con IA (difuminado de personas y cuadros en fotos).
- Comparación estructurada de ofertas desglosando mano de obra vs. insumos.
- Pagos protegidos en depósito en garantía (Escrow) integrables con Wompi / PSE.
- Catálogo de insumos con tarifas profesionales (Pro-Rate) y órdenes de despacho.

---

## 2. Entorno y Estado del Repositorio
- **Directorio Raíz:** `c:\Users\joshe\Downloads\Apps\Rivet`
- **Rama Git Actual:** `feature/design-system-and-core-components`
- **Flutter SDK:** 3.44.8 / Dart 3.12.2
- **Estado de Calidad:**
  - `flutter analyze`: **0 issues found** (cero warnings, cero errores de tipado o deprecaciones).
  - `flutter test`: **All tests passed** (`test/widget_test.dart`).
  - **Límite de líneas:** Todos los archivos en `lib/` están modularizados y por debajo de las 300–450 líneas de código (respetando la regla de arquitectura limpia de 500 líneas).

---

## 3. Figma y Conexión MCP / REST

### Catálogo de Figma
- **File Key de Figma:** `43n3WC3GWNJZSPOCNRGzVT`
- **URL del Archivo:** `https://www.figma.com/design/43n3WC3GWNJZSPOCNRGzVT`
- **Total de Pantallas Diseñadas:** 45 pantallas oficiales (mapeadas como `P-001` a `P-047`).
- **Token de Acceso Personal (PAT) de Figma:**
  ```text
  figd_wBcIT_Szxmgl1NZQRLC8ww78NqY6iXNx-g9lp809
  ```

### Configuración del MCP Server de Figma
Si vas a configurar el MCP en Claude Desktop (`claude_desktop_config.json`) o en un entorno compatible con MCP:

> [!WARNING]
> **No uses la URL de transporte SSE directa `https://mcp.figma.com/mcp`** ya que el servidor de Figma requiere el protocolo Streamable HTTP (POST) y retorna HTTP 405 Method Not Allowed ante llamadas GET estándar.

**Opción A: Vía comando CLI / Node (Recomendada para Claude):**
```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-figma"],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "figd_wBcIT_Szxmgl1NZQRLC8ww78NqY6iXNx-g9lp809"
      }
    }
  }
}
```

**Opción B: Consumo directo por API REST (100% probado y funcional con curl/HTTP):**
- **Obtener estructura del archivo:**
  ```bash
  curl -H "X-Figma-Token: figd_wBcIT_Szxmgl1NZQRLC8ww78NqY6iXNx-g9lp809" "https://api.figma.com/v1/files/43n3WC3GWNJZSPOCNRGzVT"
  ```
- **Descargar nodos específicos como SVG o PNG:**
  ```bash
  curl -H "X-Figma-Token: figd_wBcIT_Szxmgl1NZQRLC8ww78NqY6iXNx-g9lp809" "https://api.figma.com/v1/images/43n3WC3GWNJZSPOCNRGzVT?ids=<NODE_ID>&format=png"
  ```

---

## 4. Banco de Imágenes y Assets (`Fondos/` y `Pantallas/`)

El proyecto cuenta con todas las imágenes oficiales exportadas directamente de Figma y declaradas en `pubspec.yaml`:

### Carpeta `Fondos/` (15 ilustraciones y fotografías oficiales)
Ubicación: `c:\Users\joshe\Downloads\Apps\Rivet\Fondos/`
- `Salón Minimalista en Verde y Crema.png` → Usado en **Bienvenida / Onboarding** (`WelcomeScreen`).
- `Sala minimalista con plantas y luz suave.png` → Usado en **Explorar Rivet / Home del Propietario** (`ClientHomeView`).
- `Rincón natural de pintura DIY.png` → Usado en **Detalle de Material** (`MaterialDetailScreen`).
- `Tienda minimalista entre plantas verdes.png` → Usado en **Bodega / Ferretería / Proveedores** (`MaterialsCatalogScreen`).
- `Checklist, plantas y cajas sostenibles.png` → Usado en **Mis Proyectos** (`MyProjectsScreen`).
- `Rodillo sobre pincelada verde.png` → Usado en **Perfil y Visita del Contratista** (`ContractorDetailScreen`, `ContractorVisitScreen`).
- `Burbuja de chat y campana entre hojas.png` → Para mensajería y notificaciones.
- `Escudo de privacidad junto a plantas.png` → Para el paso de IA y fotos privadas.
- `Escudo de confianza entre hojas verdes.png` → Para depósito en garantía y disputas.
- `Papeles y plantas sobre fondo crema.png` → Para cotizaciones y comparativas.

### Carpeta `Pantallas/` (Capturas de referencia del Figma)
Ubicación: `c:\Users\joshe\Downloads\Apps\Rivet\Pantallas/`
Contiene las capturas panorámicas de los flujos de Figma en alta resolución (`0-19.png`, `1-4.png`, `13-16.png`, `20-24.png`, etc.) para contrastar la fidelidad visual.

---

## 5. Arquitectura del Código y Sistema de Diseño

El código sigue un diseño atómico limpio y modular:

### 1. Sistema de Tokens (`lib/core/theme/`)
- [`app_colors.dart`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/theme/app_colors.dart):
  - `paper100` (`#F9F7F2`): Lienzo base marfil cálido de Figma.
  - `brand700` (`#0D544A`): Verde petróleo esmeralda profundo para botones primarios y encabezados.
  - `brandLight` (`#EAF5F0`): Verde salvia suave para píldoras y badges.
  - `surface0` (`#FFFFFF`): Blanco puro para tarjetas flotantes.
  - `softShadow` (`Color(0x0A0F2622)`): Sombra difusa sin bordes toscos.
- [`app_typography.dart`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/theme/app_typography.dart):
  - **Editorial Serif:** `GoogleFonts.newsreader()` para títulos de impacto (`display`, `heading`, `sectionTitle`).
  - **Sans Geométrica:** `GoogleFonts.plusJakartaSans()` para cuerpos de texto, números y navegación.
- [`app_spacing.dart`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/theme/app_spacing.dart): Escala de 4 a 48px y radios de 12 a 24px (`roundedPill`).

### 2. Componentes Reutilizables Centrales (`lib/core/widgets/`)
- [`RivetScaffold`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/rivet_scaffold.dart): Scaffold con corte orgánico biofílico en la esquina superior derecha (`_OrganicCornerClipper`), fundido con degradado suave hacia el marfil, cabecera editorial Serif y barra inferior fija para CTAs.
- [`AppCard`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_card.dart): Tarjetas flotantes blancas con radio de 18px y sombra difusa cálida.
- [`AppButton`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_button.dart): Botones en forma de píldora (`pill`), altura táctil de 52px con icono `chevron_right`.
- [`AppPriceBadge`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_price_badge.dart): Bloque de precio Figma con monto destacado, punto indicador `• Disponible` y stock.
- [`AppSpecRow`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_spec_row.dart): Fila técnica con icono outline, etiqueta, valor y flecha indicadora.
- [`AppSegmentedControl`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_segmented_control.dart), [`AppBadge`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_badge.dart), [`AppTextField`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_text_field.dart), [`AppStepProgress`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/core/widgets/app_step_progress.dart).

### 3. Navegación y Explorador 1-Click
- [`AppShell`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/features/home/app_shell.dart): Barra inferior de 5 pestañas (*Inicio, Proyectos, Propuestas, Mensajes, Más*) que conmuta automáticamente según el rol activo (`UserRole.client`, `contractor`, `supplier`).
- [`ScreenExplorerScreen`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/features/explorer/screen_explorer_screen.dart): Catálogo maestro accesible desde el botón flotante en el Shell para saltar a **cualquiera de las 45 pantallas** de forma inmediata con datos simulados realistas.

---

## 6. Cómo Ejecutar el Proyecto
- **En Google Chrome (Navegador):**
  ```powershell
  flutter run -d chrome
  ```
- **En el Emulador Android:**
  El emulador local `Moto` ya está creado y configurado. Para levantarlo:
  ```powershell
  flutter run -d android
  ```
- **Verificar Calidad y Tests:**
  ```powershell
  flutter analyze
  flutter test
  ```

---

## 7. Próximos Pasos Recomendados para Claude
1. **Extender el uso de `RivetScaffold` y la silueta biofílica** a las pantallas de flujos más profundos (Creación de cotización de 4 pasos, comparador de propuestas, comprobantes de pago y módulo de arbitraje).
2. **Conectar persistencia / estado global** (Provider / Riverpod / Bloc) si se desea que los datos creados por el cliente se reflejen inmediatamente en la vista del contratista y del proveedor.
3. **Integración de Pasarela Real** (Wompi Widget / API Checkout) en [`project_payment_screen.dart`](file:///c:/Users/joshe/Downloads/Apps/Rivet/lib/features/payments/project_payment_screen.dart).
