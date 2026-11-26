-- =========================================================
-- BLOQUE 1: TABLAS
-- =========================================================

create table public.perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre_completo text not null,
  correo text not null,
  rol text not null default 'solicitante'
    check (rol in ('solicitante', 'tecnico', 'administrador')),
  creado_en timestamptz not null default now()
);

create table public.tickets (
  id uuid primary key default gen_random_uuid(),
  titulo text not null
    check (char_length(titulo) between 5 and 80),
  descripcion text not null
    check (char_length(descripcion) between 10 and 500),
  categoria text not null
    check (categoria in ('computadora', 'proyector', 'red_wifi', 'impresora', 'software', 'otro')),
  prioridad text not null default 'media'
    check (prioridad in ('baja', 'media', 'alta')),
  ubicacion text not null
    check (char_length(ubicacion) between 3 and 80),
  estado text not null default 'pendiente'
    check (estado in ('pendiente', 'asignado', 'en_proceso', 'resuelto')),
  creado_por uuid not null references public.perfiles(id),
  asignado_a uuid references public.perfiles(id),
  creado_en timestamptz not null default now(),
  actualizado_en timestamptz not null default now(),
  -- Coherencia: pendiente = sin técnico; cualquier otro estado = con técnico
  constraint ticket_estado_y_tecnico_coherentes check (
    (estado = 'pendiente' and asignado_a is null)
    or (estado <> 'pendiente' and asignado_a is not null)
  )
);

create index indice_tickets_creado_por on public.tickets (creado_por);
create index indice_tickets_asignado_a on public.tickets (asignado_a);
create index indice_tickets_estado on public.tickets (estado);

-- =========================================================
-- BLOQUE 2: FUNCIONES Y TRIGGERS
-- =========================================================

-- 2.1 Devuelve el rol del usuario que tiene la sesión abierta.
create or replace function public.obtener_rol_actual()
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select rol from public.perfiles where id = auth.uid();
$$;

revoke all on function public.obtener_rol_actual() from public, anon;
grant execute on function public.obtener_rol_actual() to authenticated;

-- 2.2 Al crearse un usuario en Auth, se crea su perfil como SOLICITANTE.
-- (Nunca se toma el rol desde la app: así nadie puede elegirse técnico o admin.)
create or replace function public.crear_perfil_al_registrar_usuario()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.perfiles (id, nombre_completo, correo)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data->>'nombre_completo', ''), split_part(new.email, '@', 1)),
    new.email
  );
  return new;
end;
$$;

revoke all on function public.crear_perfil_al_registrar_usuario() from public, anon, authenticated;

create trigger al_crear_usuario
  after insert on auth.users
  for each row execute function public.crear_perfil_al_registrar_usuario();

-- 2.3 Al actualizar un ticket: guarda la fecha y valida el flujo de estados.
create or replace function public.validar_actualizacion_ticket()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.actualizado_en := now();

  -- Si se edita desde el panel de Supabase (sin sesión de usuario), se permite.
  if auth.uid() is null then
    return new;
  end if;

  if old.estado <> new.estado then
    if not (
      (old.estado = 'pendiente'  and new.estado = 'asignado')   or
      (old.estado = 'asignado'   and new.estado = 'en_proceso') or
      (old.estado = 'en_proceso' and new.estado = 'resuelto')
    ) then
      raise exception 'Cambio de estado no permitido: de % a %', old.estado, new.estado;
    end if;
  end if;

  return new;
end;
$$;

create trigger antes_de_actualizar_ticket
  before update on public.tickets
  for each row execute function public.validar_actualizacion_ticket();

  -- =========================================================
-- BLOQUE 3: PERMISOS Y SEGURIDAD (RLS)
-- =========================================================

-- 3.1 Privilegios mínimos. El usuario anónimo no accede a nada.
revoke all on public.perfiles from anon, authenticated;
revoke all on public.tickets  from anon, authenticated;

grant select on public.perfiles to authenticated;
grant select on public.tickets  to authenticated;

-- El solicitante solo puede escribir estas columnas al crear:
grant insert (titulo, descripcion, categoria, prioridad, ubicacion, creado_por)
  on public.tickets to authenticated;

-- El técnico solo puede modificar estas dos columnas:
grant update (estado, asignado_a) on public.tickets to authenticated;

-- 3.2 Activar RLS
alter table public.perfiles enable row level security;
alter table public.tickets  enable row level security;

-- 3.3 Políticas de PERFILES (solo lectura desde la app)
create policy "perfiles_ver_el_propio"
  on public.perfiles for select to authenticated
  using (id = (select auth.uid()));

create policy "perfiles_ver_todos_si_es_personal"
  on public.perfiles for select to authenticated
  using ((select public.obtener_rol_actual()) in ('tecnico', 'administrador'));

create policy "perfiles_ver_tecnico_asignado_a_mis_tickets"
  on public.perfiles for select to authenticated
  using (
    exists (
      select 1 from public.tickets t
      where t.creado_por = (select auth.uid())
        and t.asignado_a = perfiles.id
    )
  );

-- 3.4 Políticas de TICKETS
create policy "tickets_solicitante_ve_los_suyos"
  on public.tickets for select to authenticated
  using (creado_por = (select auth.uid()));

create policy "tickets_administrador_ve_todos"
  on public.tickets for select to authenticated
  using ((select public.obtener_rol_actual()) = 'administrador');

create policy "tickets_tecnico_ve_pendientes_y_los_suyos"
  on public.tickets for select to authenticated
  using (
    (select public.obtener_rol_actual()) = 'tecnico'
    and (
      (estado = 'pendiente' and asignado_a is null)
      or asignado_a = (select auth.uid())
    )
  );

create policy "tickets_solicitante_crea_los_suyos"
  on public.tickets for insert to authenticated
  with check (
    creado_por = (select auth.uid())
    and (select public.obtener_rol_actual()) = 'solicitante'
  );

create policy "tickets_tecnico_atiende"
  on public.tickets for update to authenticated
  using (
    (select public.obtener_rol_actual()) = 'tecnico'
    and (
      (estado = 'pendiente' and asignado_a is null)
      or asignado_a = (select auth.uid())
    )
  )
  with check (
    (select public.obtener_rol_actual()) = 'tecnico'
    and asignado_a = (select auth.uid())
  );