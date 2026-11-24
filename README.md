# Rivet — Plataforma de cotización y seguimiento de obra

Aplicación móvil y web en **Flutter** para conectar propietarios (**Clientes**) y profesionales de pintura y acabados (**Contratistas**): publicación guiada de proyectos por espacios y m², comparación de propuestas, acuerdos mutuos con hitos, registro fotográfico de avances, pagos simulados, bodega de materiales y mensajería en tiempo real.

---

## Arquitectura del proyecto

El proyecto sigue **Clean Architecture** por módulo (`features/<modulo>/{domain,data,presentation}`) con **BLoC (`flutter_bloc`)** para gestión de estado e inyección de dependencias centralizada con **`GetIt`**:

- **Contenedor DI (`GetIt`)**: [`lib/injection_container.dart`](lib/injection_container.dart) registra todos los repositorios, casos de uso (`registerLazySingleton`) y los 20 BLoCs (`registerFactory` / `registerFactoryParam`), inicializados al arranque en [`lib/main.dart`](lib/main.dart) mediante `await initDependencies()`.
- **Capas desacopladas**: `domain/` no importa `data/` ni `supabase_flutter` (verificado por prueba automática en [`test/injection_container_test.dart`](test/injection_container_test.dart)).
- **Backend y tiempo real**: Supabase Auth, PostgreSQL con Row Level Security (RLS), Storage privado (`progress-photos`) y Supabase Realtime para mensajería paginada y notificaciones.

---

## Configuración inicial

1. **Variables de entorno**: copia `.env.example` a `.env` en la raíz del proyecto y completa `SUPABASE_URL` y `SUPABASE_ANON_KEY` (no subas `.env` al repositorio).
2. **Base de datos (Supabase SQL Editor)**: ejecuta los scripts en el orden documentado en [`supabase/README.md`](supabase/README.md), y opcionalmente [`supabase/seed_professor_demo.sql`](supabase/seed_professor_demo.sql) para cargar la cuenta de evaluación dual-role.
3. **Dependencias**:
   ```bash
   flutter pub get
   ```

---

## Verificación y pruebas

```bash
flutter analyze
flutter test
```

Para la guía de recorrido funcional y evaluación dual-role, consulta [`docs/06-guia-profesor-demo.md`](docs/06-guia-profesor-demo.md).

---

## Compilación y Deploy

- **Identificador de aplicación**: `com.rivet.app` (`android/app/build.gradle.kts` e iOS `PRODUCT_BUNDLE_IDENTIFIER`).
- **Firma Android Release (opcional para Play Store / distribución)**: crea `android/key.properties` (ignorado en Git) con `storeFile`, `storePassword`, `keyAlias` y `keyPassword`. Si no existe, el build `release` usa la firma local de respaldo para pruebas.
- **Comandos**:
  ```bash
  flutter build apk --release
  flutter build appbundle --release
  flutter build web --release
  ```
