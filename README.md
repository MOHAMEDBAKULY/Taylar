# TailorFit

Custom-made clothing for women and girls. Customers browse a designer store, enter measurements in centimetres, choose fabric and color, then see a price and timeline in Kenyan Shillings (KES) before paying.

This repository is the **MVP scaffold**: Next.js App Router, Supabase schema, API contract stubs, and page shells. Stripe Checkout, Resend email, and full UI flows are not implemented yet.

## Stack

- Next.js (App Router) + TypeScript + Tailwind CSS
- Supabase (PostgreSQL, Auth, Storage, RLS)
- Google OAuth through Supabase Auth
- Stripe (Checkout + webhooks — stubbed)
- Resend (transactional email — stubbed)

## Local setup

1. Copy environment variables:

   ```bash
   cp .env.example .env.local
   ```

2. Start Supabase (requires [Docker](https://docs.docker.com/get-docker/) and the [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started)):

   ```bash
   npx supabase start
   npx supabase db reset
   ```

   `db reset` applies migrations and `supabase/seed.sql` (one designer, categories, measurement defaults, delivery cities at KES 400, and two sample designs).

3. Put the local API URL and anon key from `npx supabase status` into `.env.local`.

4. In the Supabase Studio (Authentication > Providers), enable Google OAuth. Add redirect URL:

   `http://localhost:3000/auth/callback`

5. Install dependencies if needed, then run the app:

   ```bash
   npm install
   npm run dev
   ```

   Open [http://localhost:3000](http://localhost:3000).

## Roles

| Role | Access |
| :--- | :--- |
| Guest | Browse designers, categories, designs, fabrics, colors, prices, and reviews |
| Customer | Sign in with Google to save measurements, cart, checkout, track orders, store credit, and reviews |
| Designer | Manage catalog, pricing, delivery, and fulfillment at `/designer` |

The seed designer is **Amina Atelier** (`22222222-2222-2222-2222-222222222222`) with Telegram username `aminaatelier`. After you sign in with Google, link that account:

```sql
update public.users
set role = 'designer'
where email = 'you@example.com';

update public.designers
set user_id = (select id from public.users where email = 'you@example.com')
where id = '22222222-2222-2222-2222-222222222222';
```

## Project layout

```
app/(storefront)   Public browse
app/(auth)         Google sign-in
app/(customer)     Measurements, cart, orders, store credit
app/(designer)     Designer dashboard
app/api            REST contract from the technical specification
lib/pricing        Authoritative KES price formulas
proxy.ts           Session refresh and role-based route protection
supabase/migrations  Schema, indexes, storage buckets, RLS
supabase/seed.sql    MVP catalog defaults
```

## Pricing (KES)

Backend only — the frontend cannot set the payable amount.

- Standard design: Fabric + Customization + Delivery
- Custom design: Custom Design Category + Fabric + Customization + Delivery

Delivery is city-based. MVP cities: Mombasa, Nairobi, Nakuru at **KES 400**.

Try the scaffolded calculator:

```bash
curl -X POST http://localhost:3000/api/pricing/calculate ^
  -H "Content-Type: application/json" ^
  -d "{\"items\":[{\"isCustom\":false,\"fabricKes\":1000,\"customizationKes\":500}],\"deliveryKes\":400}"
```

Expected total: **KES 1,900**.

Other API routes currently return `501 Not implemented` until the next implementation pass.

## Product documents

- `TailorFit_MVP_Final_Technical_Specification.md`
- `PRD_TailorFit_Custom_Clothing_App.md`

Where they disagree, the Final Technical Specification is the implementation contract.
