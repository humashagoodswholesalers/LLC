# Humasha Website — একদম সহজ বাংলা Setup Guide

আপনাকে কোড লিখতে হবে না। একবার নিচের সেটআপ শেষ করলে ওয়েবসাইটটি Cloudflare-এর ফ্রি `pages.dev` ঠিকানায় দেখা যাবে। এরপর `/admin` থেকে ছবি ও লেখা পরিবর্তন করতে পারবেন।

## প্রথমে কী কী লাগবে?
1. একটি Gmail/Email account
2. GitHub account: https://github.com/
3. Supabase account: https://supabase.com/
4. Cloudflare account: https://dash.cloudflare.com/

সবগুলো Free tier দিয়ে শুরু করা যাবে। Free plan-এর usage limit থাকে।

## ধাপ ১ — GitHub-এ ওয়েবসাইটের ফাইল তুলুন

1. এই ZIP ফাইলটি Extract করুন।
2. https://github.com/ খুলে Sign up / Sign in করুন।
3. উপরে ডানদিকে `+` চাপুন → `New repository`।
4. Repository name দিন `humasha-goods-website`।
5. `Private` নির্বাচন করতে পারেন। তারপর `Create repository` চাপুন।
6. নতুন repository-তে `uploading an existing file` লিংকে ক্লিক করুন।
7. ZIP Extract করা ফোল্ডারের ভেতরের সব ফাইল ও ফোল্ডার (src, supabase, index.html, package.json ইত্যাদি) একসঙ্গে drag & drop করুন। ZIP ফাইলটি নিজে upload করবেন না।
8. নিচে `Commit changes` চাপুন।

## ধাপ ২ — Supabase Database তৈরি করুন

1. https://supabase.com/dashboard খুলুন এবং Sign in করুন।
2. `New project` চাপুন।
3. Organization নির্বাচন/তৈরি করুন।
4. Project name দিন `humasha-website`।
5. একটি শক্তিশালী Database Password তৈরি করে নিজের কাছে নিরাপদে রাখুন। ChatGPT বা GitHub-এ দেবেন না।
6. Region হিসেবে Singapore থাকলে সেটি নির্বাচন করতে পারেন (বাংলাদেশের জন্য কাছাকাছি)।
7. `Create new project` চাপুন এবং প্রস্তুত হওয়া পর্যন্ত অপেক্ষা করুন।

### Database SQL চালানো
1. Supabase Dashboard-এর বাম পাশে `SQL Editor` খুলুন।
2. `New query` চাপুন।
3. এই ZIP-এর `supabase` ফোল্ডারের `schema.sql` ফাইলটি Notepad দিয়ে খুলুন।
4. সব লেখা Copy করে Supabase SQL Editor-এ Paste করুন।
5. `Run` চাপুন।
6. সফল হলে Tables-এ products, projects, clients, services, testimonials, inquiries, website_settings, profiles দেখতে পাবেন।

## ধাপ ৩ — Admin user তৈরি করুন

1. Supabase Dashboard → `Authentication` → `Users` খুলুন।
2. `Add user` চাপুন।
3. আপনার নিজের Email ও শক্তিশালী Password দিন। Confirm user অপশন থাকলে সেটি নির্বাচন করুন।
4. User তৈরি হলে তার `UID` / UUID Copy করুন।
5. SQL Editor খুলে নিচের SQL-এ `PASTE-...` জায়গায় আপনার UID বসিয়ে Run করুন:

```sql
insert into public.profiles (id, full_name, role)
values ('PASTE-AUTH-USER-UUID-HERE', 'Website Administrator', 'admin');
```

এই কাজটি না করলে Admin Panel-এ লগইন হলেও কনটেন্ট পরিবর্তনের অনুমতি পাবেন না।

## ধাপ ৪ — Supabase-এর URL ও Key সংগ্রহ

1. Supabase Project-এর `Project Settings` খুলুন।
2. `API` অথবা `API Keys` অংশে যান।
3. Project URL Copy করুন।
4. `Publishable key` (বা পুরোনো প্রজেক্ট হলে `anon public` key) Copy করুন।
5. `service_role` / `secret` key কখনো ব্যবহার করবেন না। এটি গোপন এবং ওয়েবসাইটে দেওয়া যাবে না।

