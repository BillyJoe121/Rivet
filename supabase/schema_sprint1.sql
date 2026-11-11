-- ==============================================================================
-- RIVET — SPRINT 1 SCHEMA & POLICIES (Supabase / PostgreSQL)
-- ==============================================================================

-- 1. Tabla de perfiles vinculada a auth.users
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  full_name text not null,
  role text not null check (role in ('client', 'contractor')),
  phone text not null default '',
  avatar_url text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 2. Habilitar Row Level Security (RLS)
alter table public.profiles enable row level security;

-- 3. Políticas de seguridad (RLS)
-- Cada usuario lee solo su propio perfil completo (correo y teléfono incluidos).
drop policy if exists "Authenticated users can view profiles" on public.profiles;
drop policy if exists "Users can view their own profile" on public.profiles;
create policy "Users can view their own profile"
  on public.profiles
  for select
  to authenticated
  using ((select auth.uid()) = id);

drop policy if exists "Users can insert their own profile" on public.profiles;
create policy "Users can insert their own profile"
  on public.profiles
  for insert
  to authenticated
  with check ((select auth.uid()) = id);

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile"
  on public.profiles
  for update
  to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id);

-- 4. Trigger automático al registrar usuario en Supabase Auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name, role, phone)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    coalesce(new.raw_user_meta_data->>'role', 'client'),
    coalesce(new.raw_user_meta_data->>'phone', '')
  )
  on conflict (id) do update set
    email = excluded.email,
    full_name = case when excluded.full_name <> '' then excluded.full_name else public.profiles.full_name end,
    role = case when excluded.role <> '' then excluded.role else public.profiles.role end,
    phone = case when excluded.phone <> '' then excluded.phone else public.profiles.phone end,
    updated_at = now();
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Conceder permisos de lectura y escritura al rol autenticado
grant select, insert, update on public.profiles to authenticated;
revoke select on public.profiles from anon;

-- 5. Datos públicos de un perfil (sin correo ni teléfono) para mostrar a otros usuarios
create or replace view public.public_profiles as
  select id, full_name, role, avatar_url
  from public.profiles;

revoke all on public.public_profiles from anon;
grant select on public.public_profiles to authenticated;
