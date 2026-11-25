# Humasha Goods Wholesalers LLC Website

A responsive React + Vite corporate website with Supabase-powered content management, admin authentication, image uploads, inquiries, products, projects, clients, services and testimonials.

## Quick overview
- Public website works in a visual demo mode without Supabase (uses sample content).
- Admin panel is activated after Supabase setup: `/admin`.
- Supabase tables and security policies are in `supabase/schema.sql`.
- Image uploads use the public `site-media` Storage bucket; only admins can upload/manage images.
- Deployable to Cloudflare Pages.

## Requirements
- Node.js 20 or newer
- A free Supabase project
- A GitHub account
- A Cloudflare account

Follow `START-HERE-BN.md` for the beginner-friendly setup in Bangla.

## Local development
```bash
npm install
cp .env.example .env
# Add your Supabase URL and publishable/anon key to .env
npm run dev
```

## Build
```bash
npm run build
```
The production output is in `dist/`.

## Cloudflare Pages settings
- Connect the GitHub repository.
- Framework preset: Vite
- Build command: `npm run build`
- Build output directory: `dist`
- Add environment variables `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in Cloudflare Pages > Settings > Environment variables.
- Redeploy after adding environment variables.

## Admin account
1. Create the first user in Supabase Authentication > Users > Add user.
2. Copy that user's UUID.
3. In Supabase SQL Editor run:
```sql
insert into public.profiles (id, full_name, role)
values ('PASTE-AUTH-USER-UUID-HERE', 'Website Administrator', 'admin');
```
4. Open `https://YOUR-SITE.pages.dev/admin` and sign in with that user's email/password.

Never put a Supabase service-role key in this frontend project. Only use the publishable/anon key.

## Important content note
The initial client list and major project names come from the supplied company profile. Client logos and project photographs are placeholders until the company uploads verified official images. Demo customer reviews are intentionally not fabricated; add authentic reviews through Admin > Reviews.
