-- ==============================================================================
-- RIVET — SPRINT 3 · 3/4 PERMISOS Y POLÍTICAS RLS
-- Aplicar después de schema_sprint3_functions.sql. Idempotente.
-- Regla general: RLS en todas las tablas, nada para anon, políticas por auth.uid()
-- y rol limitado a 'client' / 'contractor' (public.current_app_role()).
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 0. RLS y privilegios base (se parte de cero y se concede lo mínimo)
-- ------------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'projects', 'project_spaces', 'proposals', 'materials', 'agreements',
    'agreement_milestones', 'progress_updates', 'conversations', 'messages',
    'notifications', 'payments', 'payout_accounts', 'ratings', 'cancellations'
  ] loop
    execute format('alter table public.%I enable row level security', t);
    execute format('revoke all on table public.%I from anon, authenticated', t);
  end loop;
end $$;

grant select, insert, update, delete on public.projects to authenticated;
grant select, insert, update, delete on public.project_spaces to authenticated;
grant select, insert, update on public.proposals to authenticated;
grant select on public.materials to authenticated;
grant select, insert on public.agreements to authenticated;
grant update (status, client_accepted_at, contractor_accepted_at, labor_amount,
              materials_amount, total_amount, start_date, end_date) on public.agreements to authenticated;
grant select, insert, delete on public.agreement_milestones to authenticated;
grant update (title, position, client_confirmed_at, contractor_confirmed_at) on public.agreement_milestones to authenticated;
grant select, insert, delete on public.progress_updates to authenticated;
grant update (milestone_id, percent, description, photo_paths, status) on public.progress_updates to authenticated;
grant select, insert on public.conversations to authenticated;
grant select, insert on public.messages to authenticated;
grant update (read_at) on public.messages to authenticated;
grant select, insert on public.notifications to authenticated;
grant update (read_at) on public.notifications to authenticated;
grant select, insert on public.payments to authenticated;
grant update (status) on public.payments to authenticated;
grant select on public.payout_accounts to authenticated;
grant insert (contractor_id, bank_name, account_type, account_number_last4, holder_name,
              document_number_last4) on public.payout_accounts to authenticated;
grant update (bank_name, account_type, account_number_last4, holder_name,
              document_number_last4) on public.payout_accounts to authenticated;
grant select, insert on public.ratings to authenticated;
grant select, insert on public.cancellations to authenticated;
grant update (status) on public.cancellations to authenticated;

revoke all on public.contractor_rating_summary from anon;
grant select on public.contractor_rating_summary to authenticated;

-- ------------------------------------------------------------------------------
-- 1. profiles: el rol no se puede cambiar y el perfil solo lo crea el trigger
-- ------------------------------------------------------------------------------
create or replace view public.public_profiles as
  select id, full_name, role, avatar_url
  from public.profiles;

revoke all on public.public_profiles from anon;
grant select on public.public_profiles to authenticated;

revoke all on public.profiles from anon, authenticated;
grant select on public.profiles to authenticated;
grant update (full_name, phone, avatar_url, updated_at) on public.profiles to authenticated;

drop policy if exists "Users can insert their own profile" on public.profiles;

drop policy if exists "Users can update their own profile" on public.profiles;
create policy "Users can update their own profile" on public.profiles
  for update to authenticated
  using ((select auth.uid()) = id)
  with check ((select auth.uid()) = id and role = public.current_app_role());

-- ------------------------------------------------------------------------------
-- 2. projects y project_spaces
-- ------------------------------------------------------------------------------
drop policy if exists "Projects visible to owner, contractors (open) and agreement contractor" on public.projects;
create policy "Projects visible to owner, contractors (open) and agreement contractor" on public.projects
  for select to authenticated
  using (client_id = (select auth.uid())
         or (status = 'open' and public.current_app_role() = 'contractor')
         or public.is_project_agreement_contractor(id));

drop policy if exists "Clients create own projects" on public.projects;
create policy "Clients create own projects" on public.projects
  for insert to authenticated
  with check (client_id = (select auth.uid())
              and public.current_app_role() = 'client'
              and status in ('draft', 'open'));

drop policy if exists "Clients update own projects" on public.projects;
create policy "Clients update own projects" on public.projects
  for update to authenticated
  using (client_id = (select auth.uid()))
  with check (client_id = (select auth.uid()));

drop policy if exists "Clients delete own projects" on public.projects;
create policy "Clients delete own projects" on public.projects
  for delete to authenticated
  using (client_id = (select auth.uid()));

