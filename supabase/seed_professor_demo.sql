-- ==============================================================================
-- RIVET — DATOS DEMO IDEMPOTENTES PARA USUARIO DUAL DEL PROFESOR
-- Ejecutar en el SQL Editor de Supabase después de los 4 scripts schema_sprint3_*.sql
-- y después de crear la cuenta del profesor en Supabase Auth o en la app.
--
-- INSTRUCCIONES:
-- 1. Crea la cuenta del profesor en Supabase Auth (Authentication -> Users -> Add user)
--    o regístrala desde la app (recomendado rol inicial: 'contractor').
-- 2. Ajusta v_prof_email y v_prof_name abajo con el correo y nombre reales.
-- 3. Ejecuta este script completo. Es 100% idempotente y NO toca los datos de William.
-- ==============================================================================

do $$
declare
  -- Ajustar antes de ejecutar si usas otro correo o nombre para el profesor:
v_prof_email text := 'profesor@rivet.com';
v_prof_name  text := 'Nombre del Profesor';
  v_prof_id uuid;

  -- Contrapartes demo (reutiliza las de Sprint 3 y añade un segundo cliente)
  v_carlos_id   uuid := '11111111-1111-4111-8111-111111111101';
  v_carolina_id uuid := '11111111-1111-4111-8111-111111111102';
  v_laura_id    uuid := '11111111-1111-4111-8111-111111111103';
  v_mateo_id    uuid := '11111111-1111-4111-8111-111111111104';

  -- Proyectos abiertos visibles para el profesor como Contratista (de Laura y Mateo)
  v_p_pro_open_1  uuid := 'b2222222-2222-4222-8222-222222222201';
  v_p_pro_open_2  uuid := 'b2222222-2222-4222-8222-222222222202';
  v_p_pro_inprog  uuid := 'b2222222-2222-4222-8222-222222222203';
  v_p_pro_done    uuid := 'b2222222-2222-4222-8222-222222222204';

  -- Proyectos creados por el profesor como Cliente
  v_p_cli_open_1  uuid := 'b2222222-2222-4222-8222-222222222205';
  v_p_cli_open_2  uuid := 'b2222222-2222-4222-8222-222222222206';
  v_p_cli_inprog  uuid := 'b2222222-2222-4222-8222-222222222207';
  v_p_cli_done    uuid := 'b2222222-2222-4222-8222-222222222208';

  -- Propuestas (como Contratista y recibidas como Cliente)
  v_prop_pro_sent    uuid := 'b3333333-3333-4333-8333-333333333301';
  v_prop_pro_draft   uuid := 'b3333333-3333-4333-8333-333333333302';
  v_prop_pro_inprog  uuid := 'b3333333-3333-4333-8333-333333333303';
  v_prop_pro_done    uuid := 'b3333333-3333-4333-8333-333333333304';
  v_prop_cli_c1_o1   uuid := 'b3333333-3333-4333-8333-333333333305';
  v_prop_cli_c2_o1   uuid := 'b3333333-3333-4333-8333-333333333306';
  v_prop_cli_c1_o2   uuid := 'b3333333-3333-4333-8333-333333333307';
  v_prop_cli_inprog  uuid := 'b3333333-3333-4333-8333-333333333308';
  v_prop_cli_done    uuid := 'b3333333-3333-4333-8333-333333333309';

  -- Acuerdos
  v_agr_pro_inprog uuid := 'b4444444-4444-4444-8444-444444444401';
  v_agr_pro_done   uuid := 'b4444444-4444-4444-8444-444444444402';
  v_agr_cli_inprog uuid := 'b4444444-4444-4444-8444-444444444403';
  v_agr_cli_done   uuid := 'b4444444-4444-4444-8444-444444444404';

  -- Conversaciones (2 como Contratista + 2 como Cliente)
  v_conv_pro_laura uuid := 'b5555555-5555-4555-8555-555555555501';
  v_conv_pro_mateo uuid := 'b5555555-5555-4555-8555-555555555502';
  v_conv_cli_car   uuid := 'b5555555-5555-4555-8555-555555555503';
  v_conv_cli_caro  uuid := 'b5555555-5555-4555-8555-555555555504';
