# 🚀 Handoff del Proyecto Rivet (Flutter + Figma)

**Fecha:** 19 de Octubre de 2026  
**Raíz del proyecto:** `c:\Users\joshe\Downloads\Apps\Rivet`  
**Framework:** Flutter 3.44.8 · Dart 3.12.2  
**Diseño Figma:** [Rivet-v2 en Figma](https://www.figma.com/design/43n3WC3GWNJZSPOCNRGzVT/Rivet-v2?node-id=0-1&m=dev)  
**Figma File Key:** `43n3WC3GWNJZSPOCNRGzVT`  
**Estado:** Proyecto Flutter inicializado, assets y documentación unificada, listo para maquetación modular.

---

## 1. Contexto del Producto
**Rivet** es una aplicación móvil diseñada para cotizar, gestionar y comparar trabajos de pintura y estuco en Colombia, conectando de forma transparente a:
1. **Clientes** (describen espacios con fotos/medidas y eligen contratistas).
2. **Contratistas** (postulan ofertas separando mano de obra de materiales).
3. **Proveedores / Bodegas** (suministro y despacho de materiales).

---

## 2. Lo que ya está hecho ✅

1. **Estructura y Proyecto Flutter:**
   - Proyecto inicializado exitosamente en la raíz `Rivet/` con `flutter create --project-name rivet .`.
   - Se configuró `.gitignore` para proteger variables de entorno y archivos `.env`.
   - Soporte multiplataforma configurado (`android/`, `ios/`, `web/`, `windows/`).

2. **Assets y Documentación centralizados en `Rivet/`:**
   - `docs/`:
     - `01-pitch.md`: Propuesta de valor y presentación breve.
     - `02-requisitos-funcionales.md`: Catálogo completo de requerimientos funcionales.
     - `03-pantallas-y-trazabilidad.md`: Mapeo exacto de las **45 pantallas** del prototipo.
     - `04-identidad-de-marca.md`: Paleta de colores base, tipografía y estilo visual.
   - `Pantallas/`: 11 láminas PNG de alta resolución con las 45 pantallas del prototipo clasificadas.
   - `Fondos/`: 15 ilustraciones y fondos de escena listos para usar en la app.

3. **Conexión con Figma:**
   - Cuenta de Figma: Plan Estudiante / Pro activo.
   - Dev Mode activo configurado en **CSS / px**.
   - Token de Acceso Personal (PAT) probado y autenticado con éxito contra la API de Figma (`/v1/me` -> 200 OK):
     - Usuario: `Second (PMO Maestría)` (`1113978987@u.icesi.edu.co`).
     - Token disponible en la sesión: `figd_wBcIT_Szxmgl1NZQRLC8ww78NqY6iXNx-g9lp809`.
   - Configuración de agente global actualizada en `~/.gemini/config/mcp_config.json` con endpoint `https://mcp.figma.com/mcp`.

---

## 3. Flujos de Pantallas Mapeados en Figma
Según la inspección de Dev Mode en Figma, los flujos clave a maquetar son:
1. **Inicio como cualquier usuario** (Onboarding, Welcome, Selección de rol/Home general).
2. **Postulación a un proyecto como contratista**
3. **Vista de Bodega como cliente/contratista**
4. **Gestión de proveedor**
5. **Mi perfil Contratista**
6. **Creación de proyecto**
7. **Escoger un contratista**
8. **Gestionar mi proyecto como cliente**

---

## 4. Reglas de Calidad y Arquitectura (Forge)
1. **Atomic & Tokens First:**
   - Prohibido quemar colores (`0xFF...`), fuentes o márgenes fijos dentro de las pantallas.
   - Todo debe originarse en `lib/core/theme/` (`app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_theme.dart`).
2. **Modularidad Estricta:**
   - Límite de **500 líneas** por archivo físico.
   - Las pantallas no deben contener widgets complejos inline; se extraen a `widgets/` como componentes reutilizables.
3. **Estructura de Directorios:**
   ```text
   lib/
   ├── core/
   │   ├── theme/          # AppColors, AppTypography, AppTheme
   │   ├── widgets/        # Botones, inputs, badges, cards globales
   │   └── utils/
   ├── features/
   │   ├── onboarding/     # Screens y widgets de bienvenida
   │   ├── projects/       # Creación y gestión de proyectos
   │   ├── contractors/    # Perfiles y ofertas
   │   └── supplier/       # Catálogo y bodega
   └── main.dart
   ```

---

## 5. Visualizador / Emulador en PC
- Android Studio y su SDK están instalados en `C:\Users\joshe\AppData\Local\Android\Sdk`.
- Opciones para visualizar y correr:
  1. **Emulador Android (AVD):** Abrir Android Studio -> *Virtual Device Manager* -> Iniciar emulador (o crearlo si no existe).
  2. **Dispositivo Físico:** Conectar móvil Android por cable USB con *Depuración USB* activada (comprobable con `adb devices`).
  3. **Windows Desktop / Chrome:** Para iteración visual ultra rápida durante el desarrollo de widgets, se puede correr directamente con `flutter run -d windows` o `flutter run -d chrome`.

---

## 6. Próximos Pasos para el Nuevo Chat (Inicio Inmediato)
Al iniciar la nueva sesión en la carpeta `Rivet`:
1. **Paso 1:** Inspeccionar los estilos del Figma (`43n3WC3GWNJZSPOCNRGzVT`) y crear la base de diseño:
   - `lib/core/theme/app_colors.dart`
   - `lib/core/theme/app_typography.dart`
   - `lib/core/theme/app_theme.dart`
2. **Paso 2:** Construir los componentes atómicos clave reutilizables (`AppButton`, `AppTextField`, `CustomAppBar`).
3. **Paso 3:** Ensamblar la primera pantalla del flujo **"Inicio como cualquier usuario"** con datos mock y verificar la fidelidad visual con el Figma.
