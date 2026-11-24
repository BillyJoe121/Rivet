# Guía de uso y evaluación — Rivet

Guía rápida para explorar la aplicación con la cuenta de evaluación de doble rol (**Contratista** y **Cliente**) y recorrer en **5 minutos** los flujos completos implementados con **Clean Architecture**, **BLoC**, **GetIt** y **Supabase + Realtime**.

---

## 1. Preparación de la cuenta del profesor en Supabase

1. Asegúrate de haber ejecutado los scripts de esquema en orden (ver [`supabase/README.md`](../supabase/README.md)):
   1. `schema_sprint1.sql`
   2. `schema_sprint3_tables.sql`
   3. `schema_sprint3_functions.sql`
   4. `schema_sprint3_rls.sql`
   5. `schema_sprint3_storage_realtime.sql`
2. Crea el usuario del profesor en **Supabase Auth** (`Authentication → Users → Add user`) o regístralo desde la pantalla de registro de la app (correo y contraseña de prueba a tu elección).
3. Abre [`supabase/seed_professor_demo.sql`](../supabase/seed_professor_demo.sql), ajusta las dos variables iniciales (`v_prof_email` y `v_prof_name`) con el correo y nombre registrados, y ejecútalo en el **SQL Editor**.
   - El script es **idempotente** y usa UUIDs propios, por lo que no altera los datos de otros usuarios.

---

## 2. Cómo moverse entre ambos roles (Contratista ↔ Cliente)

La sesión inicia en el rol configurado en el perfil (`contractor`), desde donde el profesor puede recorrer toda la vista profesional y también alternar a la vista de cliente:

1. En la barra inferior, toca **Más → Mi perfil**.
2. En la tarjeta superior del perfil, **toca el avatar circular con iniciales**.
3. En la hoja **Cambiar rol activo**, selecciona **Cliente propietario** o **Contratista profesional**.

> **Nota sobre seguridad (RLS):** el cambio de rol en la app cambia la vista y navegación de la sesión local manteniendo intactas las políticas RLS de Supabase sobre `profiles.role`. Los datos sembrados están asociados al `auth.uid()` del usuario en ambas vistas (proyectos creados por él, proyectos abiertos de otros clientes, propuestas, acuerdos, hitos, mensajes enviados/recibidos y notificaciones).

---

## 3. Recorrido sugerido (sustentación de 5 minutos)

### Parte A · Rol Contratista (inicio por defecto)
1. **Inicio Contratista** (`ContractorHomeView`): muestra proyecto destacado abierto, obra activa en curso y resumen de actividad reciente.
2. **Proyectos → Oportunidades** (`OpenProjectsScreen`): lista de proyectos publicados por clientes externos (Laura Gómez, Mateo Salazar) listos para consultar detalle y cotizar.
3. **Propuestas → Mis propuestas y trabajos** (`MyProposalsJobsScreen`):
   - Pestaña **Propuestas**: propuesta enviada (`San Fernando`), borrador (`El Peñón`) editable/retirable.
   - Pestaña **Trabajos**: obra activa (`Versalles`) y obra finalizada (`Centenario`).
4. **Seguimiento, Hitos y Avances**: entra a la obra activa para ver el acuerdo mutuo, confirmar hitos, registrar un avance y consultar la **Cuenta para recibir pagos** en `Más → Mi perfil`.
5. **Mensajes** (`ConversationsListScreen` + `ProjectChatScreen`): conversaciones bidireccionales con clientes (mensajes enviados por el usuario y mensajes recibidos, incluyendo contraoferta y paginación de historial).

### Parte B · Rol Cliente (alternando desde Mi perfil → avatar)
1. **Inicio Cliente** (`ClientHomeView`): conectado a `ClientHomeBloc` + Supabase, muestra los proyectos creados por el profesor con el conteo real de propuestas recibidas.
2. **Proyectos** (`MyProjectsScreen`): filtro por estado (**Todos**, **En curso**, **Completados**), acceso al asistente de creación de 5 pasos (`ProjectWizardScreen`) y detalle completo (`ProjectDetailScreen`).
3. **Más → Propuestas** (`AllProposalsScreen`): propuestas agrupadas con el título real de cada proyecto y acceso a **Comparar** (`ProposalsCompareScreen`) para proyectos con 2 o más cotizaciones.
4. **Acuerdo, Pago simulado y Cierre**: desde el detalle del proyecto en curso (`Santa Rita`) o finalizado (`El Ingenio`), revisa acuerdo mutuo, pago simulado, hitos y calificación 5★.
5. **Bodega** (`MaterialsCatalogScreen`) y **Contratistas** (`ContractorsDirectoryScreen`): catálogo con filtros, precios por rol y asignación a proyectos reales.

---

## 4. Puntos clave de arquitectura verificables en el código

- **Inyección de dependencias (`GetIt`)**: [`lib/injection_container.dart`](../lib/injection_container.dart) registra como `LazySingleton` todos los repositorios y casos de uso, y como `Factory` / `FactoryParam` los 20 BLoCs de la app; `lib/main.dart` ejecuta `await initDependencies()` antes de `runApp(...)` y las pantallas resuelven sus BLoCs con `resolveBloc` / `resolveBlocParam`.
- **Clean Architecture + BLoC**:
  - `domain/` contiene entidades, contratos de repositorio, errores tipados y casos de uso puros (sin dependencias a `data/` ni SDK de Supabase).
  - `data/` implementa repositorios y fuentes de datos Supabase + Realtime.
  - `presentation/` gestiona estados y eventos exclusivamente mediante `flutter_bloc`.
- **Deploy**: `applicationId` y `namespace` configurados como `com.rivet.app`, soporte de firma `release` vía `android/key.properties` y artefactos compilables para Android (`APK`/`AAB`) y Web.