begin
  select id into v_prof_id
  from public.profiles
  where lower(email) = lower(v_prof_email)
  limit 1;

  if v_prof_id is null then
    raise exception 'No se encontró un perfil para "%" en public.profiles. Crea primero la cuenta en Auth o regístrate en la app.', v_prof_email;
  end if;

  -- Asegura nombre visible y rol base 'contractor' (permite ver oportunidades abiertas
  -- como Contratista y consultar sus proyectos/propuestas/acuerdos propios como Cliente).
  update public.profiles
  set full_name = v_prof_name,
      role = 'contractor',
      phone = case when phone = '' then '3155550199' else phone end,
      updated_at = now()
  where id = v_prof_id;

  -- 1. Contrapartes demo en auth.users (dispara on_auth_user_created -> profiles)
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
     '{"full_name":"Laura Gómez","role":"client","phone":"3105550103"}', now(), now()),
    (v_mateo_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
     'mateo.salazar@rivet.demo', '$2a$10$demoHashOnlyNotForLogin000000000000000000000000000', now(),
     '{"provider":"email","providers":["email"]}',
     '{"full_name":"Mateo Salazar","role":"client","phone":"3105550104"}', now(), now())
  on conflict (id) do nothing;

  update public.profiles set avatar_url = 'Fondos/pro-pintura-rivet.jpg' where id = v_carlos_id;
  update public.profiles set avatar_url = 'Fondos/pro-estuco-corona.jpg' where id = v_carolina_id;
  update public.profiles set avatar_url = 'Fondos/hero-living-room.jpg' where id = v_laura_id;
  update public.profiles set avatar_url = 'Fondos/hero-planning.jpg' where id = v_mateo_id;

  -- 2. Proyectos visibles (para Contratista) + Proyectos creados (como Cliente)
  insert into public.projects (id, client_id, title, description, city, neighborhood, status, budget_estimate_cop, photo_paths)
  values
    -- Proyectos de otros clientes (visibles para el profesor como Contratista)
    (v_p_pro_open_1, v_mateo_id, 'Pintura sala y biblioteca San Fernando',
     'Estuco plástico en muros con humedad leve y dos manos de vinilo tipo 1 blanco hueso.',
     'Cali', 'San Fernando', 'open', 2550000, array['Fondos/hero-living-room.jpg', 'Fondos/hero-lounge.jpg']),
    (v_p_pro_open_2, v_mateo_id, 'Acabado de terraza y pérgola El Peñón',
     'Sellador acrílico e impermeabilización exterior con pintura lavable.',
     'Cali', 'El Peñón', 'open', 3300000, array['Fondos/hero-lounge.jpg']),
    (v_p_pro_inprog, v_laura_id, 'Renovación interior apartamento Versalles',
     'Resane general, guardaescobas y pintura satinada en sala y 2 alcobas.',
     'Cali', 'Versalles', 'in_progress', 2900000, array['Fondos/hero-planning.jpg']),
    (v_p_pro_done, v_mateo_id, 'Estuco y acabado estudio Centenario',
     'Nivelación de muros y pintura blanco mate de alta cobertura.',
     'Cali', 'Centenario', 'completed', 1750000, array['Fondos/hero-greenery.jpg']),

    -- Proyectos creados por el profesor (visibles en modo Cliente)
    (v_p_cli_open_1, v_prof_id, 'Pintura apartamento residencial Pance',
     'Sala, comedor y estudio principal con vinilo tipo 1 lavable y protección de pisos.',
     'Cali', 'Pance', 'open', 2750000, array['Fondos/hero-living-room.jpg', 'Fondos/hero-lounge.jpg']),
    (v_p_cli_open_2, v_prof_id, 'Estuco y pintura alcobas Ciudad Jardín',
     'Corrección de fisuras en dos habitaciones y aplicación de sellador acrílico.',
     'Cali', 'Ciudad Jardín', 'open', 2100000, array['Fondos/hero-planning.jpg']),
    (v_p_cli_inprog, v_prof_id, 'Remodelación estudio y hall Santa Rita',
     'Estuco plástico completo y dos manos de pintura mate lavable.',
     'Cali', 'Santa Rita', 'in_progress', 2400000, array['Fondos/hero-lounge.jpg']),
    (v_p_cli_done, v_prof_id, 'Acabado oficina principal El Ingenio',
     'Resane fino y acabado satinado en área de trabajo.',
     'Cali', 'El Ingenio', 'completed', 1800000, array['Fondos/hero-greenery.jpg'])
  on conflict (id) do update set
    title = excluded.title,
    description = excluded.description,
    status = excluded.status,
    photo_paths = excluded.photo_paths;

  -- Espacios de cada proyecto (idempotente por project_id + position)
  insert into public.project_spaces (id, project_id, position, name, width_meters, height_meters, finish_type, has_defects)
  values
    ('b6666666-6666-4666-8666-666666666601', v_p_pro_open_1, 0, 'Sala principal', 6.2, 2.7, 'Vinilo Tipo 1', true),
    ('b6666666-6666-4666-8666-666666666602', v_p_pro_open_1, 1, 'Biblioteca', 3.8, 2.7, 'Vinilo Tipo 1', false),
    ('b6666666-6666-4666-8666-666666666603', v_p_pro_open_2, 0, 'Terraza cubierta', 7.5, 3.0, 'Koraza Exterior', true),
    ('b6666666-6666-4666-8666-666666666604', v_p_pro_inprog, 0, 'Sala comedor', 6.8, 2.6, 'Estuco y Vinilo', false),
    ('b6666666-6666-4666-8666-666666666605', v_p_pro_done,   0, 'Estudio', 4.4, 2.6, 'Vinilo Tipo 1', false),
    ('b6666666-6666-4666-8666-666666666606', v_p_cli_open_1, 0, 'Sala comedor', 7.2, 2.7, 'Vinilo Tipo 1', false),
    ('b6666666-6666-4666-8666-666666666607', v_p_cli_open_1, 1, 'Estudio principal', 4.0, 2.7, 'Estuco plástico', true),
    ('b6666666-6666-4666-8666-666666666608', v_p_cli_open_2, 0, 'Alcoba principal', 5.1, 2.6, 'Vinilo Tipo 1', true),
    ('b6666666-6666-4666-8666-666666666609', v_p_cli_inprog, 0, 'Estudio y hall', 5.4, 2.6, 'Estuco y Vinilo', false),
    ('b6666666-6666-4666-8666-666666666610', v_p_cli_done,   0, 'Oficina', 4.6, 2.6, 'Satinado Lavable', false)
  on conflict (id) do nothing;

  -- 3. Propuestas (enviadas/borrador/aceptadas como Contratista + recibidas como Cliente)
  insert into public.proposals (id, project_id, contractor_id, labor_cost_cop, materials_cost_cop, estimated_days, observations, status)
  values
    -- Como Contratista
    (v_prop_pro_sent,   v_p_pro_open_1, v_prof_id, 1520000, 780000, 5, 'Incluye protección de mobiliario, resane con estuco plástico y 2 manos de vinilo.', 'sent'),
    (v_prop_pro_draft,  v_p_pro_open_2, v_prof_id, 1980000, 990000, 6, 'Borrador inicial pendiente de confirmar metraje de pérgola.', 'draft'),
    (v_prop_pro_inprog, v_p_pro_inprog, v_prof_id, 1850000, 920000, 6, 'Entrega limpia con recubrimiento completo en sala y alcobas.', 'accepted'),
    (v_prop_pro_done,   v_p_pro_done,   v_prof_id, 1150000, 540000, 4, 'Obra entregada a satisfacción y sin pendientes.', 'accepted'),

    -- Como Cliente (propuestas recibidas para sus proyectos)
    (v_prop_cli_c1_o1,  v_p_cli_open_1, v_carlos_id,   1600000, 840000, 5, 'Incluye estuco plástico, lija fina y sellador acrílico.', 'sent'),
    (v_prop_cli_c2_o1,  v_p_cli_open_1, v_carolina_id, 1740000, 810000, 4, 'Equipo de 3 pintores para entrega rápida en 4 días.', 'sent'),
    (v_prop_cli_c1_o2,  v_p_cli_open_2, v_carlos_id,   1280000, 650000, 4, 'Materiales Bodega Rivet incluidos y limpieza final.', 'sent'),
    (v_prop_cli_inprog, v_p_cli_inprog, v_carolina_id, 1480000, 760000, 5, 'Incluye protección de pisos y retoques finales.', 'accepted'),
    (v_prop_cli_done,   v_p_cli_done,   v_carlos_id,   1120000, 560000, 4, 'Acabado satinado lavable con garantía de 6 meses.', 'accepted')
  on conflict (id) do update set status = excluded.status;

  -- 4. Acuerdos en desarrollo y finalizados para ambos roles
  insert into public.agreements (id, project_id, proposal_id, client_id, contractor_id, labor_amount, materials_amount, total_amount, client_accepted_at, contractor_accepted_at, status)
  values
    (v_agr_pro_inprog, v_p_pro_inprog, v_prop_pro_inprog, v_laura_id, v_prof_id,     1850000, 920000, 2770000, now() - interval '4 days',  now() - interval '4 days',  'active'),
    (v_agr_pro_done,   v_p_pro_done,   v_prop_pro_done,   v_mateo_id, v_prof_id,     1150000, 540000, 1690000, now() - interval '18 days', now() - interval '18 days', 'completed'),
    (v_agr_cli_inprog, v_p_cli_inprog, v_prop_cli_inprog, v_prof_id,  v_carolina_id, 1480000, 760000, 2240000, now() - interval '3 days',  now() - interval '3 days',  'active'),
    (v_agr_cli_done,   v_p_cli_done,   v_prop_cli_done,   v_prof_id,  v_carlos_id,   1120000, 560000, 1680000, now() - interval '14 days', now() - interval '14 days', 'completed')
  on conflict (id) do nothing;

  -- Hitos mutuos: el trigger BEFORE INSERT limpia confirmaciones al insertar,
  -- así que se insertan primero y luego se actualizan los hitos confirmados.
  insert into public.agreement_milestones (agreement_id, position, title)
  values
    (v_agr_pro_inprog, 0, 'Hito 1 · Alistamiento, protección de pisos y resanes'),
    (v_agr_pro_inprog, 1, 'Hito 2 · Aplicación de estuco plástico y lijado'),
    (v_agr_pro_inprog, 2, 'Hito 3 · Dos manos de vinilo y entrega final'),
    (v_agr_pro_done,   0, 'Hito 1 · Preparación de muros y estuco'),
    (v_agr_pro_done,   1, 'Hito 2 · Pintura mate y entrega limpia'),
    (v_agr_cli_inprog, 0, 'Hito 1 · Protección de áreas y resane inicial'),
    (v_agr_cli_inprog, 1, 'Hito 2 · Pintura de estudio y hall'),
    (v_agr_cli_inprog, 2, 'Hito 3 · Revisión conjunta y entrega'),
    (v_agr_cli_done,   0, 'Hito 1 · Alistamiento y sellador'),
    (v_agr_cli_done,   1, 'Hito 2 · Acabado satinado y entrega')
  on conflict (agreement_id, position) do nothing;

  update public.agreement_milestones
  set client_confirmed_at = now() - interval '2 days',
      contractor_confirmed_at = now() - interval '2 days'
  where (agreement_id = v_agr_pro_inprog and position = 0)
     or (agreement_id = v_agr_cli_inprog and position = 0);

  update public.agreement_milestones
  set contractor_confirmed_at = now() - interval '1 day'
  where agreement_id = v_agr_pro_inprog and position = 1;

  update public.agreement_milestones
  set client_confirmed_at = now() - interval '1 day'
  where agreement_id = v_agr_cli_inprog and position = 1;

  update public.agreement_milestones
  set client_confirmed_at = now() - interval '10 days',
      contractor_confirmed_at = now() - interval '10 days'
  where agreement_id in (v_agr_pro_done, v_agr_cli_done);

  -- Avances de obra (idempotente por ID fijo)
  insert into public.progress_updates (id, agreement_id, author_id, percent, description, status)
  values
    ('b7777777-7777-4777-8777-777777777701', v_agr_pro_inprog, v_prof_id,     48, 'Alistamiento completo y primera mano de estuco aplicada en sala y alcobas.', 'sent'),
    ('b7777777-7777-4777-8777-777777777702', v_agr_cli_inprog, v_carolina_id, 55, 'Muros resanados, lijados e imprimados; listos para la primera mano de vinilo.', 'sent')
  on conflict (id) do nothing;

  -- Pagos simulados (respeta payments_one_effective_per_kind_idx)
  insert into public.payments (agreement_id, payer_id, kind, amount, status, card_brand, card_last4)
  select v_agr_pro_inprog, v_laura_id, 'advance', 1385000, 'held', 'Visa', '4242'
  where not exists (select 1 from public.payments where agreement_id = v_agr_pro_inprog and kind = 'advance');

  insert into public.payments (agreement_id, payer_id, kind, amount, status, card_brand, card_last4)
  select v_agr_pro_done, v_mateo_id, 'advance', 845000, 'released', 'Visa', '4242'
  where not exists (select 1 from public.payments where agreement_id = v_agr_pro_done and kind = 'advance');

  insert into public.payments (agreement_id, payer_id, kind, amount, status, card_brand, card_last4)
  select v_agr_cli_inprog, v_prof_id, 'advance', 1120000, 'held', 'Mastercard', '5544'
  where not exists (select 1 from public.payments where agreement_id = v_agr_cli_inprog and kind = 'advance');

  insert into public.payments (agreement_id, payer_id, kind, amount, status, card_brand, card_last4)
  select v_agr_cli_done, v_prof_id, 'advance', 840000, 'released', 'Mastercard', '5544'
  where not exists (select 1 from public.payments where agreement_id = v_agr_cli_done and kind = 'advance');

  -- Cuenta de cobro del profesor como Contratista
  insert into public.payout_accounts (contractor_id, bank_name, account_type, account_number_last4, holder_name, document_number_last4, verification_status)
  values (v_prof_id, 'Bancolombia', 'ahorros', '4821', v_prof_name, '9012', 'verified')
  on conflict (contractor_id) do update set
    holder_name = excluded.holder_name,
    verification_status = 'verified';

  -- Calificaciones mutuas en acuerdos terminados
  insert into public.ratings (agreement_id, rater_id, ratee_id, stars, review)
  values
    (v_agr_pro_done, v_mateo_id, v_prof_id,   5, 'Trabajo impecable, muy puntual con los tiempos y acabados limpios.'),
    (v_agr_cli_done, v_prof_id,  v_carlos_id, 5, 'Excelente ejecución en la oficina y muy buena comunicación.')
  on conflict (agreement_id, rater_id) do nothing;

  -- 5. Conversaciones bidireccionales (personas que le escribieron y a quienes escribió)
  insert into public.conversations (id, project_id, client_id, contractor_id, last_message_at)
  values
    (v_conv_pro_laura, v_p_pro_inprog, v_laura_id, v_prof_id,     now() - interval '25 minutes'),
    (v_conv_pro_mateo, v_p_pro_open_1, v_mateo_id, v_prof_id,     now() - interval '1 hour'),
    (v_conv_cli_car,   v_p_cli_open_1, v_prof_id,  v_carlos_id,   now() - interval '15 minutes'),
    (v_conv_cli_caro,  v_p_cli_inprog, v_prof_id,  v_carolina_id, now() - interval '45 minutes')
  on conflict (project_id, client_id, contractor_id) do nothing;

  insert into public.messages (id, conversation_id, sender_id, body, kind, counter_offer_amount, read_at, created_at)
  values
    -- Hilo 1 (Contratista <-> Laura Gómez): mensajes enviados y recibidos
    ('b8888888-8888-4888-8888-888888888801', v_conv_pro_laura, v_laura_id, 'Hola, ya confirmé el primer hito de Versalles. ¿Cómo vieron las paredes de la sala?', 'text', null, now() - interval '3 hours', now() - interval '3 hours'),
    ('b8888888-8888-4888-8888-888888888802', v_conv_pro_laura, v_prof_id,  'Hola Laura, quedaron muy parejas con el estuco. Mañana arrancamos la primera mano de pintura.', 'text', null, now() - interval '2 hours', now() - interval '2 hours'),
    ('b8888888-8888-4888-8888-888888888803', v_conv_pro_laura, v_laura_id, 'Perfecto, quedo atenta a las fotos del avance en la tarde.', 'text', null, null, now() - interval '25 minutes'),

    -- Hilo 2 (Contratista <-> Mateo Salazar): incluye contraoferta enviada por el cliente
    ('b8888888-8888-4888-8888-888888888804', v_conv_pro_mateo, v_prof_id,  'Hola Mateo, envié mi propuesta para San Fernando con materiales tipo 1 incluidos.', 'text', null, now() - interval '4 hours', now() - interval '4 hours'),
    ('b8888888-8888-4888-8888-888888888805', v_conv_pro_mateo, v_mateo_id, 'Gracias por cotizar. ¿Podríamos ajustar el valor total si aporto el vinilo base?', 'counter_offer', 2100000, null, now() - interval '1 hour'),

    -- Hilo 3 (Cliente <-> Carlos Mendoza): mensajes enviados, recibidos y contraoferta
    ('b8888888-8888-4888-8888-888888888806', v_conv_cli_car,   v_carlos_id, 'Hola, acabo de enviar mi cotización para el apartamento en Pance. Puedo visitar mañana.', 'text', null, now() - interval '2 hours', now() - interval '2 hours'),
    ('b8888888-8888-4888-8888-888888888807', v_conv_cli_car,   v_prof_id,   'Hola Carlos, revisé tu desglose. ¿El estuco plástico cubre también el estudio principal?', 'text', null, now() - interval '50 minutes', now() - interval '50 minutes'),
    ('b8888888-8888-4888-8888-888888888808', v_conv_cli_car,   v_carlos_id, 'Sí señor, incluye sala, comedor y estudio principal con protección de pisos.', 'text', null, null, now() - interval '15 minutes'),

    -- Hilo 4 (Cliente <-> Carolina Rivas & Equipo)
    ('b8888888-8888-4888-8888-888888888809', v_conv_cli_caro,  v_prof_id,     'Hola Carolina, ¿a qué hora llegan mañana al estudio de Santa Rita?', 'text', null, now() - interval '90 minutes', now() - interval '90 minutes'),
    ('b8888888-8888-4888-8888-888888888810', v_conv_cli_caro,  v_carolina_id, 'Estaremos a las 8:00 a. m. con todo el equipo y los insumos de Bodega Rivet.', 'text', null, null, now() - interval '45 minutes')
  on conflict (id) do nothing;

  -- 6. Notificaciones para ambos roles
  insert into public.notifications (id, user_id, kind, title, body, project_id)
  values
    ('b9999999-9999-4999-8999-999999999901', v_prof_id, 'proposal_received', 'Nuevas propuestas en Pance', 'Carlos Mendoza y Carolina Rivas cotizaron tu proyecto en Pance.', v_p_cli_open_1),
    ('b9999999-9999-4999-8999-999999999902', v_prof_id, 'proposal_received', 'Nueva cotización en Ciudad Jardín', 'Carlos Mendoza envió una propuesta para tus alcobas.', v_p_cli_open_2),
    ('b9999999-9999-4999-8999-999999999903', v_prof_id, 'project_milestone', 'Hito confirmado en Versalles', 'Laura Gómez confirmó el Hito 1 de tu obra activa.', v_p_pro_inprog),
    ('b9999999-9999-4999-8999-999999999904', v_prof_id, 'counter_offer', 'Contraoferta en San Fernando', 'Mateo Salazar propuso ajustar el presupuesto en el chat.', v_p_pro_open_1)
  on conflict (id) do nothing;
end $$;
