# Esquema de base de datos (Supabase)

Los scripts son idempotentes y se aplican en el editor SQL de Supabase, en este orden:

1. `schema_sprint1.sql` — perfiles, trigger de registro y vista `public_profiles`.
2. `schema_sprint3_tables.sql` — tablas, migración de estados heredados, índices y vista `contractor_rating_summary`.
3. `schema_sprint3_functions.sql` — funciones auxiliares de RLS, trigger de perfiles y triggers de integridad.
4. `schema_sprint3_rls.sql` — permisos y políticas RLS de todas las tablas.
5. `schema_sprint3_storage_realtime.sql` — buckets privados de fotos y publicación realtime.

## Antes de aplicar

- Confirma con evidencia si la base es de prueba o de producción (proyecto, entorno, volumen y realismo de los datos). Si no se puede confirmar, trátala como producción.
- En producción no apliques nada sin un respaldo reciente y verificado.
- El paso 2 migra estados heredados (`published` → `open`, `Aceptada` → `accepted`, etc.). Si quedan valores desconocidos, el script avisa con un `NOTICE` y deja la restricción sin validar: revísalos antes de seguir.
- Si `projects` o `proposals` ya existen con `id` de tipo texto, las llaves foráneas de las tablas nuevas fallarán: revisa los tipos antes de aplicar.

No guardes llaves, tokens ni URLs del proyecto en estos archivos.
