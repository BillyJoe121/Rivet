-- ==============================================================================
-- RIVET — SPRINT 3 · 1/4 TABLAS, RESTRICCIONES, MIGRACIÓN DE ESTADOS E ÍNDICES
-- Aplicar después de schema_sprint1.sql. Idempotente.
-- ==============================================================================

-- gen_random_uuid() es nativa desde PostgreSQL 13 (no requiere extensiones).

-- ------------------------------------------------------------------------------
-- 1. Tablas existentes usadas por la app (DDL reproducible)
-- ------------------------------------------------------------------------------
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text not null default '',
  city text not null default '',
  neighborhood text not null default '',
  status text not null default 'open',
  budget_estimate_cop numeric(14,2) not null default 0 check (budget_estimate_cop >= 0),
  photo_paths text[] not null default '{}',
  ai_review_authorized boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.project_spaces (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  position integer not null default 0,
  name text not null,
  width_meters numeric(8,2) not null check (width_meters > 0),
  height_meters numeric(8,2) not null check (height_meters > 0),
  finish_type text not null default 'Vinilo Tipo 1',
  has_defects boolean not null default false,
  photo_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.proposals (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  contractor_id uuid not null references public.profiles(id) on delete cascade,
  labor_cost_cop numeric(14,2) not null default 0 check (labor_cost_cop >= 0),
  materials_cost_cop numeric(14,2) not null default 0 check (materials_cost_cop >= 0),
  estimated_days integer not null default 1 check (estimated_days > 0),
  observations text not null default '',
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.materials (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text not null default '',
  category text not null default 'General',
  unit text not null default 'unidad',
  client_price_cop numeric(14,2) not null default 0 check (client_price_cop >= 0),
  pro_price_cop numeric(14,2) not null default 0 check (pro_price_cop >= 0),
  finish text,
  in_stock boolean not null default true,
  created_at timestamptz not null default now()
);

-- Si las tablas ya existían con otra forma, aseguramos las columnas que usan las
-- políticas y la app (nullable para no fallar con filas existentes).
alter table public.projects add column if not exists client_id uuid references public.profiles(id) on delete cascade;
alter table public.projects add column if not exists status text;
alter table public.projects add column if not exists budget_estimate_cop numeric(14,2);
alter table public.projects add column if not exists photo_paths text[] not null default '{}';
alter table public.projects add column if not exists ai_review_authorized boolean not null default false;
alter table public.projects add column if not exists updated_at timestamptz not null default now();
alter table public.project_spaces add column if not exists position integer not null default 0;
alter table public.project_spaces add column if not exists has_defects boolean not null default false;
alter table public.project_spaces add column if not exists photo_url text;
alter table public.proposals add column if not exists contractor_id uuid references public.profiles(id) on delete cascade;
alter table public.proposals add column if not exists status text;
alter table public.proposals add column if not exists updated_at timestamptz not null default now();

-- Campos públicos de perfil para el directorio de contratistas y la zona del usuario.
alter table public.profiles add column if not exists trade text not null default '';
alter table public.profiles add column if not exists zone text not null default '';
alter table public.profiles add column if not exists bio text not null default '';
alter table public.profiles add column if not exists is_verified boolean not null default false;
alter table public.profiles add column if not exists completed_jobs integer not null default 0 check (completed_jobs >= 0);
alter table public.profiles add column if not exists portfolio_images text[] not null default '{}';

create table if not exists public.project_materials (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  product_id text not null,
  position integer not null default 0,
  name text not null,
  unit text not null default 'unidad',
  unit_price_cop numeric(14,2) not null default 0 check (unit_price_cop >= 0),
  quantity integer not null default 1 check (quantity > 0),
  created_at timestamptz not null default now()
);

-- ------------------------------------------------------------------------------
-- 2. Migración de estados heredados (parte de esta migración)
--    projects: los valores del enum Dart anterior pasan al contrato nuevo.
--    proposals: las filas heredadas con 'Aceptada' deben quedar como 'accepted'.
-- ------------------------------------------------------------------------------
update public.projects set status = 'open'
  where status is null or status in ('published', 'underReview', 'negotiating');
update public.projects set status = 'in_progress'
  where status in ('agreed', 'inProgress');

update public.proposals set status = 'accepted'  where status = 'Aceptada';
update public.proposals set status = 'rejected'  where status = 'Rechazada';
update public.proposals set status = 'sent'      where status is null or status in ('Recibida', 'Enviada');
update public.proposals set status = 'draft'     where status = 'Borrador';
update public.proposals set status = 'withdrawn' where status = 'Retirada';

alter table public.projects alter column status set default 'open';
alter table public.projects alter column status set not null;
alter table public.proposals alter column status set default 'draft';
alter table public.proposals alter column status set not null;

-- Restricciones de estado: se crean NOT VALID y se validan solo si no quedan
-- valores desconocidos; si quedan, se avisa con NOTICE en vez de abortar.
alter table public.projects drop constraint if exists projects_status_check;
alter table public.projects add constraint projects_status_check
  check (status in ('draft', 'open', 'in_progress', 'completed', 'cancelled')) not valid;

alter table public.proposals drop constraint if exists proposals_status_check;
alter table public.proposals add constraint proposals_status_check
  check (status in ('draft', 'sent', 'accepted', 'rejected', 'withdrawn')) not valid;

do $$
begin
  if not exists (select 1 from public.projects
                 where status not in ('draft', 'open', 'in_progress', 'completed', 'cancelled')) then
    alter table public.projects validate constraint projects_status_check;
  else
    raise notice 'projects tiene estados fuera del contrato; revisa antes de validar projects_status_check';
  end if;
  if not exists (select 1 from public.proposals
                 where status not in ('draft', 'sent', 'accepted', 'rejected', 'withdrawn')) then
    alter table public.proposals validate constraint proposals_status_check;
  else
    raise notice 'proposals tiene estados fuera del contrato; revisa antes de validar proposals_status_check';
  end if;
end $$;

-- ------------------------------------------------------------------------------
-- 3. Tablas nuevas del Sprint 3
-- ------------------------------------------------------------------------------
create table if not exists public.agreements (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete restrict,
  proposal_id uuid not null unique references public.proposals(id) on delete restrict,
  client_id uuid not null references public.profiles(id) on delete restrict,
  contractor_id uuid not null references public.profiles(id) on delete restrict,
  labor_amount numeric(14,2) not null default 0 check (labor_amount >= 0),
  materials_amount numeric(14,2) not null default 0 check (materials_amount >= 0),
  total_amount numeric(14,2) not null default 0 check (total_amount >= 0),
  start_date date,
  end_date date,
  client_accepted_at timestamptz,
  contractor_accepted_at timestamptz,
  status text not null default 'pending'
    check (status in ('pending', 'active', 'completed', 'cancelled')),
  created_at timestamptz not null default now(),
  check (client_id <> contractor_id),
  check (end_date is null or start_date is null or end_date >= start_date)
);

-- Checklist de entrega mutua: 'done' cuando ambas partes confirman.
create table if not exists public.agreement_milestones (
  id uuid primary key default gen_random_uuid(),
  agreement_id uuid not null references public.agreements(id) on delete cascade,
  position integer not null default 0,
  title text not null check (char_length(title) between 1 and 200),
  status text not null default 'pending' check (status in ('pending', 'done')),
  client_confirmed_at timestamptz,
  contractor_confirmed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (agreement_id, position)
);

create table if not exists public.progress_updates (
  id uuid primary key default gen_random_uuid(),
  agreement_id uuid not null references public.agreements(id) on delete cascade,
  milestone_id uuid references public.agreement_milestones(id) on delete set null,
  author_id uuid not null references public.profiles(id) on delete cascade,
  percent integer not null check (percent between 0 and 100),
  description text not null default '' check (char_length(description) <= 2000),
  photo_paths text[] not null default '{}',
  status text not null default 'draft' check (status in ('draft', 'sent')),
  created_at timestamptz not null default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  client_id uuid not null references public.profiles(id) on delete cascade,
  contractor_id uuid not null references public.profiles(id) on delete cascade,
  last_message_at timestamptz,
  created_at timestamptz not null default now(),
  unique (project_id, client_id, contractor_id),
  check (client_id <> contractor_id)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null default '' check (char_length(body) <= 4000),
  kind text not null default 'text' check (kind in ('text', 'counter_offer', 'system')),
  counter_offer_amount numeric(14,2) check (counter_offer_amount >= 0),
  read_at timestamptz,
  created_at timestamptz not null default now(),
  check ((kind = 'counter_offer') = (counter_offer_amount is not null))
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  kind text not null check (char_length(kind) between 1 and 60),
  title text not null check (char_length(title) between 1 and 120),
  body text not null default '' check (char_length(body) <= 1000),
  project_id uuid references public.projects(id) on delete set null,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

-- Pagos simulados. NUNCA se guarda número de tarjeta, CVV ni vencimiento:
-- solo la marca y los últimos 4 dígitos.
create table if not exists public.payments (
  id uuid primary key default gen_random_uuid(),
  agreement_id uuid not null references public.agreements(id) on delete restrict,
  payer_id uuid not null references public.profiles(id) on delete restrict,
  kind text not null check (kind in ('advance', 'final')),
  amount numeric(14,2) not null check (amount > 0),
  status text not null default 'pending'
    check (status in ('pending', 'approved', 'rejected', 'held', 'released', 'refunded')),
  card_brand text check (char_length(card_brand) <= 30),
  card_last4 text check (card_last4 ~ '^[0-9]{4}$'),
  released_at timestamptz,
  created_at timestamptz not null default now()
);

-- Cuenta de cobro del contratista: solo últimos 4 dígitos de cuenta y documento.
create table if not exists public.payout_accounts (
  id uuid primary key default gen_random_uuid(),
  contractor_id uuid not null unique references public.profiles(id) on delete cascade,
  bank_name text not null check (char_length(bank_name) between 1 and 80),
  account_type text not null check (account_type in ('ahorros', 'corriente')),
  account_number_last4 text not null check (account_number_last4 ~ '^[0-9]{4}$'),
  holder_name text not null check (char_length(holder_name) between 1 and 120),
  document_number_last4 text not null check (document_number_last4 ~ '^[0-9]{4}$'),
  verification_status text not null default 'pending'
    check (verification_status in ('pending', 'verified')),
  created_at timestamptz not null default now()
);

create table if not exists public.ratings (
  id uuid primary key default gen_random_uuid(),
  agreement_id uuid not null references public.agreements(id) on delete cascade,
  rater_id uuid not null references public.profiles(id) on delete cascade,
  ratee_id uuid not null references public.profiles(id) on delete cascade,
  stars smallint not null check (stars between 1 and 5),
  review text not null default '' check (char_length(review) <= 500),
  created_at timestamptz not null default now(),
  unique (agreement_id, rater_id),
  check (rater_id <> ratee_id)
);

create table if not exists public.cancellations (
  id uuid primary key default gen_random_uuid(),
  agreement_id uuid not null references public.agreements(id) on delete cascade,
  requested_by uuid not null references public.profiles(id) on delete cascade,
  reason text not null check (char_length(reason) between 1 and 120),
  description text not null default '' check (char_length(description) <= 2000),
  photo_paths text[] not null default '{}',
  status text not null default 'requested'
    check (status in ('requested', 'approved', 'rejected', 'refunded')),
  resolved_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.visit_requests (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.profiles(id) on delete cascade,
  contractor_id uuid not null references public.profiles(id) on delete cascade,
  project_id uuid references public.projects(id) on delete set null,
  address text not null check (char_length(address) between 1 and 300),
  preferred_date text not null check (char_length(preferred_date) between 1 and 120),
  time_slot text not null check (char_length(time_slot) between 1 and 120),
  notes text not null default '' check (char_length(notes) <= 1000),
  fee_cop numeric(14,2) not null default 0 check (fee_cop >= 0),
  simulated_paid boolean not null default true,
  status text not null default 'requested'
    check (status in ('requested', 'confirmed', 'completed', 'cancelled')),
  created_at timestamptz not null default now(),
  check (client_id <> contractor_id)
);

-- ------------------------------------------------------------------------------
-- 4. Índices
-- ------------------------------------------------------------------------------
create index if not exists projects_client_id_idx on public.projects (client_id);
create index if not exists projects_open_idx on public.projects (created_at desc) where status = 'open';
create index if not exists projects_status_idx on public.projects (status);
create index if not exists project_spaces_project_id_idx on public.project_spaces (project_id);
create index if not exists project_materials_project_id_idx on public.project_materials (project_id);
create index if not exists visit_requests_client_id_idx on public.visit_requests (client_id, created_at desc);
create index if not exists visit_requests_contractor_id_idx on public.visit_requests (contractor_id, created_at desc);
create index if not exists proposals_project_id_idx on public.proposals (project_id);
create index if not exists proposals_contractor_id_idx on public.proposals (contractor_id);
create index if not exists materials_category_idx on public.materials (category);
create index if not exists agreements_project_id_idx on public.agreements (project_id);
create index if not exists agreements_client_id_idx on public.agreements (client_id);
create index if not exists agreements_contractor_id_idx on public.agreements (contractor_id);
create index if not exists agreement_milestones_agreement_id_idx on public.agreement_milestones (agreement_id);
create index if not exists progress_updates_agreement_id_idx on public.progress_updates (agreement_id, created_at desc);
create index if not exists progress_updates_milestone_id_idx on public.progress_updates (milestone_id);
create index if not exists progress_updates_author_id_idx on public.progress_updates (author_id);
create index if not exists conversations_client_id_idx on public.conversations (client_id);
create index if not exists conversations_contractor_id_idx on public.conversations (contractor_id);
create index if not exists messages_conversation_id_idx on public.messages (conversation_id, created_at);
create index if not exists messages_sender_id_idx on public.messages (sender_id);
create index if not exists notifications_user_id_idx on public.notifications (user_id, created_at desc);
create index if not exists notifications_project_id_idx on public.notifications (project_id);
create index if not exists payments_agreement_id_idx on public.payments (agreement_id);
create index if not exists payments_payer_id_idx on public.payments (payer_id);
-- Evita cobrar dos veces el mismo tramo (anticipo o final) de un acuerdo.
create unique index if not exists payments_one_effective_per_kind_idx
  on public.payments (agreement_id, kind) where status in ('approved', 'held', 'released');
create index if not exists ratings_agreement_id_idx on public.ratings (agreement_id);
create index if not exists ratings_rater_id_idx on public.ratings (rater_id);
create index if not exists ratings_ratee_id_idx on public.ratings (ratee_id);
create index if not exists cancellations_agreement_id_idx on public.cancellations (agreement_id);
create index if not exists cancellations_requested_by_idx on public.cancellations (requested_by);

-- ------------------------------------------------------------------------------
-- 5. Resumen de calificaciones (respeta la RLS de ratings de quien consulta)
-- ------------------------------------------------------------------------------
create or replace view public.contractor_rating_summary
  with (security_invoker = true) as
  select r.ratee_id as contractor_id,
         round(avg(r.stars)::numeric, 2) as avg_stars,
         count(*)::integer as review_count
  from public.ratings r
  join public.agreements a on a.id = r.agreement_id and a.contractor_id = r.ratee_id
  group by r.ratee_id;
