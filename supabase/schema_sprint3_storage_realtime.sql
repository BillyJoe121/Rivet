-- ==============================================================================
-- RIVET — SPRINT 3 · 4/4 STORAGE PRIVADO Y REALTIME
-- Aplicar después de schema_sprint3_rls.sql. Idempotente.
-- Ruta obligatoria de los archivos: <agreement_id>/<nombre de archivo>
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. Buckets privados (solo imágenes, máximo 10 MB)
-- ------------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('progress-photos', 'progress-photos', false, 10485760,
        array['image/jpeg', 'image/png', 'image/webp', 'image/heic'])
on conflict (id) do nothing;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('cancellation-photos', 'cancellation-photos', false, 10485760,
        array['image/jpeg', 'image/png', 'image/webp', 'image/heic'])
on conflict (id) do nothing;

-- ------------------------------------------------------------------------------
-- 2. Papel de quien llama en el acuerdo indicado por el primer segmento de la ruta
--    (null si la ruta no empieza por un uuid válido o no es parte del acuerdo)
-- ------------------------------------------------------------------------------
create or replace function public.storage_object_agreement_role(p_name text)
returns text language plpgsql stable security definer set search_path = public as $$
declare v_agreement uuid;
begin
  begin
    v_agreement := (string_to_array(p_name, '/'))[1]::uuid;
  exception when invalid_text_representation then
    return null;
  end;
  return public.agreement_role(v_agreement);
end;
$$;

revoke all on function public.storage_object_agreement_role(text) from public, anon;
grant execute on function public.storage_object_agreement_role(text) to authenticated;

-- ------------------------------------------------------------------------------
-- 3. Políticas de storage.objects. Sin update ni delete: las fotos son evidencia
--    (la app no debe subir con upsert).
-- ------------------------------------------------------------------------------
drop policy if exists "Agreement parties read progress photos" on storage.objects;
create policy "Agreement parties read progress photos" on storage.objects
  for select to authenticated
  using (bucket_id = 'progress-photos'
         and public.storage_object_agreement_role(name) is not null);

drop policy if exists "Agreement contractor uploads progress photos" on storage.objects;
create policy "Agreement contractor uploads progress photos" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'progress-photos'
              and public.storage_object_agreement_role(name) = 'contractor');

drop policy if exists "Agreement parties read cancellation photos" on storage.objects;
create policy "Agreement parties read cancellation photos" on storage.objects
  for select to authenticated
  using (bucket_id = 'cancellation-photos'
         and public.storage_object_agreement_role(name) is not null);

drop policy if exists "Agreement parties upload cancellation photos" on storage.objects;
create policy "Agreement parties upload cancellation photos" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'cancellation-photos'
              and public.storage_object_agreement_role(name) is not null);

-- ------------------------------------------------------------------------------
-- 4. Realtime: mensajes y notificaciones (Realtime aplica la RLS de cada tabla)
-- ------------------------------------------------------------------------------
do $$
declare t text;
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    raise notice 'La publicación supabase_realtime no existe; se omite realtime';
    return;
  end if;
  foreach t in array array['messages', 'notifications'] loop
    if not exists (select 1 from pg_publication_tables
                   where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end $$;
