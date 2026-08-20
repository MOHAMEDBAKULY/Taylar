-- TailorFit MVP schema
-- Entities from Technical Specification §35–38

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------

create type public.user_role as enum ('customer', 'designer', 'admin');

create type public.order_status as enum (
  'PENDING_PAYMENT',
  'PAID',
  'PROCESSING',
  'IN_PRODUCTION',
  'READY_FOR_DELIVERY',
  'OUT_FOR_DELIVERY',
  'DELIVERED',
  'CANCELLED'
);

create type public.payment_status as enum (
  'PENDING',
  'PAID',
  'FAILED',
  'CANCELLED',
  'REFUNDED'
);

create type public.custom_design_tier as enum ('Simple', 'Moderate', 'Complex');

create type public.store_credit_entry_type as enum (
  'ADD',
  'REMOVE',
  'REFUND',
  'MODIFICATION_CREDIT',
  'USED'
);

create type public.order_modification_status as enum (
  'PENDING_PAYMENT',
  'APPLIED',
  'REJECTED'
);

create type public.cancelled_by_role as enum ('customer', 'designer');

-- ---------------------------------------------------------------------------
-- Updated-at helper
-- ---------------------------------------------------------------------------

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- 1. users (app profile linked to auth.users)
-- ---------------------------------------------------------------------------

create table public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  full_name text,
  role public.user_role not null default 'customer',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger users_set_updated_at
  before update on public.users
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 2. designers
-- ---------------------------------------------------------------------------

create table public.designers (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references public.users (id) on delete set null,
  display_name text not null,
  bio text,
  telegram_username text,
  production_time_days integer not null default 14
    check (production_time_days > 0),
  is_active boolean not null default true,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger designers_set_updated_at
  before update on public.designers
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 3. customer_profiles
-- ---------------------------------------------------------------------------

create table public.customer_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.users (id) on delete cascade,
  phone text,
  default_delivery_city text,
  delivery_address text,
  delivery_instructions text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint customer_profiles_city_check
    check (
      default_delivery_city is null
      or default_delivery_city in ('Mombasa', 'Nairobi', 'Nakuru')
    )
);

create trigger customer_profiles_set_updated_at
  before update on public.customer_profiles
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 4. categories
-- ---------------------------------------------------------------------------

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger categories_set_updated_at
  before update on public.categories
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 5. designs
-- ---------------------------------------------------------------------------

create table public.designs (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  category_id uuid not null references public.categories (id),
  name text not null,
  description text,
  estimated_production_days integer not null default 14
    check (estimated_production_days > 0),
  is_published boolean not null default false,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (designer_id, name)
);

create index designs_designer_id_idx on public.designs (designer_id);
create index designs_category_id_idx on public.designs (category_id);

create trigger designs_set_updated_at
  before update on public.designs
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 6. design_images
-- ---------------------------------------------------------------------------

