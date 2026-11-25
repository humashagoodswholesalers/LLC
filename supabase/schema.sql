-- HUMASHA GOODS WHOLESALERS LLC — Supabase schema
-- Run this entire file in Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  role text not null default 'admin' check (role in ('admin')),
  created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'); $$;

grant execute on function public.is_admin() to anon, authenticated;

create table if not exists public.website_settings (
  key text primary key,
  value jsonb not null default '""'::jsonb,
  updated_at timestamptz not null default now()
);
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(), name text not null unique, category text, description text,
  image_url text, published boolean not null default true, sort_order integer not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(), name text not null unique, location text, description text,
  image_url text, published boolean not null default true, sort_order integer not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(), name text not null unique, description text, image_url text,
  published boolean not null default true, sort_order integer not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.services (
  id uuid primary key default gen_random_uuid(), name text not null unique, description text,
  published boolean not null default true, sort_order integer not null default 0,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.testimonials (
  id uuid primary key default gen_random_uuid(), customer_name text not null, company_name text,
  designation text, rating integer not null default 5 check (rating between 1 and 5),
  review text not null, image_url text, published boolean not null default false,
  sort_order integer not null default 0, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.inquiries (
  id uuid primary key default gen_random_uuid(), full_name text not null, company_name text,
  email text not null, phone text, subject text, message text not null,
  status text not null default 'new' check (status in ('new','read','replied')),
  created_at timestamptz not null default now()
);

-- Enable Row Level Security.
alter table public.profiles enable row level security;
alter table public.website_settings enable row level security;
alter table public.products enable row level security;
alter table public.projects enable row level security;
alter table public.clients enable row level security;
alter table public.services enable row level security;
alter table public.testimonials enable row level security;
alter table public.inquiries enable row level security;

-- Profiles: signed-in user can only read their own role row.
drop policy if exists "profile self read" on public.profiles;
create policy "profile self read" on public.profiles for select to authenticated using (id = auth.uid());
drop policy if exists "admins manage profiles" on public.profiles;
create policy "admins manage profiles" on public.profiles for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- Public visitors read published content. Admins manage all content.
do $$ declare t text; begin
  foreach t in array array['products','projects','clients','services','testimonials'] loop
    execute format('drop policy if exists "public reads published %1$s" on public.%1$I', t);
    execute format('create policy "public reads published %1$s" on public.%1$I for select to anon, authenticated using (published = true or public.is_admin())', t);
    execute format('drop policy if exists "admins manage %1$s" on public.%1$I', t);
    execute format('create policy "admins manage %1$s" on public.%1$I for all to authenticated using (public.is_admin()) with check (public.is_admin())', t);
  end loop;
end $$;

drop policy if exists "public reads settings" on public.website_settings;
create policy "public reads settings" on public.website_settings for select to anon, authenticated using (true);
drop policy if exists "admins manage settings" on public.website_settings;
create policy "admins manage settings" on public.website_settings for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "visitors submit inquiries" on public.inquiries;
create policy "visitors submit inquiries" on public.inquiries for insert to anon, authenticated with check (true);
drop policy if exists "admins read inquiries" on public.inquiries;
create policy "admins read inquiries" on public.inquiries for select to authenticated using (public.is_admin());
drop policy if exists "admins update inquiries" on public.inquiries;
create policy "admins update inquiries" on public.inquiries for update to authenticated using (public.is_admin()) with check (public.is_admin());
drop policy if exists "admins delete inquiries" on public.inquiries;
create policy "admins delete inquiries" on public.inquiries for delete to authenticated using (public.is_admin());

-- Public image bucket. Only admins can upload, replace or delete files.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('site-media','site-media',true,5242880,array['image/png','image/jpeg','image/webp','image/svg+xml'])
on conflict (id) do update set public=true, file_size_limit=5242880, allowed_mime_types=array['image/png','image/jpeg','image/webp','image/svg+xml'];
drop policy if exists "public view site media" on storage.objects;
create policy "public view site media" on storage.objects for select to anon, authenticated using (bucket_id='site-media');
drop policy if exists "admins upload site media" on storage.objects;
create policy "admins upload site media" on storage.objects for insert to authenticated with check (bucket_id='site-media' and public.is_admin());
drop policy if exists "admins update site media" on storage.objects;
create policy "admins update site media" on storage.objects for update to authenticated using (bucket_id='site-media' and public.is_admin()) with check (bucket_id='site-media' and public.is_admin());
drop policy if exists "admins delete site media" on storage.objects;
create policy "admins delete site media" on storage.objects for delete to authenticated using (bucket_id='site-media' and public.is_admin());

-- Initial company settings. Replace or edit from Admin > Website Settings.
insert into public.website_settings(key,value) values
('name','"Humasha Goods Wholesalers LLC"'),
('tagline','"Your trusted partner in global industrial & construction supply"'),
('hero_heading','"Building trust. Supplying progress."'),
('hero_subtitle','"Your trusted partner in industrial tools, construction materials and project supply solutions."'),
('about_heading','"A reliable supply partner for projects that matter."'),
('intro','"Humasha Goods Wholesalers LLC specializes in supplying goods according to project and industry requirements, sourcing products from around the world. Established in June 2021, we support projects, industries, contractors and traders with a wide range of materials and equipment."'),
('slogan','"EARN TRUST WITH BUSINESS"'),
('mission','"Our mission is to offer our customers the finest quality and best selection of products with the quickest service for project and industry requirements."'),
('vision','"To serve customers through exceptional international standards of service and make the company a market leader."'),
('objective','"To become one of the leading market-share holders in a highly competitive global market."'),
('strategy','"To be the preferred goods supplier to international customers through the support and confidence of our experienced team."'),
('goal','"Customer satisfaction is our ultimate goal. We are committed to providing products at the right time and at the right place."'),
('address','"P.O. Box 96234, Dubai, UAE"'),
('phones','["+971 54 2656668", "+971 503576026", "+971 521548061"]')
on conflict(key) do nothing;

-- Initial products based on the supplied company profile. Temporary image URLs can be replaced in Admin.
insert into public.products(name,category,description,image_url,sort_order) values
('Building Materials & Construction Materials','Construction','Building and construction materials for project requirements.','https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=900&q=80',1),
('Sandwich Panel','Building Materials','Sandwich panel products for project requirements.','https://images.unsplash.com/photo-1511818966892-d7d671e672a2?auto=format&fit=crop&w=900&q=80',2),
('Fasteners','Industrial Supplies','Industrial fastening products and accessories.','https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=900&q=80',3),
('Fire Equipment','Safety Equipment','Fire equipment and related supply items.','https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?auto=format&fit=crop&w=900&q=80',4),
('Chemical Items','Industrial Supplies','Chemical items for industrial requirements.','https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?auto=format&fit=crop&w=900&q=80',5),
('DWT Tools','Tools','Tools for professional and project applications.','https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=900&q=80',6),
('EPDM Rubber Items','Rubber Products','EPDM rubber products and components.','https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=900&q=80',7),
('HDPE Pipe & Fittings','Pipes & Fittings','HDPE pipes and fittings for project supply.','https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=900&q=80',8),
('Valves & Electrical Items','Industrial Supplies','Valves and electrical items for industry requirements.','https://images.unsplash.com/photo-1581092921461-eab62e97a780?auto=format&fit=crop&w=900&q=80',9)
on conflict do nothing;
insert into public.projects(name,location,description,image_url,sort_order) values
('Ruppur Nuclear Power Plant Project','Bangladesh','Listed as a major project in the supplied company profile. Replace this temporary image with an authentic project image.','https://images.unsplash.com/photo-1513828583688-c52646e5e3e8?auto=format&fit=crop&w=1200&q=80',1),
('Padma Bridge Project','Bangladesh','Listed as a major project in the supplied company profile. Replace this temporary image with an authentic project image.','https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=1200&q=80',2)
on conflict do nothing;
insert into public.clients(name,description,sort_order) values
('The Civil Engineers Ltd.','Valued client',1),('Paharpur Cooling Tower Ltd.','Valued client',2),('Karnaphuli Fertilizer Company Limited','Valued client',3),('Energy Pack Engineer Ltd.','Valued client',4),('Bangladesh Atomic Energy Commission','Valued client',5),('Primo BD','Valued client',6),('Rosemount BD','Valued client',7),('Equipment Care','Valued client',8)
on conflict do nothing;
insert into public.services(name,description,sort_order) values
('Industrial Material Supply','Supply support for industrial requirements.',1),('Construction Material Supply','Construction and building material sourcing.',2),('Project-Based Procurement','Sourcing goods according to project specifications.',3),('Global Product Sourcing','Finding products from suppliers around the world.',4),('Building Material Distribution','Distribution support for building materials.',5),('Industrial Tools & Equipment Supply','Tools and equipment for industry and projects.',6)
on conflict do nothing;