## ধাপ ৫ — Cloudflare Pages-এ ফ্রি Demo প্রকাশ করুন

1. https://dash.cloudflare.com/ খুলুন।
2. বাম পাশের `Workers & Pages` নির্বাচন করুন।
3. `Create application` → `Pages` → `Connect to Git` চাপুন।
4. GitHub account Connect করুন।
5. `humasha-goods-website` repository নির্বাচন করুন।
6. Build settings দিন:
   - Framework preset: `Vite`
   - Build command: `npm run build`
   - Build output directory: `dist`
7. Environment Variables অংশে দুটি variable যোগ করুন:
   - Name: `VITE_SUPABASE_URL` — Value: Supabase Project URL
   - Name: `VITE_SUPABASE_ANON_KEY` — Value: Supabase Publishable/anon key
8. `Save and Deploy` চাপুন।
9. Build শেষ হলে Cloudflare আপনাকে `something.pages.dev` ঠিকানা দেবে। সেটি আপনার ওয়েবসাইটের Demo URL।

## ধাপ ৬ — Admin Panel ব্যবহার

আপনার Demo URL-এর শেষে `/admin` লিখুন। উদাহরণ:

`https://humasha-goods-website.pages.dev/admin`

Supabase Authentication-এ তৈরি করা Email ও Password দিয়ে Login করুন। এরপর বাম পাশ থেকে:

- Products: পণ্যের নাম, বিবরণ, ছবি যোগ/পরিবর্তন
- Major Projects: প্রজেক্টের ছবি ও বিবরণ পরিবর্তন
- Valued Clients: ক্লায়েন্টের নাম ও অফিসিয়াল Logo আপলোড
- Services: সার্ভিসের নাম ও বিবরণ
- Reviews: প্রকৃত Customer Review যোগ/প্রকাশ
- Inquiries: Website Contact Form-এর মেসেজ দেখা
- Website Settings: Company Intro, Mission, Vision, Phone, Address পরিবর্তন

ছবি আপলোডের সময় JPG, PNG, WEBP বা SVG ব্যবহার করুন। সর্বোচ্চ 5 MB।

## ধাপ ৭ — পরে Custom Domain যুক্ত করা

প্রথমে `pages.dev` Demo পরীক্ষা করুন। সব ঠিক হলে Cloudflare Pages → আপনার Project → `Custom domains` → `Set up a custom domain` থেকে Domain Connect করুন। Domain কেনার আগে পছন্দের নাম Available কিনা যাচাই করবেন।

## গুরুত্বপূর্ণ সতর্কতা

- কোম্পানির দেওয়া Company Profile অনুযায়ী প্রাথমিক লেখা, পণ্য, Major Projects এবং Client Name যোগ করা হয়েছে।
- Client logo ও project image-এর কিছু Demo ছবি placeholder। সেগুলো Admin থেকে আসল ছবি দিয়ে বদলাবেন।
- কোনো Customer Review বানিয়ে দেওয়া হয়নি। প্রকৃত গ্রাহকের অনুমতি নিয়ে Review যোগ করবেন।
- Company Profile-এ থাকা ফোন নম্বরগুলো দেখানো হয়েছে। কোনটি WhatsApp নম্বর তা নিশ্চিত না হওয়া পর্যন্ত WhatsApp button বানানো হয়নি।
- এই Starter Version-এ Contact Form Supabase-এ inquiry সংরক্ষণ করে; Email notification স্বয়ংক্রিয়ভাবে পাঠায় না।
- Supabase ও Cloudflare Free tier-এর quota/সীমা থাকতে পারে।

## সমস্যা হলে কী করবেন?
Cloudflare Build error, Supabase SQL error, অথবা Admin login error-এর screenshot আমাকে পাঠাবেন। আমি আপনাকে একবারে একটি করে ধাপ বুঝিয়ে দেব। কোনো Password বা Secret key-এর screenshot পাঠাবেন না।
