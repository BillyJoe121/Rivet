-- ==============================================================================
-- RIVET — SPRINT 3 · 2/4 FUNCIONES AUXILIARES Y TRIGGERS DE INTEGRIDAD
-- Aplicar después de schema_sprint3_tables.sql. Idempotente.
-- Las funciones auxiliares de RLS son SECURITY DEFINER con search_path fijo para
-- evitar recursión entre políticas (projects <-> agreements) y solo las ejecuta
-- el rol authenticated.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. Auxiliares de autorización
-- ------------------------------------------------------------------------------
create or replace function public.current_app_role()
returns text language sql stable security definer set search_path = public as $$
  select p.role from public.profiles p where p.id = auth.uid();
$$;

create or replace function public.is_project_owner(p_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.projects p
                 where p.id = p_project and p.client_id = auth.uid());
$$;

create or replace function public.is_project_agreement_contractor(p_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.agreements a
                 where a.project_id = p_project and a.contractor_id = auth.uid());
$$;

-- 'client' | 'contractor' | null según el papel de quien llama en el acuerdo.
create or replace function public.agreement_role(p_agreement uuid)
returns text language sql stable security definer set search_path = public as $$
  select case when a.client_id = auth.uid() then 'client'
              when a.contractor_id = auth.uid() then 'contractor' end
  from public.agreements a where a.id = p_agreement;
$$;

create or replace function public.is_conversation_participant(p_conversation uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.conversations c
                 where c.id = p_conversation
                   and auth.uid() in (c.client_id, c.contractor_id));
$$;

-- Decisión de seguridad: un usuario solo puede notificar a OTRO usuario con el que
-- ya tiene una relación de trabajo: un acuerdo compartido, una conversación
-- compartida, o una propuesta (no borrador) sobre el proyecto indicado entre el
-- dueño del proyecto y el contratista. No se permite notificar a desconocidos.
create or replace function public.can_notify(p_target uuid, p_project uuid)
returns boolean language sql stable security definer set search_path = public as $$
  select p_target is not null and auth.uid() is not null and p_target <> auth.uid() and (
    exists (select 1 from public.agreements a
            where (a.client_id = auth.uid() and a.contractor_id = p_target)
               or (a.contractor_id = auth.uid() and a.client_id = p_target))
    or exists (select 1 from public.conversations c
               where (c.client_id = auth.uid() and c.contractor_id = p_target)
                  or (c.contractor_id = auth.uid() and c.client_id = p_target))
    or exists (select 1 from public.proposals pr
               join public.projects pj on pj.id = pr.project_id
               where pr.project_id = p_project and pr.status <> 'draft'
                 and ((pr.contractor_id = auth.uid() and pj.client_id = p_target)
                   or (pj.client_id = auth.uid() and pr.contractor_id = p_target)))
  );
$$;

-- Promedio público de un contratista: expone solo agregados, nunca filas de ratings.
create or replace function public.get_contractor_rating_summary(p_contractor uuid)
returns table (contractor_id uuid, avg_stars numeric, review_count integer)
language sql stable security definer set search_path = public as $$
  select p_contractor, round(avg(r.stars)::numeric, 2), count(*)::integer
  from public.ratings r
  join public.agreements a on a.id = r.agreement_id and a.contractor_id = r.ratee_id
  where r.ratee_id = p_contractor;
$$;

do $$
declare f text;
begin
  foreach f in array array[
    'public.current_app_role()',
    'public.is_project_owner(uuid)',
    'public.is_project_agreement_contractor(uuid)',
    'public.agreement_role(uuid)',
    'public.is_conversation_participant(uuid)',
    'public.can_notify(uuid, uuid)',
    'public.get_contractor_rating_summary(uuid)'
  ] loop
    execute format('revoke all on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end $$;

-- ------------------------------------------------------------------------------
-- 2. Perfil creado solo por el trigger (mismo comportamiento, search_path fijo y
--    rol limitado a client/contractor)
-- ------------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name, role, phone)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    case when new.raw_user_meta_data->>'role' in ('client', 'contractor')
         then new.raw_user_meta_data->>'role' else 'client' end,
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
$$;

revoke all on function public.handle_new_user() from public, anon, authenticated;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ------------------------------------------------------------------------------
-- 3. Triggers de integridad (auth.uid() nulo = service role / SQL editor: se omite
--    la validación por parte, no la de forma)
-- ------------------------------------------------------------------------------

