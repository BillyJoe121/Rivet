-- ==============================================================================
-- RIVET — SPRINT 3 · DATOS DEMO IDEMPOTENTES
-- Ejecutar en el SQL Editor de Supabase después de los 4 scripts schema_sprint3_*.sql
-- y después de haber registrado al usuario William en la app.
-- ==============================================================================

do $$
declare
  v_william_id uuid;
  v_carlos_id uuid := '11111111-1111-4111-8111-111111111101';
  v_carolina_id uuid := '11111111-1111-4111-8111-111111111102';
  v_laura_id uuid := '11111111-1111-4111-8111-111111111103';

  -- Proyectos de Laura (para William como contratista)
  v_proj_open_1 uuid := '22222222-2222-4222-8222-222222222201';
  v_proj_open_2 uuid := '22222222-2222-4222-8222-222222222202';
  v_proj_inprog_pro uuid := '22222222-2222-4222-8222-222222222203';
  v_proj_done_pro uuid := '22222222-2222-4222-8222-222222222204';

  -- Proyectos de William (como cliente)
  v_proj_cli_open uuid := '22222222-2222-4222-8222-222222222205';
  v_proj_cli_inprog uuid := '22222222-2222-4222-8222-222222222206';

  -- Propuestas
  v_prop_w_sent uuid := '33333333-3333-4333-8333-333333333301';
  v_prop_w_draft uuid := '33333333-3333-4333-8333-333333333302';
  v_prop_w_inprog uuid := '33333333-3333-4333-8333-333333333303';
  v_prop_w_done uuid := '33333333-3333-4333-8333-333333333304';
  v_prop_c1_recv uuid := '33333333-3333-4333-8333-333333333305';
  v_prop_c2_recv uuid := '33333333-3333-4333-8333-333333333306';
  v_prop_c1_inprog uuid := '33333333-3333-4333-8333-333333333307';

  -- Acuerdos y conversaciones
  v_agr_w_inprog uuid := '44444444-4444-4444-8444-444444444401';
  v_agr_w_done uuid := '44444444-4444-4444-8444-444444444402';
  v_agr_cli_inprog uuid := '44444444-4444-4444-8444-444444444403';

  v_conv_pro uuid := '55555555-5555-4555-8555-555555555501';
  v_conv_cli uuid := '55555555-5555-4555-8555-555555555502';
