# Rivet — Instrucciones y Tareas de Desarrollo

## Contexto del Proyecto
Rivet es una plataforma móvil en Flutter (Dart) que conecta a propietarios de obras/remodelaciones con contratistas profesionales calificados, respaldados con materiales suministrados directamente por la Bodega Oficial Rivet.

## Arquitectura y Principios
- **Lógica de negocio**: Centralizada en código cliente Flutter (Dart) mediante servicios y repositorios limpios.
- **Backend & Base de datos**: Supabase (PostgreSQL, Auth, Storage, Row Level Security).
- **Seguridad**: Prevención estricta de inyecciones SQL mediante consultas parametrizadas del SDK oficial de Supabase y políticas RLS obligatorias.
- **Design System**: Estilos medidos en Figma bajo `lib/core/design_system/`. Ningún estilo visual hardcodeado en las vistas.

---

## Backlog de Tareas — Sprint 1 (20 Oct – 27 Oct)

### 🎨 Tareas de Estilo y UX
- [x] **Corregir scroll con efecto raro**: Normalizado con `RivetScrollBehavior` (`BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())`) aplicado globalmente en `MaterialApp`.
- [x] **Corregir y pulir inputs**:
  - Validado en `AppTextField`: contraste WCAG, bordes de enfoque (`focusedBorder`), cursor tint de marca (`brand700`), cursor de 2.0px.
  - Viewport seguro en `LoginScreen` y `SignupScreen` con `SingleChildScrollView` y padding `bottomInset` que previene desbordamientos de teclado (`Bottom overflowed by XX pixels`).
  - Corregido desbordamiento de 19px en `LoginTabs` mediante `IntrinsicWidth`.
- [x] **Quitar selector de 3 usuarios**: Retirado el rol de proveedor en `RoleSelectionScreen`, `AccountTypeSelector` y `account_role_sheet.dart`; solo existen **Cliente** y **Contratista**.
- [x] **Transiciones y animaciones de pantalla**: Implementado `RivetPageRoute` y `AppNavigator` con transición suave combinada de `Fade` y `Slide` (curva `Curves.easeOutCubic`) entre bienvenida, selección de rol, auth y home.
- [x] **Simplificar pantallas cargadas**: Estructura de formularios limpia y espaciada con tarjetas modulares y pasos claros.
- [x] **Flujo intuitivo y honestidad visual**: `InkWell` y `Material` interactivo con splash/highlight en botones y tarjetas de rol; estado de carga `isLoading` en `AuthGradientButton`.

### ⚙️ Tareas Funcionales y de Seguridad
- [x] **Conexión oficial con Supabase**:
  - Integrado `supabase_flutter` y `flutter_dotenv` con credenciales seguras en `.env` (ignorado en `.gitignore`).
  - Inicializado en `main.dart` con `SupabaseConfig.initialize()`.
  - Script de base de datos generado en `supabase/schema_sprint1.sql` con tabla `profiles`, trigger de `auth.users` y políticas RLS.
- [x] **Lógica de autenticación completa**:
  - Registro con rol asignado (`client` o `contractor`) en la tabla `profiles`.
  - Inicio de sesión con correo y contraseña conectando a Supabase Auth.
  - Recuperación de contraseña mediante correo transaccional en `ForgotPasswordScreen`.
  - Arquitectura limpia desacoplada: `RivetUser`, `AuthRepository`, `SupabaseAuthDataSource` y `AuthService`.
- [x] **Reglas de validación estrictas**:
  - **Correo electrónico**: Expresión regular RFC 5322 estándar en `Validators.email`.
  - **Contraseña segura**: Mínimo 8 caracteres, al menos una mayúscula, un número y un carácter especial en `Validators.password`.
  - **Número de celular**: Formato nacional estándar (10 dígitos en Colombia iniciando en 3) en `Validators.phone`.
- [x] **Seguridad contra SQL Injection**: Uso exclusivo del Query Builder parametrizado de Supabase (`.from('profiles').select().eq(...)`) y modelos fuertemente tipados.