-- Propuestas: el dueño del proyecto solo cambia el estado.
create or replace function public.proposals_guard_update()
returns trigger language plpgsql set search_path = public as $$
begin
  if new.id is distinct from old.id
     or new.project_id is distinct from old.project_id
     or new.contractor_id is distinct from old.contractor_id
     or new.created_at is distinct from old.created_at then
    raise exception 'proposal: project_id, contractor_id y created_at son inmutables' using errcode = '42501';
  end if;
  if auth.uid() is not null and auth.uid() <> old.contractor_id
     and (new.labor_cost_cop, new.materials_cost_cop, new.estimated_days, new.observations)
         is distinct from (old.labor_cost_cop, old.materials_cost_cop, old.estimated_days, old.observations) then
    raise exception 'proposal: el dueño del proyecto solo puede cambiar el estado' using errcode = '42501';
  end if;
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists proposals_guard_update on public.proposals;
create trigger proposals_guard_update before update on public.proposals
  for each row execute function public.proposals_guard_update();

-- Acuerdos: aceptación por parte, términos editables solo en 'pending' y
-- transiciones de estado válidas.
create or replace function public.agreements_guard_update()
returns trigger language plpgsql set search_path = public as $$
declare v_terms_changed boolean;
begin
  if (new.project_id, new.proposal_id, new.client_id, new.contractor_id, new.created_at)
     is distinct from (old.project_id, old.proposal_id, old.client_id, old.contractor_id, old.created_at) then
    raise exception 'agreement: partes, proyecto y propuesta son inmutables' using errcode = '42501';
  end if;
  v_terms_changed := (new.labor_amount, new.materials_amount, new.total_amount, new.start_date, new.end_date)
     is distinct from (old.labor_amount, old.materials_amount, old.total_amount, old.start_date, old.end_date);

  if auth.uid() is not null then
    if new.client_accepted_at is distinct from old.client_accepted_at and auth.uid() <> old.client_id then
      raise exception 'agreement: solo el cliente registra su aceptación' using errcode = '42501';
    end if;
    if new.contractor_accepted_at is distinct from old.contractor_accepted_at and auth.uid() <> old.contractor_id then
      raise exception 'agreement: solo el contratista registra su aceptación' using errcode = '42501';
    end if;
    if v_terms_changed then
      if old.status <> 'pending' then
        raise exception 'agreement: los términos solo cambian mientras está pendiente' using errcode = '42501';
      end if;
      -- Cambiar los términos invalida la aceptación de la otra parte.
      if auth.uid() = old.client_id then new.contractor_accepted_at := null;
      else new.client_accepted_at := null; end if;
    end if;
  end if;

  if new.status is distinct from old.status then
    if not ((old.status = 'pending' and new.status in ('active', 'cancelled'))
         or (old.status = 'active' and new.status in ('completed', 'cancelled'))) then
      raise exception 'agreement: transición % -> % no permitida', old.status, new.status using errcode = '23514';
    end if;
    if new.status = 'active' and (new.client_accepted_at is null or new.contractor_accepted_at is null) then
      raise exception 'agreement: requiere la aceptación de ambas partes' using errcode = '23514';
    end if;
    if new.status = 'completed' and exists (select 1 from public.agreement_milestones m
                                            where m.agreement_id = old.id and m.status <> 'done') then
      raise exception 'agreement: hay hitos sin confirmar por ambas partes' using errcode = '23514';
    end if;
    if old.status = 'active' and new.status = 'cancelled' and auth.uid() is not null
       and not exists (select 1 from public.cancellations c
                       where c.agreement_id = old.id and c.status in ('approved', 'refunded')) then
      raise exception 'agreement: cancelar un acuerdo activo requiere una cancelación aprobada' using errcode = '23514';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists agreements_guard_update on public.agreements;
create trigger agreements_guard_update before update on public.agreements
  for each row execute function public.agreements_guard_update();

-- Hitos: cada parte confirma solo lo suyo; 'done' se calcula cuando ambas confirman.
create or replace function public.agreement_milestones_guard()
returns trigger language plpgsql set search_path = public as $$
declare
  v_role text;
  v_agreement_status text;