begin
  select id into v_william_id
  from public.profiles
  where lower(full_name) like '%william%' or lower(email) like '%william%'
  order by created_at asc
  limit 1;

  if v_william_id is null then
    raise exception 'No se encontró un perfil para William en public.profiles. Regístrate primero en la app.';
  end if;

  -- 1. Usuarios demo en auth.users (dispara on_auth_user_created -> profiles)
  insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
  values
    (v_carlos_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'carlos.mendoza@rivet.demo', '$2a$10$demoHashOnlyNotForLogin000000000000000000000000000', now(),
     '{"provider":"email","providers":["email"]}',
     '{"full_name":"Carlos Mendoza","role":"contractor","phone":"3105550101"}', now(), now()),
    (v_carolina_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'carolina.rivas@rivet.demo', '$2a$10$demoHashOnlyNotForLogin000000000000000000000000000', now(),
     '{"provider":"email","providers":["email"]}',
     '{"full_name":"Carolina Rivas & Equipo","role":"contractor","phone":"3105550102"}', now(), now()),
    (v_laura_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'laura.gomez@rivet.demo', '$2a$10$demoHashOnlyNotForLogin000000000000000000000000000', now(),
     '{"provider":"email","providers":["email"]}',
     '{"full_name":"Laura Gómez","role":"client","phone":"3105550103"}', now(), now())
  on conflict (id) do nothing;

  -- Fotos de perfil para contratistas y cliente demo
  update public.profiles set avatar_url = 'Fondos/pro-pintura-rivet.jpg' where id = v_carlos_id;
  update public.profiles set avatar_url = 'Fondos/pro-estuco-corona.jpg' where id = v_carolina_id;
  update public.profiles set avatar_url = 'Fondos/hero-living-room.jpg' where id = v_laura_id;

  -- 2. Proyectos (abiertos, en desarrollo y finalizados)
  insert into public.projects (id, client_id, title, description, city, neighborhood, status, budget_estimate_cop, photo_paths)
  values
    (v_proj_open_1, v_laura_id, 'Pintura sala y comedor Ciudad Jardín',
     'Resane con estuco plástico y dos manos de vinilo tipo 1 lavable en sala y comedor.',
     'Cali', 'Ciudad Jardín', 'open', 2400000, array['Fondos/hero-living-room.jpg', 'Fondos/hero-lounge.jpg']),
    (v_proj_open_2, v_laura_id, 'Acabado de fachada y hall de acceso',
     'Sellador acrílico y pintura exterior resistente a lluvia y sol.',
     'Cali', 'Pance', 'open', 3100000, array['Fondos/hero-lounge.jpg']),
    (v_proj_inprog_pro, v_laura_id, 'Remodelación apartamento Granada',
     'Estuco completo en 3 alcobas y pintura blanco mate.',
     'Cali', 'Granada', 'in_progress', 2850000, array['Fondos/hero-planning.jpg']),
    (v_proj_done_pro, v_laura_id, 'Estuco y pintura estudio El Ingenio',
     'Resane de fisuras y acabado satinado en estudio principal.',
     'Cali', 'El Ingenio', 'completed', 1650000, array['Fondos/hero-greenery.jpg']),
    (v_proj_cli_open, v_william_id, 'Pintura integral apartamento Valle del Lili',
     'Sala, comedor, corredor y 2 habitaciones con vinilo tipo 1.',
     'Cali', 'Valle del Lili', 'open', 2600000, array['Fondos/hero-living-room.jpg']),
    (v_proj_cli_inprog, v_william_id, 'Adecuación estudio y terraza Santa Teresita',
     'Impermeabilización liviana y pintura interior.',
     'Cali', 'Santa Teresita', 'in_progress', 1950000, array['Fondos/hero-lounge.jpg'])
  on conflict (id) do update set
    title = excluded.title,
    status = excluded.status,
    photo_paths = excluded.photo_paths;

  -- Espacios por proyecto
  insert into public.project_spaces (project_id, position, name, width_meters, height_meters, finish_type, has_defects)
  values
    (v_proj_open_1, 0, 'Sala principal', 6.5, 2.7, 'Vinilo Tipo 1', true),
    (v_proj_open_1, 1, 'Comedor', 4.2, 2.7, 'Vinilo Tipo 1', false),
    (v_proj_open_2, 0, 'Fachada frontal', 8.0, 3.2, 'Koraza Exterior', true),
    (v_proj_inprog_pro, 0, 'Alcoba principal', 5.0, 2.6, 'Estuco y Vinilo', false),
    (v_proj_cli_open, 0, 'Sala comedor', 7.0, 2.6, 'Vinilo Tipo 1', false),
    (v_proj_cli_inprog, 0, 'Estudio', 4.5, 2.6, 'Estuco plástico', true)
  on conflict do nothing;

  -- 3. Propuestas (enviadas/borrador/aceptadas de William + recibidas como cliente)
  insert into public.proposals (id, project_id, contractor_id, labor_cost_cop, materials_cost_cop, estimated_days, observations, status)
  values
    (v_prop_w_sent, v_proj_open_1, v_william_id, 1450000, 720000, 5, 'Incluye protección de pisos y resane completo.', 'sent'),
    (v_prop_w_draft, v_proj_open_2, v_william_id, 1900000, 950000, 6, 'Borrador inicial pendiente de ajustar andamio.', 'draft'),
    (v_prop_w_inprog, v_proj_inprog_pro, v_william_id, 1850000, 900000, 6, 'Entrega limpia con dos manos de vinilo.', 'accepted'),
    (v_prop_w_done, v_proj_done_pro, v_william_id, 1100000, 500000, 4, 'Obra entregada a satisfacción.', 'accepted'),
    (v_prop_c1_recv, v_proj_cli_open, v_carlos_id, 1550000, 820000, 5, 'Incluye estuco plástico y sellador.', 'sent'),
    (v_prop_c2_recv, v_proj_cli_open, v_carolina_id, 1700000, 800000, 4, 'Equipo de 3 pintores para entrega rápida.', 'sent'),
    (v_prop_c1_inprog, v_proj_cli_inprog, v_carlos_id, 1250000, 650000, 4, 'Materiales Bodega Rivet incluidos.', 'accepted')
  on conflict (id) do update set status = excluded.status;

  -- 4. Acuerdos (en desarrollo y finalizado)
  insert into public.agreements (id, project_id, proposal_id, client_id, contractor_id, labor_amount, materials_amount, total_amount, client_accepted_at, contractor_accepted_at, status)
  values
    (v_agr_w_inprog, v_proj_inprog_pro, v_prop_w_inprog, v_laura_id, v_william_id, 1850000, 900000, 2750000, now() - interval '3 days', now() - interval '3 days', 'active'),
    (v_agr_w_done, v_proj_done_pro, v_prop_w_done, v_laura_id, v_william_id, 1100000, 500000, 1600000, now() - interval '15 days', now() - interval '15 days', 'completed'),
    (v_agr_cli_inprog, v_proj_cli_inprog, v_prop_c1_inprog, v_william_id, v_carlos_id, 1250000, 650000, 1900000, now() - interval '2 days', now() - interval '2 days', 'active')
  on conflict (id) do nothing;

  -- Hitos mutuos
  insert into public.agreement_milestones (agreement_id, position, title, client_confirmed_at, contractor_confirmed_at)
  values
    (v_agr_w_inprog, 0, 'Hito 1 · Alistamiento, protección de pisos y resanes', now() - interval '2 days', now() - interval '2 days'),
    (v_agr_w_inprog, 1, 'Hito 2 · Aplicación de estuco plástico y lijado', null, now() - interval '1 day'),
    (v_agr_w_inprog, 2, 'Hito 3 · Dos manos de pintura y entrega limpia', null, null),
    (v_agr_w_done, 0, 'Hito 1 · Alistamiento y resanes', now() - interval '12 days', now() - interval '12 days'),
    (v_agr_w_done, 1, 'Hito 2 · Acabado final y entrega', now() - interval '10 days', now() - interval '10 days'),
    (v_agr_cli_inprog, 0, 'Hito 1 · Preparación de superficie', now() - interval '1 day', now() - interval '1 day'),
    (v_agr_cli_inprog, 1, 'Hito 2 · Pintura y entrega', null, null)
  on conflict (agreement_id, position) do nothing;

  -- Avances y pagos simulados
  insert into public.progress_updates (agreement_id, author_id, percent, description, status)
  values
    (v_agr_w_inprog, v_william_id, 45, 'Alistamiento completo y primera mano de estuco en alcoba principal.', 'sent'),
    (v_agr_cli_inprog, v_carlos_id, 50, 'Superficies resanadas y listas para pintura.', 'sent')
  on conflict do nothing;

  insert into public.payments (agreement_id, payer_id, kind, amount, status, card_brand, card_last4)
  values
    (v_agr_w_inprog, v_laura_id, 'advance', 1375000, 'held', 'Visa', '4242'),
    (v_agr_w_done, v_laura_id, 'advance', 800000, 'released', 'Visa', '4242'),
    (v_agr_cli_inprog, v_william_id, 'advance', 950000, 'held', 'Mastercard', '5544')
  on conflict do nothing;

  insert into public.ratings (agreement_id, rater_id, ratee_id, stars, review)
  values
    (v_agr_w_done, v_laura_id, v_william_id, 5, 'Excelente acabado y cumplimiento en los tiempos.')
  on conflict (agreement_id, rater_id) do nothing;

  -- 5. Conversaciones y notificaciones para William
  insert into public.conversations (id, project_id, client_id, contractor_id, last_message_at)
  values
    (v_conv_pro, v_proj_inprog_pro, v_laura_id, v_william_id, now() - interval '1 hour'),
    (v_conv_cli, v_proj_cli_open, v_william_id, v_carlos_id, now() - interval '30 minutes')
  on conflict (project_id, client_id, contractor_id) do nothing;

  insert into public.messages (conversation_id, sender_id, body, kind)
  values
    (v_conv_pro, v_laura_id, 'Hola William, ya confirmé el primer hito. ¿Mañana continúan con la segunda mano?', 'text'),
    (v_conv_cli, v_carlos_id, 'Hola William, envié mi propuesta para tu apartamento en Valle del Lili.', 'text')
  on conflict do nothing;

  insert into public.notifications (user_id, kind, title, body, project_id)
  values
    (v_william_id, 'proposal_received', 'Nuevas propuestas recibidas', 'Carlos Mendoza y Carolina Rivas cotizaron tu proyecto en Valle del Lili.', v_proj_cli_open),
    (v_william_id, 'project_milestone', 'Obra activa en Granada', 'Laura Gómez confirmó el Hito 1 de tu acuerdo.', v_proj_inprog_pro)
  on conflict do nothing;
end $$;
