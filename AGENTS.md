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
- [ ] **Corregir scroll con efecto raro**: Normalizar el `ScrollPhysics` (usar `BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())` o estándar de plataforma) evitando saltos y overscroll deformado en Android/iOS.
- [ ] **Corregir y pulir inputs**:
  - Validar alturas, padding interno, bordes de enfoque (`focusedBorder`), cursor tint y contraste de placeholders.
  - Asegurar que al abrir el teclado el viewport use `SingleChildScrollView` con padding para evitar errores de `Bottom overflowed by XX pixels`.
- [ ] **Quitar selector de 3 usuarios**: Retirar definitivamente la vista previa de 3 roles (`RoleSelectionScreen` con proveedor); solo existen **Cliente** y **Contratista**.
- [ ] **Transiciones y animaciones de pantalla**: Implementar transiciones suaves y fluidas (`PageRouteBuilder` con fade/slide sutil) al navegar entre bienvenida, auth y home.
- [ ] **Simplificar pantallas cargadas**: Reducir densidad cognitiva dividiendo formularios largos en pasos o resúmenes colapsables.
- [ ] **Flujo intuitivo y honestidad visual**: Todo elemento interactivo debe responder con feedback visual (splash/hover) y todo elemento estático debe ser claramente informativo; nada debe parecer un botón si no lo es.

### ⚙️ Tareas Funcionales y de Seguridad
- [ ] **Conexión oficial con Supabase**:
  - Integrar `supabase_flutter` con variables de entorno seguras (`.env`).
  - Inicializar cliente en `main.dart`.
- [ ] **Lógica de autenticación completa**:
  - Registro con rol asignado (`client` o `contractor`) en la tabla `profiles`.
  - Inicio de sesión con correo y contraseña.
  - Recuperación de contraseña mediante correo transaccional.
- [ ] **Reglas de validación estrictas**:
  - **Correo electrónico**: Expresión regular RFC 5322 estándar.
  - **Contraseña segura**: Mínimo 8 caracteres, al menos una mayúscula, un número y un carácter especial.
  - **Número de celular**: Formato nacional estándar (10 dígitos en Colombia).
- [ ] **Seguridad contra SQL Injection**: Uso exclusivo del Query Builder parametrizado de Supabase y validación previa en los modelos Dart.
