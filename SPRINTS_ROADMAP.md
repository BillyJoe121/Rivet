# Rivet — Plan de Sprints y Hoja de Ruta

Documento oficial de planificación para el desarrollo de **Rivet**. Define el calendario de 3 sprints, las decisiones arquitectónicas acordadas, el inventario de pantallas podadas y la estrategia de implementación con Supabase y Flutter.

---

## 1. Calendario de Sprints y Entregas

| Sprint | Fechas | Duración | Foco Principal | Entregable Clave |
|---|---|---|---|---|
| **Sprint 1** | **20 Oct – 27 Oct 2026** | 1 semana | Autenticación, Roles y Reorganización del Design System | App con Login, Registro, Recuperación, Perfiles en Supabase y carpeta `design_system/` modularizada. |
| **Sprint 2** | **28 Oct – 10 Nov 2026** | 2 semanas | Núcleo de Proyectos, Propuestas y Catálogo Rivet | Flujo completo: Publicar proyecto $\rightarrow$ Cotizar $\rightarrow$ Elegir materiales de Rivet $\rightarrow$ Aceptar propuesta. |
| **Sprint 3** | **11 Nov – 24 Nov 2026** | 2 semanas | Ejecución, Chat, Pagos y Cierre de Obra | Chat en tiempo real, seguimiento de hitos, simulación/pasarela de pago, QA final y demo lista. |

---

## 2. Decisiones Arquitectónicas y Reglas del Proyecto

1. **Rivet como Proveedor Único (Sin rol ni flujo de Terceros Proveedores)**:
   - Se elimina la figura del "Proveedor externo" como usuario de la app.
   - La plataforma **Rivet asume la venta y distribución directa de materiales garantizados** ("Bodega Rivet").
   - Clientes y contratistas eligen materiales directamente del catálogo oficial de Rivet.
   - *Impacto positivo*: Se eliminan ~10 pantallas complejas (registro de ferreterías, validación de inventarios ajenos, convenios de tarifas pro y logística de despachos cruzados).

2. **Lógica de Negocio Principal en Flutter (Dart)**:
   - Toda la lógica de cálculo (presupuestos, totales de obra, validaciones de formularios, navegación y estados) reside en el código de Flutter (servicios, modelos y repositorios locales).
   - **Supabase Edge Functions** se reservan **estrictamente para casos excepcionales**:
     - Webhooks de pasarelas de pago externas (ej. Wompi/Stripe).
     - Procesos que exijan secretos de servidor no exponibles en el cliente móvil.

3. **Estructura Modular del Sistema de Diseño (Sprint 1)**:
   - Consolidar todos los tokens y los 13 componentes atómicos bajo un namespace claro: `lib/core/design_system/` (o export centralizado).
   - Ninguna pantalla usará estilos `inline` no tipificados; todos consumirán los tokens validados de Figma (Roboto, Lora, radios, colores y elevaciones).

4. **Base de Datos y Seguridad**:
   - Backend en **Supabase** (PostgreSQL).
   - Seguridad mediante **Row Level Security (RLS)** para aislar datos entre clientes y contratistas.
   - **Supabase Storage** para fotos de proyectos, evidencias y recibos.

---

## 3. Plan Detallado por Sprint

### Sprint 1: Autenticación, Perfiles y Design System (20 Oct – 27 Oct)
- **Estructuración del Design System**:
  - Reorganizar `lib/core/theme/` y `lib/core/widgets/` en una arquitectura de `design_system/` limpia, exportable y documentada.
- **Configuración de Supabase**:
  - Creación del proyecto Supabase y scripts de migración (`profiles`, triggers de creación de usuario en `auth.users`).
  - Configuración del cliente `supabase_flutter` con variables seguras.
