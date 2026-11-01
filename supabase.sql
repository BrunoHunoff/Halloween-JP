-- Cole isso no SQL Editor do Supabase e rode.

create table if not exists participantes (
  id bigint generated always as identity primary key,
  nome text not null check (char_length(nome) between 1 and 80),
  fantasia text not null check (char_length(fantasia) between 1 and 120),
  created_at timestamptz default now()
);

-- 1 voto por aparelho (voter_id fica no localStorage). Dá pra trocar o voto.
create table if not exists votos (
  voter_id uuid primary key,
  participante_id bigint not null references participantes(id) on delete cascade,
  created_at timestamptz default now()
);

create or replace view ranking with (security_invoker = true) as
  select p.id, p.nome, p.fantasia, count(v.voter_id)::int as votos
  from participantes p
  left join votos v on v.participante_id = p.id
  group by p.id
  order by votos desc, p.created_at asc;

alter table participantes enable row level security;
alter table votos enable row level security;

create policy "ler participantes"  on participantes for select using (true);
create policy "cadastrar"          on participantes for insert with check (true);
create policy "ler votos"          on votos for select using (true);
create policy "votar"              on votos for insert with check (true);
create policy "trocar voto"        on votos for update using (true) with check (true);

grant select on ranking to anon;

-- ===== Fotos (rodar depois, se ainda não rodou) =====
alter table participantes add column if not exists foto_url text;

create or replace view ranking with (security_invoker = true) as
  select p.id, p.nome, p.fantasia, count(v.voter_id)::int as votos, p.foto_url
  from participantes p
  left join votos v on v.participante_id = p.id
  group by p.id
  order by votos desc, p.created_at asc;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('fotos', 'fotos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

create policy "subir fotos" on storage.objects
  for insert to anon, authenticated with check (bucket_id = 'fotos');
