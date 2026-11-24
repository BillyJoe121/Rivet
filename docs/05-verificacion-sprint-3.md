# Verificación y Ruta de Trabajo — Sprint 3 hacia Deploy

Documento de control para verificar el estado actual de **Rivet** frente al temario del curso desde la lección **0079** hasta **0083 (Deploy)**, con los criterios de aceptación y las acciones pendientes ordenadas por prioridad.

**Estado base verificado en el repositorio (rama `sprint-3`):**
- `flutter analyze`: sin errores ni advertencias (`No issues found!`).
- `flutter test`: 173/173 pruebas pasando con repositorios en memoria.
- `lib/features/*/domain/`: 0 imports hacia `data/`.
- `pubspec.yaml`: `version: 1.0.0+1` (`get_it`, `flutter_bloc`, `supabase_flutter`, `flutter_dotenv`; sin `google_maps_flutter` ni paquetes de Firebase).
- `android/app/build.gradle.kts`: `namespace = "com.rivet.app"`, `applicationId = "com.rivet.app"` y soporte de firma `release` vía `android/key.properties`.
- `ios/Runner.xcodeproj/project.pbxproj`: `PRODUCT_BUNDLE_IDENTIFIER = com.rivet.app`.

---

## Resumen de estado por bloque

| Bloque | Lecciones | Estado en Rivet | Qué falta |
| :--- | :--- | :--- | :--- |
| 1. Inyección de dependencias | `0079` | 100% completado con `GetIt` (`lib/injection_container.dart`), todos los casos de uso y los 20 BLoCs cableados | Ninguno. |
| 2. Realtime DB y Streams | `0097`, `0063`, `0094`, `0062`, `0096`, `0065` | Implementado en `messaging` (incluye `fetchMessagesBefore`), fix de `respondCounterOffer` y `seed_professor_demo.sql` | Ejecutar `seed_professor_demo.sql` y probar en vivo contra Supabase. |
| 3. Google Maps | `0070`–`0073` | Fuera de este tramo | Integrar `google_maps_flutter` y API Keys cuando entre en alcance. |
| 4. Push Notifications | `0074`–`0078` | Fuera de este tramo | Conectar Firebase (`flutterfire configure`), APNs y backend cuando entre en alcance. |
| 5. Deploy | `0095`, `0080`, `0082`, `0083` | `namespace` y `applicationId` en `com.rivet.app`, `MainActivity` migrado, soporte `key.properties` y builds `APK`/`Web` verificados | Generar `keystore` propio fuera del repo y publicar en App Distribution / tiendas. |

---

## Ruta de trabajo detallada

### Fase 1 · Cierre técnico de Sprint 3 (DI + Supabase + Realtime)

#### 1.1 Inyección de dependencias (`0079`)
- [x] **Contenedor `GetIt` (`lib/injection_container.dart`)**: `sl = GetIt.instance` registra de adentro hacia afuera repositorios y casos de uso (`registerLazySingleton`) y BLoCs (`registerFactory`), inicializado en `lib/main.dart` con `await initDependencies()`.
- [x] **Composition root único**: `lib/main.dart` resuelve las dependencias desde `sl` y las expone con `MultiRepositoryProvider`; solo `AuthBloc` vive en la raíz.
- [x] **Sin instanciación en pantallas**: las pantallas y módulos leen `context.read<XRepository>()` al crear su `Bloc`.
- [x] **Factory uniforme**: `createContractorRepository()` creado en `lib/features/contractors/data/contractor_repository_factory.dart`.
- [x] **Independencia de dominio**: `0` imports de `data/` dentro de `lib/features/*/domain/`.
- [x] **Harness y pruebas**: `test/helpers/repositories_test_harness.dart` y `test/injection_container_test.dart`.

#### 1.2 Programación reactiva, Streams y Supabase Realtime (`0097`, `0063`, `0094`, `0062`, `0096`, `0065`)
- [x] **Convención de capas**: `MessagingBloc` gestiona `StreamSubscription` (`_messagesSub`, `_notificationsSub`) y las cancela en `close()`.
- [x] **Paginación de mensajes (`0065` Parte 2)**: `fetchMessagesBefore`, `LoadOlderMessagesUseCase`, `LoadOlderMessagesRequested` y fusión por `id` en `MessagingBloc` (cubierto en `test/messaging_pagination_test.dart`).
- [x] **Scripts SQL y publicación Realtime versionados**: `supabase/schema_sprint3_tables.sql`, `schema_sprint3_functions.sql`, `schema_sprint3_rls.sql`, `schema_sprint3_storage_realtime.sql` y `seed_sprint3_demo.sql`.
- [x] **Aplicar esquema en Supabase** (aplicado por el equipo):
  1. `supabase/schema_sprint1.sql`
  2. `supabase/schema_sprint3_tables.sql`
  3. `supabase/schema_sprint3_functions.sql`
  4. `supabase/schema_sprint3_rls.sql`
  5. `supabase/schema_sprint3_storage_realtime.sql`
  6. `supabase/seed_sprint3_demo.sql`
- [ ] **Verificación en vivo en dispositivo real contra Supabase**:
  - Probar envío y recepción de mensajes entre dos cuentas en tiempo real (`0065` Parte 1) y carga de mensajes anteriores (`0065` Parte 2).
  - Verificar políticas RLS por rol (`client` / `contractor`) y vista `public_profiles`.
  - Verificar subida y lectura de fotos en el bucket privado `progress-photos`.
  - Generar artefacto de prueba (`flutter build apk --release`) para entrega al docente.

---

### Fase 2 · Funcionalidades nativas (Maps y Push Notifications)