drop policy if exists "Spaces follow project visibility" on public.project_spaces;
create policy "Spaces follow project visibility" on public.project_spaces
  for select to authenticated
  using (exists (select 1 from public.projects p where p.id = project_spaces.project_id));

drop policy if exists "Project owner inserts spaces" on public.project_spaces;
create policy "Project owner inserts spaces" on public.project_spaces
  for insert to authenticated
  with check (public.is_project_owner(project_id));

drop policy if exists "Project owner updates spaces" on public.project_spaces;
create policy "Project owner updates spaces" on public.project_spaces
  for update to authenticated
  using (public.is_project_owner(project_id))
  with check (public.is_project_owner(project_id));

drop policy if exists "Project owner deletes spaces" on public.project_spaces;
create policy "Project owner deletes spaces" on public.project_spaces
  for delete to authenticated
  using (public.is_project_owner(project_id));

-- ------------------------------------------------------------------------------
-- 3. proposals (el trigger proposals_guard_update impide que el dueño del
--    proyecto cambie algo distinto del estado)
-- ------------------------------------------------------------------------------
drop policy if exists "Contractors insert own proposals on open projects" on public.proposals;
create policy "Contractors insert own proposals on open projects" on public.proposals
  for insert to authenticated
  with check (contractor_id = (select auth.uid())
              and public.current_app_role() = 'contractor'
              and status in ('draft', 'sent')
              and exists (select 1 from public.projects p
                          where p.id = proposals.project_id and p.status = 'open'));

drop policy if exists "Contractors view own proposals" on public.proposals;
create policy "Contractors view own proposals" on public.proposals
  for select to authenticated
  using (contractor_id = (select auth.uid()));

drop policy if exists "Contractors update own draft or sent proposals" on public.proposals;
create policy "Contractors update own draft or sent proposals" on public.proposals
  for update to authenticated
  using (contractor_id = (select auth.uid()) and status in ('draft', 'sent'))
  with check (contractor_id = (select auth.uid())
              and public.current_app_role() = 'contractor'
              and status in ('draft', 'sent', 'withdrawn'));

drop policy if exists "Project owners view received proposals" on public.proposals;
create policy "Project owners view received proposals" on public.proposals
  for select to authenticated
  using (status <> 'draft' and public.is_project_owner(project_id));

drop policy if exists "Project owners accept or reject sent proposals" on public.proposals;
create policy "Project owners accept or reject sent proposals" on public.proposals
  for update to authenticated
  using (status = 'sent' and public.is_project_owner(project_id))
  with check (status in ('accepted', 'rejected') and public.is_project_owner(project_id));

-- ------------------------------------------------------------------------------
-- 4. materials: catálogo de solo lectura
-- ------------------------------------------------------------------------------
drop policy if exists "Authenticated users read materials" on public.materials;
create policy "Authenticated users read materials" on public.materials
  for select to authenticated
  using (true);

-- ------------------------------------------------------------------------------
-- 5. agreements y agreement_milestones
-- ------------------------------------------------------------------------------
drop policy if exists "Agreement parties view agreements" on public.agreements;
create policy "Agreement parties view agreements" on public.agreements
  for select to authenticated
  using ((select auth.uid()) in (client_id, contractor_id));

drop policy if exists "Project client creates agreement from accepted proposal" on public.agreements;
create policy "Project client creates agreement from accepted proposal" on public.agreements
  for insert to authenticated
  with check (client_id = (select auth.uid())
              and public.current_app_role() = 'client'
              and public.is_project_owner(project_id)
              and status = 'pending'
              and contractor_accepted_at is null
              and exists (select 1 from public.proposals pr
                          where pr.id = agreements.proposal_id
                            and pr.project_id = agreements.project_id
                            and pr.contractor_id = agreements.contractor_id
                            and pr.status = 'accepted'));

drop policy if exists "Agreement parties update agreements" on public.agreements;
create policy "Agreement parties update agreements" on public.agreements
  for update to authenticated
  using ((select auth.uid()) in (client_id, contractor_id))
  with check ((select auth.uid()) in (client_id, contractor_id));

drop policy if exists "Agreement parties view milestones" on public.agreement_milestones;
create policy "Agreement parties view milestones" on public.agreement_milestones
  for select to authenticated
  using (public.agreement_role(agreement_id) is not null);

drop policy if exists "Agreement parties add milestones while pending" on public.agreement_milestones;
create policy "Agreement parties add milestones while pending" on public.agreement_milestones
  for insert to authenticated
  with check (public.agreement_role(agreement_id) is not null
              and exists (select 1 from public.agreements a
                          where a.id = agreement_milestones.agreement_id and a.status = 'pending'));