create table public.design_images (
  id uuid primary key default gen_random_uuid(),
  design_id uuid not null references public.designs (id) on delete cascade,
  storage_path text not null,
  alt_text text,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index design_images_design_id_idx on public.design_images (design_id);

-- ---------------------------------------------------------------------------
-- 7. fabrics
-- ---------------------------------------------------------------------------

create table public.fabrics (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  name text not null,
  texture text,
  price_kes numeric(12, 2) not null check (price_kes >= 0),
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index fabrics_designer_id_idx on public.fabrics (designer_id);

create trigger fabrics_set_updated_at
  before update on public.fabrics
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 8. colors
-- ---------------------------------------------------------------------------

create table public.colors (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  name text not null,
  hex_code text,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index colors_designer_id_idx on public.colors (designer_id);

create trigger colors_set_updated_at
  before update on public.colors
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 9. customization_options
-- ---------------------------------------------------------------------------

create table public.customization_options (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  group_name text not null,
  name text not null,
  price_modifier_kes numeric(12, 2) not null default 0,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index customization_options_designer_id_idx
  on public.customization_options (designer_id);

create trigger customization_options_set_updated_at
  before update on public.customization_options
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 10. measurement_types
-- ---------------------------------------------------------------------------

create table public.measurement_types (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  unit text not null default 'cm' check (unit = 'cm'),
  default_min numeric(8, 2) not null check (default_min >= 0),
  default_max numeric(8, 2) not null check (default_max > default_min),
  default_required boolean not null default true,
  default_instructions text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger measurement_types_set_updated_at
  before update on public.measurement_types
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 11. category_measurements
-- ---------------------------------------------------------------------------

create table public.category_measurements (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid references public.designers (id) on delete cascade,
  category_id uuid not null references public.categories (id) on delete cascade,
  measurement_type_id uuid not null references public.measurement_types (id),
  min_value numeric(8, 2) not null check (min_value >= 0),
  max_value numeric(8, 2) not null check (max_value > min_value),
  required boolean not null default true,
  instructions text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (designer_id, category_id, measurement_type_id)
);

-- Platform defaults (designer_id is null) need their own uniqueness rule
create unique index category_measurements_platform_defaults_idx
  on public.category_measurements (category_id, measurement_type_id)
  where designer_id is null;

create index category_measurements_designer_id_idx
  on public.category_measurements (designer_id);
create index category_measurements_category_id_idx
  on public.category_measurements (category_id);

create trigger category_measurements_set_updated_at
  before update on public.category_measurements
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 12. measurement_profiles
-- ---------------------------------------------------------------------------

create table public.measurement_profiles (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customer_profiles (id) on delete cascade,
  person_name text not null,
  relationship text not null,
  last_updated_at timestamptz not null default now(),
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index measurement_profiles_customer_id_idx
  on public.measurement_profiles (customer_id);

create trigger measurement_profiles_set_updated_at
  before update on public.measurement_profiles
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 13. measurement_values
-- ---------------------------------------------------------------------------

create table public.measurement_values (
  id uuid primary key default gen_random_uuid(),
  measurement_profile_id uuid not null
    references public.measurement_profiles (id) on delete cascade,
  measurement_type_id uuid not null references public.measurement_types (id),
  value_cm numeric(8, 2) not null check (value_cm > 0),
  unique (measurement_profile_id, measurement_type_id)
);

-- ---------------------------------------------------------------------------
-- 14. custom_design_categories
-- ---------------------------------------------------------------------------

create table public.custom_design_categories (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  tier public.custom_design_tier not null,
  price_kes numeric(12, 2) not null check (price_kes >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (designer_id, tier)
);

create trigger custom_design_categories_set_updated_at
  before update on public.custom_design_categories
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 15. carts
-- ---------------------------------------------------------------------------

create table public.carts (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null unique
    references public.customer_profiles (id) on delete cascade,
  designer_id uuid references public.designers (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger carts_set_updated_at
  before update on public.carts
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 16. cart_items
-- Each item carries its own fabric, color, customizations, and measurements.
-- ---------------------------------------------------------------------------

create table public.cart_items (
  id uuid primary key default gen_random_uuid(),
  cart_id uuid not null references public.carts (id) on delete cascade,
  designer_id uuid not null references public.designers (id),
  design_id uuid references public.designs (id),
  is_custom boolean not null default false,
  custom_design_category_id uuid
    references public.custom_design_categories (id),
  fabric_id uuid references public.fabrics (id),
  color_id uuid references public.colors (id),
  measurement_profile_id uuid references public.measurement_profiles (id),
  customization_option_ids uuid[] not null default '{}',
  custom_description text,
  reference_image_path text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint cart_items_standard_or_custom check (
    (is_custom = false and design_id is not null)
    or (is_custom = true and custom_design_category_id is not null)
  )
);

create index cart_items_cart_id_idx on public.cart_items (cart_id);

create trigger cart_items_set_updated_at
  before update on public.cart_items
  for each row execute function public.set_updated_at();

-- One designer per cart (spec §17 / §37)
create or replace function public.enforce_single_designer_cart()
returns trigger
language plpgsql
as $$
declare
  cart_designer uuid;
begin
  select designer_id into cart_designer from public.carts where id = new.cart_id;

  if cart_designer is null then
    update public.carts
      set designer_id = new.designer_id, updated_at = now()
      where id = new.cart_id;
  elsif cart_designer <> new.designer_id then
    raise exception
      'Your cart contains items from another designer. Please checkout first or start a new cart.';
  end if;

  return new;
end;
$$;

create trigger cart_items_single_designer
  before insert or update of designer_id on public.cart_items
  for each row execute function public.enforce_single_designer_cart();

-- ---------------------------------------------------------------------------
-- 17. orders
-- ---------------------------------------------------------------------------

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customer_profiles (id),
  designer_id uuid not null references public.designers (id),
  status public.order_status not null default 'PENDING_PAYMENT',
  delivery_city text not null
    check (delivery_city in ('Mombasa', 'Nairobi', 'Nakuru')),
  delivery_address text not null,
  receiver_name text not null,
  receiver_phone text not null,
  delivery_instructions text,
  delivery_fee_kes numeric(12, 2) not null check (delivery_fee_kes >= 0),
  subtotal_kes numeric(12, 2) not null check (subtotal_kes >= 0),
  store_credit_applied_kes numeric(12, 2) not null default 0
    check (store_credit_applied_kes >= 0),
  total_kes numeric(12, 2) not null check (total_kes >= 0),
  modification_window_ends_at timestamptz not null,
  cancellation_reason text,
  cancelled_by public.cancelled_by_role,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index orders_customer_id_idx on public.orders (customer_id);
create index orders_designer_id_idx on public.orders (designer_id);
create index orders_status_idx on public.orders (status);
create index orders_created_at_idx on public.orders (created_at);

create trigger orders_set_updated_at
  before update on public.orders
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 18. order_items
-- ---------------------------------------------------------------------------

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  design_id uuid references public.designs (id),
  design_name text,
  is_custom boolean not null default false,
  custom_design_category_id uuid references public.custom_design_categories (id),
  fabric_id uuid references public.fabrics (id),
  fabric_name text,
  fabric_price_kes numeric(12, 2) not null default 0 check (fabric_price_kes >= 0),
  color_id uuid references public.colors (id),
  color_name text,
  customization_price_kes numeric(12, 2) not null default 0
    check (customization_price_kes >= 0),
  custom_tier_price_kes numeric(12, 2) not null default 0
    check (custom_tier_price_kes >= 0),
  item_total_kes numeric(12, 2) not null check (item_total_kes >= 0),
  custom_description text,
  recipient_name text,
  created_at timestamptz not null default now()
);

create index order_items_order_id_idx on public.order_items (order_id);

-- ---------------------------------------------------------------------------
-- 19. order_measurements (immutable snapshot)
-- ---------------------------------------------------------------------------

create table public.order_measurements (
  id uuid primary key default gen_random_uuid(),
  order_item_id uuid not null
    references public.order_items (id) on delete cascade,
  measurement_type_name text not null,
  unit text not null default 'cm' check (unit = 'cm'),
  value_cm numeric(8, 2) not null check (value_cm > 0),
  min_value numeric(8, 2),
  max_value numeric(8, 2),
  required boolean not null default true
);

create index order_measurements_order_item_id_idx
  on public.order_measurements (order_item_id);

-- ---------------------------------------------------------------------------
-- 20. order_customizations (immutable snapshot)
-- ---------------------------------------------------------------------------

create table public.order_customizations (
  id uuid primary key default gen_random_uuid(),
  order_item_id uuid not null
    references public.order_items (id) on delete cascade,
  customization_option_id uuid references public.customization_options (id),
  group_name text not null,
  name text not null,
  price_modifier_kes numeric(12, 2) not null default 0
);

create index order_customizations_order_item_id_idx
  on public.order_customizations (order_item_id);

-- ---------------------------------------------------------------------------
-- 21. order_reference_images
-- ---------------------------------------------------------------------------

create table public.order_reference_images (
  id uuid primary key default gen_random_uuid(),
  order_item_id uuid not null
    references public.order_items (id) on delete cascade,
  storage_path text not null,
  original_filename text,
  mime_type text,
  created_at timestamptz not null default now()
);

create index order_reference_images_order_item_id_idx
  on public.order_reference_images (order_item_id);

-- ---------------------------------------------------------------------------
-- 22. pricing_rules
-- ---------------------------------------------------------------------------

create table public.pricing_rules (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  rule_type text not null,
  name text not null,
  amount_kes numeric(12, 2) not null check (amount_kes >= 0),
  metadata jsonb not null default '{}'::jsonb,
  archived_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index pricing_rules_designer_id_idx on public.pricing_rules (designer_id);

create trigger pricing_rules_set_updated_at
  before update on public.pricing_rules
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 23. delivery_rules
-- ---------------------------------------------------------------------------

create table public.delivery_rules (
  id uuid primary key default gen_random_uuid(),
  designer_id uuid not null references public.designers (id) on delete cascade,
  city text not null check (city in ('Mombasa', 'Nairobi', 'Nakuru')),
  price_kes numeric(12, 2) not null default 400 check (price_kes >= 0),
  is_available boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (designer_id, city)
);

create index delivery_rules_designer_id_idx on public.delivery_rules (designer_id);

create trigger delivery_rules_set_updated_at
  before update on public.delivery_rules
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 24. payments
-- ---------------------------------------------------------------------------

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id),
  stripe_checkout_session_id text unique,
  stripe_payment_id text unique,
  amount_kes numeric(12, 2) not null check (amount_kes >= 0),
  currency text not null default 'KES' check (currency = 'KES'),
  status public.payment_status not null default 'PENDING',
  paid_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index payments_order_id_idx on public.payments (order_id);
create index payments_stripe_payment_id_idx on public.payments (stripe_payment_id);

create trigger payments_set_updated_at
  before update on public.payments
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 25. refunds
-- ---------------------------------------------------------------------------

create table public.refunds (
  id uuid primary key default gen_random_uuid(),
  payment_id uuid not null references public.payments (id),
  order_id uuid not null references public.orders (id),
  stripe_refund_id text unique,
  amount_kes numeric(12, 2) not null check (amount_kes >= 0),
  reason text,
  created_at timestamptz not null default now()
);

create index refunds_order_id_idx on public.refunds (order_id);

-- ---------------------------------------------------------------------------
-- 26. store_credits
-- ---------------------------------------------------------------------------

create table public.store_credits (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null unique
    references public.customer_profiles (id) on delete cascade,
  balance_kes numeric(12, 2) not null default 0 check (balance_kes >= 0),
  updated_at timestamptz not null default now()
);

create trigger store_credits_set_updated_at
  before update on public.store_credits
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- 27. store_credit_transactions
-- ---------------------------------------------------------------------------

create table public.store_credit_transactions (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customer_profiles (id),
  store_credit_id uuid not null references public.store_credits (id),
  entry_type public.store_credit_entry_type not null,
  amount_kes numeric(12, 2) not null,
  order_id uuid references public.orders (id),
  note text,
  created_at timestamptz not null default now()
);

create index store_credit_transactions_customer_id_idx
  on public.store_credit_transactions (customer_id);

-- ---------------------------------------------------------------------------
-- 28. order_status_history
-- ---------------------------------------------------------------------------

create table public.order_status_history (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  from_status public.order_status,
  to_status public.order_status not null,
  changed_by uuid references public.users (id),
  note text,
  created_at timestamptz not null default now()
);

create index order_status_history_order_id_idx
  on public.order_status_history (order_id);

-- ---------------------------------------------------------------------------
-- 29. order_modifications
-- ---------------------------------------------------------------------------

create table public.order_modifications (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders (id) on delete cascade,
  status public.order_modification_status not null default 'PENDING_PAYMENT',
  original_total_kes numeric(12, 2) not null,
  new_total_kes numeric(12, 2) not null,
  delta_kes numeric(12, 2) not null,
  payload jsonb not null default '{}'::jsonb,
  applied_at timestamptz,
  created_at timestamptz not null default now()
);

create index order_modifications_order_id_idx
  on public.order_modifications (order_id);

-- ---------------------------------------------------------------------------
-- 30. reviews (one per delivered order, not editable)
-- ---------------------------------------------------------------------------

create table public.reviews (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null unique references public.orders (id),
  customer_id uuid not null references public.customer_profiles (id),
  designer_id uuid not null references public.designers (id),
  rating integer not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now()
);

create index reviews_order_id_idx on public.reviews (order_id);
create index reviews_designer_id_idx on public.reviews (designer_id);

-- ---------------------------------------------------------------------------
-- 31. review_responses
-- ---------------------------------------------------------------------------

create table public.review_responses (
  id uuid primary key default gen_random_uuid(),
  review_id uuid not null unique references public.reviews (id) on delete cascade,
  designer_id uuid not null references public.designers (id),
  comment text not null,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 32. notification_events
-- ---------------------------------------------------------------------------

create table public.notification_events (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders (id),
  customer_id uuid references public.customer_profiles (id),
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  resend_id text,
  sent_at timestamptz,
  created_at timestamptz not null default now()
);

create index notification_events_order_id_idx
  on public.notification_events (order_id);

-- ---------------------------------------------------------------------------
-- Auth: create app user + customer records on signup
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  new_role public.user_role;
  new_customer_id uuid;
begin
  new_role := coalesce(
    (new.raw_user_meta_data->>'role')::public.user_role,
    'customer'
  );

  insert into public.users (id, email, full_name, role, avatar_url)
  values (
    new.id,
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'),
    new_role,
    new.raw_user_meta_data->>'avatar_url'
  );

  if new_role = 'customer' then
    insert into public.customer_profiles (user_id)
    values (new.id)
    returning id into new_customer_id;

    insert into public.store_credits (customer_id) values (new_customer_id);
    insert into public.carts (customer_id) values (new_customer_id);
  end if;

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Record order status changes
create or replace function public.record_order_status_change()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    insert into public.order_status_history (order_id, from_status, to_status)
    values (new.id, null, new.status);
  elsif old.status is distinct from new.status then
    insert into public.order_status_history (order_id, from_status, to_status)
    values (new.id, old.status, new.status);
  end if;
  return new;
end;
$$;

create trigger orders_status_history
  after insert or update of status on public.orders
  for each row execute function public.record_order_status_change();

-- ---------------------------------------------------------------------------
-- Storage buckets
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  (
    'design-images',
    'design-images',
    true,
    5242880,
    array['image/jpeg', 'image/png', 'image/webp']
  ),
  (
    'reference-images',
    'reference-images',
    false,
    5242880,
    array['image/jpeg', 'image/png', 'image/webp']
  )
on conflict (id) do nothing;
