-- Glow AI Photo Editor — initial schema
-- Apply with: supabase db push (CLI), or paste into the Supabase Studio SQL editor.
--
-- Tables: profiles · brands · briefs · brief_applications · projects
-- All tables are RLS-protected. Public reads on brands + briefs (the marketplace
-- side), authenticated reads on the user's own profile + projects + applications.

------------------------------------------------------------
-- Enums
------------------------------------------------------------
create type photo_variant as enum ('raw', 'enhanced', 'nobg', 'moody', 'studio', 'pastel', 'night');
create type product_kind  as enum ('skincare', 'fashion', 'food', 'gadget', 'none');
create type project_status as enum ('draft', 'in_edit', 'done');
create type brief_status   as enum ('open', 'closed', 'fulfilled');
create type application_status as enum ('pending', 'accepted', 'rejected');
create type tier_kind      as enum ('free', 'pro');

------------------------------------------------------------
-- profiles — extends auth.users
------------------------------------------------------------
create table public.profiles (
  id          uuid primary key references auth.users on delete cascade,
  handle      text unique not null,
  full_name   text not null,
  avatar_url  text,
  bio         text,
  followers   int  not null default 0,
  tier        tier_kind not null default 'free',
  created_at  timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "profiles_self_read"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_self_write"
  on public.profiles for update
  using (auth.uid() = id);

create policy "profiles_self_insert"
  on public.profiles for insert
  with check (auth.uid() = id);

------------------------------------------------------------
-- brands
------------------------------------------------------------
create table public.brands (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  category    text not null,
  logo_color  text,
  created_at  timestamptz not null default now()
);

alter table public.brands enable row level security;

-- Brands are public-readable (so creators can see who's offering)
create policy "brands_public_read"
  on public.brands for select
  using (true);

------------------------------------------------------------
-- briefs — collab opportunities
------------------------------------------------------------
create table public.briefs (
  id            uuid primary key default gen_random_uuid(),
  brand_id      uuid not null references public.brands on delete cascade,
  title         text not null,
  deliverables  text not null,
  rate          text not null,
  deadline      date not null,
  mood          photo_variant not null default 'enhanced',
  product_kind  product_kind  not null default 'skincare',
  status        brief_status  not null default 'open',
  created_at    timestamptz   not null default now()
);

alter table public.briefs enable row level security;

create policy "briefs_public_read"
  on public.briefs for select
  using (status = 'open');

create index briefs_brand_idx on public.briefs(brand_id);
create index briefs_status_idx on public.briefs(status);

------------------------------------------------------------
-- brief_applications — creator → brief
------------------------------------------------------------
create table public.brief_applications (
  id          uuid primary key default gen_random_uuid(),
  brief_id    uuid not null references public.briefs on delete cascade,
  creator_id  uuid not null references public.profiles on delete cascade,
  status      application_status not null default 'pending',
  applied_at  timestamptz not null default now(),
  unique (brief_id, creator_id)
);

alter table public.brief_applications enable row level security;

create policy "applications_self_read"
  on public.brief_applications for select
  using (auth.uid() = creator_id);

create policy "applications_self_insert"
  on public.brief_applications for insert
  with check (auth.uid() = creator_id);

create policy "applications_self_update"
  on public.brief_applications for update
  using (auth.uid() = creator_id);

------------------------------------------------------------
-- projects — saved edits
------------------------------------------------------------
create table public.projects (
  id            uuid primary key default gen_random_uuid(),
  owner_id      uuid not null references public.profiles on delete cascade,
  brand_id      uuid references public.brands on delete set null,
  label         text not null,
  photo_variant photo_variant not null default 'enhanced',
  product_kind  product_kind  not null default 'skincare',
  layer_count   int not null default 1,
  status        project_status not null default 'draft',
  created_at    timestamptz not null default now()
);

alter table public.projects enable row level security;

create policy "projects_self_read"
  on public.projects for select
  using (auth.uid() = owner_id);

create policy "projects_self_write"
  on public.projects for insert
  with check (auth.uid() = owner_id);

create policy "projects_self_update"
  on public.projects for update
  using (auth.uid() = owner_id);

create policy "projects_self_delete"
  on public.projects for delete
  using (auth.uid() = owner_id);

create index projects_owner_idx on public.projects(owner_id);

------------------------------------------------------------
-- Trigger: auto-create a profile when an auth user is inserted
------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, handle, full_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'handle', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1))
  )
  on conflict (id) do nothing;
  return new;
end$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