begin
  select a.status into v_agreement_status from public.agreements a where a.id = new.agreement_id;
  if tg_op = 'INSERT' then
    new.client_confirmed_at := null;
    new.contractor_confirmed_at := null;
  else
    if new.agreement_id is distinct from old.agreement_id then
      raise exception 'milestone: agreement_id es inmutable' using errcode = '42501';
    end if;
    if auth.uid() is not null then
      v_role := public.agreement_role(old.agreement_id);
      if (new.title, new.position) is distinct from (old.title, old.position)
         and v_agreement_status <> 'pending' then
        raise exception 'milestone: el checklist solo se edita con el acuerdo pendiente' using errcode = '42501';
      end if;
      if new.client_confirmed_at is distinct from old.client_confirmed_at and v_role is distinct from 'client' then
        raise exception 'milestone: solo el cliente confirma su parte' using errcode = '42501';
      end if;
      if new.contractor_confirmed_at is distinct from old.contractor_confirmed_at and v_role is distinct from 'contractor' then
        raise exception 'milestone: solo el contratista confirma su parte' using errcode = '42501';
      end if;
      if (new.client_confirmed_at, new.contractor_confirmed_at)
         is distinct from (old.client_confirmed_at, old.contractor_confirmed_at)
         and v_agreement_status <> 'active' then
        raise exception 'milestone: solo se confirma con el acuerdo activo' using errcode = '42501';
      end if;
    end if;
  end if;
  new.status := case when new.client_confirmed_at is not null and new.contractor_confirmed_at is not null
                     then 'done' else 'pending' end;
  return new;
end;
$$;

drop trigger if exists agreement_milestones_guard on public.agreement_milestones;
create trigger agreement_milestones_guard before insert or update on public.agreement_milestones
  for each row execute function public.agreement_milestones_guard();

-- Pagos simulados: transiciones del pagador; 'refunded' solo desde el backend.
create or replace function public.payments_guard_update()
returns trigger language plpgsql set search_path = public as $$
begin
  if auth.uid() is not null and new.status is distinct from old.status then
    if not ((old.status = 'pending' and new.status in ('approved', 'rejected', 'held'))
         or (old.status in ('approved', 'held') and new.status = 'released')) then
      raise exception 'payment: transición % -> % no permitida', old.status, new.status using errcode = '23514';
    end if;
  end if;
  if new.status = 'released' and old.status <> 'released' then
    new.released_at := now();
  elsif auth.uid() is not null then
    new.released_at := old.released_at;
  end if;
  return new;
end;
$$;

drop trigger if exists payments_guard_update on public.payments;
create trigger payments_guard_update before update on public.payments
  for each row execute function public.payments_guard_update();

-- Cancelaciones: la contraparte aprueba o rechaza; 'refunded' solo desde el backend.
create or replace function public.cancellations_guard_update()
returns trigger language plpgsql set search_path = public as $$
begin
  if auth.uid() is not null and new.status is distinct from old.status then
    if not (old.status = 'requested' and new.status in ('approved', 'rejected')) then
      raise exception 'cancellation: transición % -> % no permitida', old.status, new.status using errcode = '23514';
    end if;
    if auth.uid() = old.requested_by then
      raise exception 'cancellation: la contraparte resuelve la solicitud' using errcode = '42501';
    end if;
  end if;
  if new.status is distinct from old.status and old.status = 'requested' then
    new.resolved_at := now();
  elsif auth.uid() is not null then
    new.resolved_at := old.resolved_at;
  end if;
  return new;
end;
$$;

drop trigger if exists cancellations_guard_update on public.cancellations;
create trigger cancellations_guard_update before update on public.cancellations
  for each row execute function public.cancellations_guard_update();

-- Cuenta de cobro: cambiar los datos bancarios vuelve a dejarla sin verificar.
create or replace function public.payout_accounts_guard_update()
returns trigger language plpgsql set search_path = public as $$
begin
  if auth.uid() is not null
     and (new.bank_name, new.account_type, new.account_number_last4, new.holder_name, new.document_number_last4)
         is distinct from (old.bank_name, old.account_type, old.account_number_last4, old.holder_name, old.document_number_last4) then
    new.verification_status := 'pending';
  end if;
  return new;
end;
$$;

drop trigger if exists payout_accounts_guard_update on public.payout_accounts;
create trigger payout_accounts_guard_update before update on public.payout_accounts
  for each row execute function public.payout_accounts_guard_update();

-- Mensajes: actualiza last_message_at de la conversación (no hay política de
-- update sobre conversations para los usuarios).
create or replace function public.messages_touch_conversation()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  update public.conversations set last_message_at = new.created_at
  where id = new.conversation_id;
  return new;
end;
$$;

revoke all on function public.messages_touch_conversation() from public, anon, authenticated;

drop trigger if exists messages_touch_conversation on public.messages;
create trigger messages_touch_conversation after insert on public.messages
  for each row execute function public.messages_touch_conversation();