drop policy if exists "Agreement parties update milestones" on public.agreement_milestones;
create policy "Agreement parties update milestones" on public.agreement_milestones
  for update to authenticated
  using (public.agreement_role(agreement_id) is not null)
  with check (public.agreement_role(agreement_id) is not null);

drop policy if exists "Agreement parties delete milestones while pending" on public.agreement_milestones;
create policy "Agreement parties delete milestones while pending" on public.agreement_milestones
  for delete to authenticated
  using (public.agreement_role(agreement_id) is not null
         and exists (select 1 from public.agreements a
                     where a.id = agreement_milestones.agreement_id and a.status = 'pending'));

-- ------------------------------------------------------------------------------
-- 6. progress_updates: los publica el contratista; el cliente ve solo los enviados
-- ------------------------------------------------------------------------------
drop policy if exists "Parties view progress updates" on public.progress_updates;
create policy "Parties view progress updates" on public.progress_updates
  for select to authenticated
  using (author_id = (select auth.uid())
         or (status = 'sent' and public.agreement_role(agreement_id) is not null));

drop policy if exists "Contractor creates progress updates" on public.progress_updates;
create policy "Contractor creates progress updates" on public.progress_updates
  for insert to authenticated
  with check (author_id = (select auth.uid())
              and public.agreement_role(agreement_id) = 'contractor'
              and exists (select 1 from public.agreements a
                          where a.id = progress_updates.agreement_id and a.status = 'active')
              and (milestone_id is null
                   or exists (select 1 from public.agreement_milestones m
                              where m.id = progress_updates.milestone_id
                                and m.agreement_id = progress_updates.agreement_id)));

drop policy if exists "Contractor edits own draft progress updates" on public.progress_updates;
create policy "Contractor edits own draft progress updates" on public.progress_updates
  for update to authenticated
  using (author_id = (select auth.uid()) and status = 'draft')
  with check (author_id = (select auth.uid())
              and public.agreement_role(agreement_id) = 'contractor'
              and (milestone_id is null
                   or exists (select 1 from public.agreement_milestones m
                              where m.id = progress_updates.milestone_id
                                and m.agreement_id = progress_updates.agreement_id)));

drop policy if exists "Contractor deletes own draft progress updates" on public.progress_updates;
create policy "Contractor deletes own draft progress updates" on public.progress_updates
  for delete to authenticated
  using (author_id = (select auth.uid()) and status = 'draft');

-- ------------------------------------------------------------------------------
-- 7. conversations y messages: solo participantes
-- ------------------------------------------------------------------------------
drop policy if exists "Participants view conversations" on public.conversations;
create policy "Participants view conversations" on public.conversations
  for select to authenticated
  using ((select auth.uid()) in (client_id, contractor_id));

drop policy if exists "Participants start conversations" on public.conversations;
create policy "Participants start conversations" on public.conversations
  for insert to authenticated
  with check (
    (client_id = (select auth.uid())
     and public.current_app_role() = 'client'
     and public.is_project_owner(project_id)
     and exists (select 1 from public.public_profiles pp
                 where pp.id = conversations.contractor_id and pp.role = 'contractor'))
    or
    (contractor_id = (select auth.uid())
     and public.current_app_role() = 'contractor'
     and exists (select 1 from public.projects p
                 where p.id = conversations.project_id and p.client_id = conversations.client_id)));

drop policy if exists "Participants view messages" on public.messages;
create policy "Participants view messages" on public.messages
  for select to authenticated
  using (public.is_conversation_participant(conversation_id));

drop policy if exists "Participants send messages" on public.messages;
create policy "Participants send messages" on public.messages
  for insert to authenticated
  with check (sender_id = (select auth.uid())
              and public.is_conversation_participant(conversation_id)
              and kind in ('text', 'counter_offer')
              and read_at is null);

drop policy if exists "Recipient marks messages as read" on public.messages;
create policy "Recipient marks messages as read" on public.messages
  for update to authenticated
  using (public.is_conversation_participant(conversation_id) and sender_id <> (select auth.uid()))
  with check (public.is_conversation_participant(conversation_id) and sender_id <> (select auth.uid()));

-- ------------------------------------------------------------------------------
-- 8. notifications: cada usuario lee y marca las suyas. Inserción solo hacia la
--    otra parte de una relación existente (ver public.can_notify).
-- ------------------------------------------------------------------------------
drop policy if exists "Users view own notifications" on public.notifications;
create policy "Users view own notifications" on public.notifications
  for select to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists "Users mark own notifications as read" on public.notifications;