> **Nota de alcance:** Antes de implementar esta fase, confirmar qué pantallas de Rivet usan mapa (por ejemplo ubicación de obra/proyecto o cobertura de contratista) y qué eventos disparan notificaciones push (propuesta recibida, acuerdo aceptado, avance registrado, mensaje nuevo).

#### 2.1 Google Maps (`0070`–`0073`)
- [ ] **Dependencia (`0070`)**: agregar `google_maps_flutter` en `pubspec.yaml`.
- [ ] **API Key y configuración nativa (`0070`)**:
  - Crear clave de API en Google Cloud (Maps SDK for Android / iOS).
  - Configurar `<meta-data android:name="com.google.android.geo.API_KEY" .../>` en `android/app/src/main/AndroidManifest.xml` (sin exponer secretos en código fuente si se inyecta por `local.properties` / manifestPlaceholder).
  - Configurar `GMSServices.provideAPIKey(...)` en `ios/Runner/AppDelegate.swift`.
- [ ] **Mapa y marcadores (`0071`)**: renderizar `GoogleMap` en la pantalla correspondiente con `Set<Marker>` e `InfoWindow`.
- [ ] **Control de cámara (`0072`)**: guardar `GoogleMapController` y animar la cámara (`animateCamera` / `CameraUpdate`) hacia la ubicación seleccionada.
- [ ] **Interacción (`0073`)**: manejar `onTap`, `onLongPress` y `onTap` sobre marcadores para seleccionar o actualizar coordenadas.

#### 2.2 Push Notifications con FCM y APNs (`0074`–`0078`)
- [x] **Identificador definitivo antes de Firebase (`0080` + `0075`)**: `applicationId` actualizado a `com.rivet.app` en `android/app/build.gradle.kts` y `PRODUCT_BUNDLE_IDENTIFIER` en iOS.
- [ ] **Proyecto y CLI (`0075`)**: crear proyecto en Firebase Console, autenticar `firebase login` y ejecutar `flutterfire configure`.
- [ ] **Dependencias y Android Gradle (`0077`)**:
  - Agregar `firebase_core`, `firebase_messaging` y `flutter_local_notifications` en `pubspec.yaml`.
  - Habilitar *core library desugaring* en `android/app/build.gradle.kts`.
- [ ] **Módulo de notificaciones (`0077`)**:
  - Crear servicio/helper `lib/push/push_notifications.dart` e inicializarlo en `main.dart`.
  - Manejar los 3 estados: app cerrada, segundo plano y primer plano (`onMessage` mostrando notificación local).
  - Suscribir al tópico o registrar token FCM del usuario.
- [ ] **Configuración iOS (`0077`)**: crear llave APNs (`.p8`) en Apple Developer, subirla a Firebase Cloud Messaging y habilitar *Push Notifications* y *Background Modes* en Xcode.
- [ ] **Backend y pruebas (`0076`, `0078`)**:
  - Generar llave privada de cuenta de servicio en Firebase y resguardarla **solo en backend** (por ejemplo Supabase Edge Function o servidor seguro, nunca en `.env` del cliente).
  - Probar envío desde Firebase Console y desde el backend con `android.priority: high` en los 3 estados de la app.

---

### Fase 3 · Empaquetado y Deploy (`0095`, `0080`, `0082`, `0083`)

#### 3.1 Preparación de artefactos (`0080`)
- [ ] **Identificador único**: confirmar que Android (`applicationId`) e iOS (`Bundle Identifier`) no usen `com.example.*`.
- [ ] **Versionado**: gestionar `version: X.Y.Z+N` en `pubspec.yaml` (subir `+N` en cada entrega).
- [ ] **Android (AAB)**:
  - Generar `keystore` único con `keytool` (resguardar fuera del repositorio).
  - Crear `android/key.properties` (ignorado en `.gitignore`) y configurar `signingConfigs` en `android/app/build.gradle.kts` para `release`.
  - Compilar con `flutter build appbundle`.
- [ ] **iOS (IPA)** (requiere macOS + Xcode):
  - Validar `flutter doctor` sin errores de Xcode.
  - Configurar firma/provisioning en Xcode y compilar `flutter build ipa`.

#### 3.2 Distribución de pruebas (`0095`)
- [ ] Generar APK de release (`flutter build apk --release`).
- [ ] Subir a **Firebase App Distribution**, crear grupo de testers, añadir notas de versión y distribuir.

#### 3.3 Publicación en Google Play (`0082`)
- [ ] Crear la app en Google Play Console y completar ficha de Play Store, cuestionarios y **cuenta de prueba** para revisores (por tener login).
- [ ] Subir el `.aab` a **Prueba cerrada** (no interna) con **al menos 12 testers durante 14 días seguidos** (si la cuenta es personal creada desde nov 2023).
- [ ] Solicitar acceso a producción tras los 14 días y enviar versión a revisión.

#### 3.4 Publicación en App Store (`0083`)
- [ ] Verificar membresía activa en Apple Developer Program y crear registro en App Store Connect.
- [ ] Subir `.ipa` (Transporter / Xcode), validar en **TestFlight** (opcional recomendado), completar ficha/privacidad/precios y enviar a *App Review*.

---

## Criterio de cierre recomendado
1. **Para cerrar Sprint 3 en el repo**: aplicar los 5 SQL en Supabase, verificar en vivo chat Realtime + RLS + `progress-photos`, y definir el criterio de `GetIt` vs `MultiRepositoryProvider`.
2. **Para avanzar hacia Deploy**: cambiar `com.example.rivet` antes de configurar Firebase, implementar Maps/Push según alcance del producto y preparar firma + App Distribution para iniciar pruebas cerradas.