- **Pantallas y Flujos de Auth**:
  - [WelcomeScreen](file:///lib/features/onboarding/welcome_screen.dart): Bienvenida editorial.
  - [RoleSelectionScreen](file:///lib/features/onboarding/role_selection_screen.dart): Elección de perfil (Cliente o Contratista profesional).
  - [LoginScreen](file:///lib/features/auth/login_screen.dart): Inicio de sesión con correo/contraseña y validación de errores.
  - [SignupScreen](file:///lib/features/auth/signup_screen.dart): Registro con datos básicos y asignación de rol en `profiles`.
  - [ForgotPasswordScreen](file:///lib/features/auth/forgot_password_screen.dart): Recuperación por correo con enlace seguro.
  - [ProfileScreen](file:///lib/features/account/profile_screen.dart): Visualización y edición del perfil activo.

---

### Sprint 2: Proyectos, Propuestas y Catálogo Rivet (28 Oct – 10 Nov)
- **Flujo de Cliente**:
  - [CreateProjectScreen](file:///lib/features/projects/create_project_screen.dart): Formulario simplificado (título, descripción, presupuesto estimado, ubicación y fotos).
  - [MyProjectsScreen](file:///lib/features/projects/my_projects_screen.dart): Listado de proyectos en borrador, cotización o en marcha.
  - [ProjectDetailScreen](file:///lib/features/projects/project_detail_screen.dart): Ficha completa del proyecto para cliente y postulantes.
- **Flujo de Contratista**:
  - [ContractorHomeView](file:///lib/features/home/): Feed de proyectos disponibles en su área.
  - [CreateProposalScreen](file:///lib/features/proposals/create_proposal_screen.dart): Creación de cotización (mano de obra + desglose de materiales).
- **Catálogo Oficial de Materiales (Bodega Rivet)**:
  - [MaterialsCatalogScreen](file:///lib/features/supplier/materials_catalog_screen.dart): Búsqueda y filtrado de materiales oficiales Rivet.
  - [MaterialDetailScreen](file:///lib/features/supplier/material_detail_screen.dart): Ficha técnica y precio unitario.
- **Cierre del Acuerdo**:
  - [ProposalDetailScreen](file:///lib/features/proposals/proposal_detail_screen.dart): El cliente revisa la cotización y la acepta formalmente.

---

### Sprint 3: Ejecución, Pagos, Chat y Cierre (11 Nov – 24 Nov)
- **Seguimiento de Obra**:
  - [WorkProgressScreen](file:///lib/features/execution/work_progress_screen.dart): Bitácora de avance con checklist mutuo de entrega.
- **Comunicación en Tiempo Real**:
  - `ChatScreen` unificado (reemplaza chats duplicados): Chat directo entre cliente y contratista sobre el proyecto mediante Supabase Realtime.
  - [NotificationsScreen](file:///lib/features/messaging/notifications_screen.dart): Avisos de estado de cotizaciones y mensajes.
- **Pagos y Finanzas**:
  - [ProjectPaymentScreen](file:///lib/features/payments/project_payment_screen.dart): Pago de anticipo/garantía (simulación de prueba o pasarela).
  - [PayoutAccountScreen](file:///lib/features/finance/payout_account_screen.dart): Configuración de cuenta bancaria del contratista para desembolsos.
- **Finalización de Obra y Calificación**:
  - [JobClosureScreen](file:///lib/features/account/job_closure_screen.dart): Cierre de proyecto, liberación de pago y calificación mutua.
  - [CancellationRefundScreen](file:///lib/features/disputes/cancellation_refund_screen.dart): Flujo de cancelación controlada si la obra no inicia.

---

## 4. Auditoría y Propuesta de Poda de Pantallas

De las **45 pantallas iniciales**, proponemos **eliminar o consolidar 22 pantallas secundarias**, dejando una aplicación sólida y ágil de **~23 pantallas nucleares**.

### A. Pantallas Eliminadas por la Supresión del Rol Proveedor (9 pantallas)
Dado que Rivet es el proveedor único directo, no se requiere lógica multi-proveedor:
1. `add_catalog_product_screen.dart` $\rightarrow$ No aplica (los productos los carga la plataforma internamente).
2. `manage_catalog_screen.dart` $\rightarrow$ No aplica (gestión administrativa interna).
3. `choose_supplier_screen.dart` $\rightarrow$ No aplica (solo existe Rivet).
4. `link_supplier_screen.dart` $\rightarrow$ No aplica (no hay códigos de vinculación de ferreterías).
5. `prepare_dispatch_screen.dart` $\rightarrow$ No aplica (gestión de bodega interna).
6. `pro_rate_authorization_screen.dart` $\rightarrow$ No aplica (no hay convenios privados B2B).
7. `supplier_orders_screen.dart` $\rightarrow$ No aplica (bandeja para terceros proveedores).
8. `supplier_products_screen.dart` $\rightarrow$ No aplica.
9. `supplier_profile_screen.dart` $\rightarrow$ No aplica.

### B. Pantallas de Administración Interna y Galerías (6 pantallas)
No forman parte de la experiencia móvil del usuario final:
10. `admin_dashboard_screen.dart` $\rightarrow$ Fuera del alcance móvil de cliente/contratista.
11. `admin_dispute_resolution_screen.dart` $\rightarrow$ Fuera del alcance móvil.
12. `component_gallery_screen.dart` $\rightarrow$ Herramienta de desarrollo, no usuario.
13. `list_gallery_screen.dart` $\rightarrow$ Herramienta de desarrollo.
14. `modal_gallery_screen.dart` $\rightarrow$ Herramienta de desarrollo.
15. `screen_explorer_screen.dart` $\rightarrow$ Herramienta de desarrollo.

### C. Pantallas Duplicadas o Fusionables (7 pantallas)
Reducen pasos innecesarios fusionándose en las pantallas principales:
16. `negotiation_chat_screen.dart` $\rightarrow$ Fusionar con `ProposalChatScreen` en un único `ProjectChatScreen`.
17. `contractor_visit_screen.dart` $\rightarrow$ La visita previa se coordina de forma nativa por el chat de propuesta sin pantalla dedicada.
18. `proposals_compare_screen.dart` $\rightarrow$ La comparación de 2 propuestas se realiza directamente en la lista de propuestas del proyecto con tarjetas lado a lado.
19. `payment_receipt_screen.dart` $\rightarrow$ Se muestra como un modal/bottom-sheet de confirmación tras el pago sin navegar a una pantalla completa.
20. `payment_received_screen.dart` $\rightarrow$ Notificación en la lista de transacciones sin vista estática dedicada.
21. `create_incident_screen.dart` e `incident_detail_screen.dart` $\rightarrow$ Se unifican en el flujo de `CancellationRefundScreen` para no crear un sistema de tickets complejo en el MVP.