create policy "Users mark own notifications as read" on public.notifications
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "Parties notify the other party" on public.notifications;
create policy "Parties notify the other party" on public.notifications
  for insert to authenticated
  with check (public.can_notify(user_id, project_id) and read_at is null);

-- ------------------------------------------------------------------------------
-- 9. payments (simulados): los ven las partes; paga el cliente del acuerdo
-- ------------------------------------------------------------------------------
drop policy if exists "Agreement parties view payments" on public.payments;
create policy "Agreement parties view payments" on public.payments
  for select to authenticated
  using (public.agreement_role(agreement_id) is not null);

drop policy if exists "Agreement client pays" on public.payments;
create policy "Agreement client pays" on public.payments
  for insert to authenticated
  with check (payer_id = (select auth.uid())
              and public.agreement_role(agreement_id) = 'client'
              and status in ('pending', 'approved', 'rejected', 'held')
              and released_at is null
              and exists (select 1 from public.agreements a
                          where a.id = payments.agreement_id and a.status in ('pending', 'active')));

drop policy if exists "Payer updates own payment status" on public.payments;
create policy "Payer updates own payment status" on public.payments
  for update to authenticated
  using (payer_id = (select auth.uid()))
  with check (payer_id = (select auth.uid()));

-- ------------------------------------------------------------------------------
-- 10. payout_accounts: solo el contratista dueño
-- ------------------------------------------------------------------------------
drop policy if exists "Contractor views own payout account" on public.payout_accounts;
create policy "Contractor views own payout account" on public.payout_accounts
  for select to authenticated
  using (contractor_id = (select auth.uid()) and public.current_app_role() = 'contractor');

drop policy if exists "Contractor creates own payout account" on public.payout_accounts;
create policy "Contractor creates own payout account" on public.payout_accounts
  for insert to authenticated
  with check (contractor_id = (select auth.uid())
              and public.current_app_role() = 'contractor'
              and verification_status = 'pending');

drop policy if exists "Contractor updates own payout account" on public.payout_accounts;
create policy "Contractor updates own payout account" on public.payout_accounts
  for update to authenticated
  using (contractor_id = (select auth.uid()) and public.current_app_role() = 'contractor')
  with check (contractor_id = (select auth.uid()) and public.current_app_role() = 'contractor');

-- ------------------------------------------------------------------------------
-- 11. ratings: una por parte, a la otra parte, con el acuerdo terminado
-- ------------------------------------------------------------------------------
drop policy if exists "Agreement parties view ratings" on public.ratings;
create policy "Agreement parties view ratings" on public.ratings
  for select to authenticated
  using (public.agreement_role(agreement_id) is not null);

drop policy if exists "Party rates the other party after completion" on public.ratings;
create policy "Party rates the other party after completion" on public.ratings
  for insert to authenticated
  with check (rater_id = (select auth.uid())
              and exists (select 1 from public.agreements a
                          where a.id = ratings.agreement_id
                            and a.status = 'completed'
                            and ((a.client_id = (select auth.uid()) and a.contractor_id = ratings.ratee_id)
                              or (a.contractor_id = (select auth.uid()) and a.client_id = ratings.ratee_id))));

-- ------------------------------------------------------------------------------
-- 12. cancellations: cualquiera de las partes solicita; la otra resuelve
--     (trigger cancellations_guard_update)
-- ------------------------------------------------------------------------------
drop policy if exists "Agreement parties view cancellations" on public.cancellations;
create policy "Agreement parties view cancellations" on public.cancellations
  for select to authenticated
  using (public.agreement_role(agreement_id) is not null);

drop policy if exists "Agreement party requests cancellation" on public.cancellations;
create policy "Agreement party requests cancellation" on public.cancellations
  for insert to authenticated
  with check (requested_by = (select auth.uid())
              and public.agreement_role(agreement_id) is not null
              and status = 'requested'
              and resolved_at is null
              and exists (select 1 from public.agreements a
                          where a.id = cancellations.agreement_id and a.status in ('pending', 'active')));

drop policy if exists "Agreement parties resolve cancellations" on public.cancellations;
create policy "Agreement parties resolve cancellations" on public.cancellations
  for update to authenticated
  using (public.agreement_role(agreement_id) is not null and status = 'requested')
  with check (public.agreement_role(agreement_id) is not null);
