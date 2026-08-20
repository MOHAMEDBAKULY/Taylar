-- TailorFit RLS
-- Customers own their data; designers own their store; guests can read the catalog.

create or replace function public.current_user_role()
returns public.user_role
language sql
stable
security definer
set search_path = public
as $$
  select role from public.users where id = auth.uid()
$$;

create or replace function public.current_customer_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.customer_profiles where user_id = auth.uid()
$$;

create or replace function public.current_designer_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select id from public.designers where user_id = auth.uid()
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.current_user_role() = 'admin', false)
$$;

create or replace function public.customer_owns_order(p_order_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.orders o
    where o.id = p_order_id
      and o.customer_id = public.current_customer_id()
  )
$$;

create or replace function public.designer_owns_order(p_order_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.orders o
    where o.id = p_order_id
      and o.designer_id = public.current_designer_id()
  )
$$;

grant execute on function public.current_user_role() to anon, authenticated;
grant execute on function public.current_customer_id() to anon, authenticated;
grant execute on function public.current_designer_id() to anon, authenticated;
grant execute on function public.is_admin() to anon, authenticated;

-- ---------------------------------------------------------------------------
-- Enable RLS
-- ---------------------------------------------------------------------------

alter table public.users enable row level security;
alter table public.designers enable row level security;
alter table public.customer_profiles enable row level security;
alter table public.categories enable row level security;
alter table public.designs enable row level security;
alter table public.design_images enable row level security;
alter table public.fabrics enable row level security;
alter table public.colors enable row level security;
alter table public.customization_options enable row level security;
alter table public.measurement_types enable row level security;
alter table public.category_measurements enable row level security;
alter table public.measurement_profiles enable row level security;
alter table public.measurement_values enable row level security;
alter table public.custom_design_categories enable row level security;
alter table public.carts enable row level security;
alter table public.cart_items enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.order_measurements enable row level security;
alter table public.order_customizations enable row level security;
alter table public.order_reference_images enable row level security;
alter table public.pricing_rules enable row level security;
alter table public.delivery_rules enable row level security;
alter table public.payments enable row level security;
alter table public.refunds enable row level security;
alter table public.store_credits enable row level security;
alter table public.store_credit_transactions enable row level security;
alter table public.order_status_history enable row level security;
alter table public.order_modifications enable row level security;
alter table public.reviews enable row level security;
alter table public.review_responses enable row level security;
alter table public.notification_events enable row level security;

-- ---------------------------------------------------------------------------
-- users
-- ---------------------------------------------------------------------------

create policy users_select_self on public.users
  for select using (id = auth.uid() or public.is_admin());

create policy users_update_self on public.users
  for update using (id = auth.uid())
  with check (id = auth.uid() and role = public.current_user_role());

-- ---------------------------------------------------------------------------
-- designers (public catalog)
-- ---------------------------------------------------------------------------

create policy designers_public_read on public.designers
  for select using (archived_at is null and is_active = true);

create policy designers_update_own on public.designers
  for update using (id = public.current_designer_id())
  with check (id = public.current_designer_id());

create policy designers_admin_all on public.designers
  for all using (public.is_admin()) with check (public.is_admin());

-- ---------------------------------------------------------------------------
-- customer_profiles
-- ---------------------------------------------------------------------------

create policy customer_profiles_select_own on public.customer_profiles
  for select using (
    id = public.current_customer_id()
    or user_id = auth.uid()
    or public.is_admin()
    or exists (
      select 1 from public.orders o
      where o.customer_id = customer_profiles.id
        and o.designer_id = public.current_designer_id()
    )
  );

create policy customer_profiles_update_own on public.customer_profiles
  for update using (id = public.current_customer_id())
  with check (id = public.current_customer_id());

-- ---------------------------------------------------------------------------
-- Public catalog tables
-- ---------------------------------------------------------------------------

create policy categories_public_read on public.categories
  for select using (archived_at is null or public.is_admin());

create policy categories_admin_write on public.categories
  for all using (public.is_admin()) with check (public.is_admin());

create policy designs_public_read on public.designs
  for select using (
    (is_published = true and archived_at is null)
    or designer_id = public.current_designer_id()
    or public.is_admin()
  );

create policy designs_designer_insert on public.designs
  for insert with check (designer_id = public.current_designer_id());

create policy designs_designer_update on public.designs
  for update using (designer_id = public.current_designer_id())
  with check (designer_id = public.current_designer_id());

create policy designs_designer_delete on public.designs
  for delete using (designer_id = public.current_designer_id());

create policy design_images_public_read on public.design_images
  for select using (
    exists (
      select 1 from public.designs d
      where d.id = design_images.design_id
        and (
          (d.is_published = true and d.archived_at is null)
          or d.designer_id = public.current_designer_id()
          or public.is_admin()
        )
    )
  );

create policy design_images_designer_write on public.design_images
  for all using (
    exists (
      select 1 from public.designs d
      where d.id = design_images.design_id
        and d.designer_id = public.current_designer_id()
    )
  )
  with check (
    exists (
      select 1 from public.designs d
      where d.id = design_images.design_id
        and d.designer_id = public.current_designer_id()
    )
  );

create policy fabrics_public_read on public.fabrics
  for select using (archived_at is null or designer_id = public.current_designer_id());

create policy fabrics_designer_write on public.fabrics
  for all using (designer_id = public.current_designer_id())
  with check (designer_id = public.current_designer_id());

create policy colors_public_read on public.colors
  for select using (archived_at is null or designer_id = public.current_designer_id());

create policy colors_designer_write on public.colors
  for all using (designer_id = public.current_designer_id())
  with check (designer_id = public.current_designer_id());

create policy customizations_public_read on public.customization_options
  for select using (archived_at is null or designer_id = public.current_designer_id());

create policy customizations_designer_write on public.customization_options
  for all using (designer_id = public.current_designer_id())
  with check (designer_id = public.current_designer_id());

create policy measurement_types_public_read on public.measurement_types
  for select using (true);

create policy category_measurements_public_read on public.category_measurements
  for select using (true);

create policy category_measurements_designer_write on public.category_measurements
  for all using (
    designer_id = public.current_designer_id()
    or public.is_admin()
  )
  with check (
    designer_id = public.current_designer_id()
    or public.is_admin()
  );

create policy custom_design_categories_public_read on public.custom_design_categories
  for select using (true);

create policy custom_design_categories_designer_write on public.custom_design_categories
  for all using (designer_id = public.current_designer_id())
  with check (designer_id = public.current_designer_id());

create policy delivery_rules_public_read on public.delivery_rules
  for select using (is_available = true or designer_id = public.current_designer_id());

create policy delivery_rules_designer_write on public.delivery_rules
  for all using (designer_id = public.current_designer_id())
  with check (designer_id = public.current_designer_id());

create policy pricing_rules_designer on public.pricing_rules
  for all using (
    designer_id = public.current_designer_id() or public.is_admin()
  )
  with check (
    designer_id = public.current_designer_id() or public.is_admin()
  );

-- ---------------------------------------------------------------------------
-- Measurement profiles
-- ---------------------------------------------------------------------------

create policy measurement_profiles_customer on public.measurement_profiles
  for all using (customer_id = public.current_customer_id())
  with check (customer_id = public.current_customer_id());

create policy measurement_profiles_designer_read on public.measurement_profiles
  for select using (
    exists (
      select 1 from public.orders o
      join public.order_items oi on oi.order_id = o.id
      where o.customer_id = measurement_profiles.customer_id
        and o.designer_id = public.current_designer_id()
    )
  );

create policy measurement_values_customer on public.measurement_values
  for all using (
    exists (
      select 1 from public.measurement_profiles mp
      where mp.id = measurement_values.measurement_profile_id
        and mp.customer_id = public.current_customer_id()
    )
  )
  with check (
    exists (
      select 1 from public.measurement_profiles mp
      where mp.id = measurement_values.measurement_profile_id
        and mp.customer_id = public.current_customer_id()
    )
  );

-- ---------------------------------------------------------------------------
-- Carts
-- ---------------------------------------------------------------------------

create policy carts_customer on public.carts
  for all using (customer_id = public.current_customer_id())
  with check (customer_id = public.current_customer_id());

create policy cart_items_customer on public.cart_items
  for all using (
    exists (
      select 1 from public.carts c
      where c.id = cart_items.cart_id
        and c.customer_id = public.current_customer_id()
    )
  )
  with check (
    exists (
      select 1 from public.carts c
      where c.id = cart_items.cart_id
        and c.customer_id = public.current_customer_id()
    )
  );

-- ---------------------------------------------------------------------------
-- Orders and children
-- ---------------------------------------------------------------------------

create policy orders_customer_select on public.orders
  for select using (
    customer_id = public.current_customer_id()
    or designer_id = public.current_designer_id()
    or public.is_admin()
  );

create policy orders_customer_insert on public.orders
  for insert with check (customer_id = public.current_customer_id());

create policy orders_customer_update on public.orders
  for update using (
    customer_id = public.current_customer_id()
    or designer_id = public.current_designer_id()
    or public.is_admin()
  );

create policy order_items_select on public.order_items
  for select using (
    public.customer_owns_order(order_id)
    or public.designer_owns_order(order_id)
    or public.is_admin()
  );

create policy order_items_insert on public.order_items
  for insert with check (public.customer_owns_order(order_id) or public.is_admin());

create policy order_measurements_select on public.order_measurements
  for select using (
    exists (
      select 1 from public.order_items oi
      where oi.id = order_measurements.order_item_id
        and (
          public.customer_owns_order(oi.order_id)
          or public.designer_owns_order(oi.order_id)
          or public.is_admin()
        )
    )
  );

create policy order_measurements_insert on public.order_measurements
  for insert with check (
    exists (
      select 1 from public.order_items oi
      where oi.id = order_measurements.order_item_id
        and public.customer_owns_order(oi.order_id)
    )
  );

create policy order_customizations_select on public.order_customizations
  for select using (
    exists (
      select 1 from public.order_items oi
      where oi.id = order_customizations.order_item_id
        and (
          public.customer_owns_order(oi.order_id)
          or public.designer_owns_order(oi.order_id)
          or public.is_admin()
        )
    )
  );

create policy order_customizations_insert on public.order_customizations
  for insert with check (
    exists (
      select 1 from public.order_items oi
      where oi.id = order_customizations.order_item_id
        and public.customer_owns_order(oi.order_id)
    )
  );

create policy order_reference_images_select on public.order_reference_images
  for select using (
    exists (
      select 1 from public.order_items oi
      where oi.id = order_reference_images.order_item_id
        and (
          public.customer_owns_order(oi.order_id)
          or public.designer_owns_order(oi.order_id)
          or public.is_admin()
        )
    )
  );

create policy order_reference_images_insert on public.order_reference_images
  for insert with check (
    exists (
      select 1 from public.order_items oi
      where oi.id = order_reference_images.order_item_id
        and public.customer_owns_order(oi.order_id)
    )
  );

create policy order_status_history_select on public.order_status_history
  for select using (
    public.customer_owns_order(order_id)
    or public.designer_owns_order(order_id)
    or public.is_admin()
  );

create policy order_modifications_select on public.order_modifications
  for select using (
    public.customer_owns_order(order_id)
    or public.designer_owns_order(order_id)
    or public.is_admin()
  );

create policy order_modifications_insert on public.order_modifications
  for insert with check (public.customer_owns_order(order_id));

-- ---------------------------------------------------------------------------
-- Payments, refunds, store credit (read for owners; writes via backend/service role)
-- ---------------------------------------------------------------------------

create policy payments_select on public.payments
  for select using (
    public.customer_owns_order(order_id)
    or public.designer_owns_order(order_id)
    or public.is_admin()
  );

create policy refunds_select on public.refunds
  for select using (
    public.customer_owns_order(order_id)
    or public.designer_owns_order(order_id)
    or public.is_admin()
  );

create policy store_credits_select on public.store_credits
  for select using (
    customer_id = public.current_customer_id() or public.is_admin()
  );

create policy store_credit_transactions_select on public.store_credit_transactions
  for select using (
    customer_id = public.current_customer_id() or public.is_admin()
  );

-- ---------------------------------------------------------------------------
-- Reviews
-- ---------------------------------------------------------------------------

create policy reviews_public_read on public.reviews
  for select using (true);

create policy reviews_customer_insert on public.reviews
  for insert with check (
    customer_id = public.current_customer_id()
    and exists (
      select 1 from public.orders o
      where o.id = reviews.order_id
        and o.customer_id = public.current_customer_id()
        and o.status = 'DELIVERED'
    )
  );

create policy review_responses_public_read on public.review_responses
  for select using (true);

create policy review_responses_designer_insert on public.review_responses
  for insert with check (
    designer_id = public.current_designer_id()
    and exists (
      select 1 from public.reviews r
      where r.id = review_responses.review_id
        and r.designer_id = public.current_designer_id()
    )
  );

create policy notification_events_select on public.notification_events
  for select using (
    customer_id = public.current_customer_id() or public.is_admin()
  );

-- ---------------------------------------------------------------------------
-- Storage
-- ---------------------------------------------------------------------------

create policy design_images_public_select
  on storage.objects for select
  using (bucket_id = 'design-images');

create policy design_images_designer_insert
  on storage.objects for insert
  with check (
    bucket_id = 'design-images'
    and public.current_designer_id() is not null
  );

create policy design_images_designer_update
  on storage.objects for update
  using (
    bucket_id = 'design-images'
    and public.current_designer_id() is not null
  );

create policy design_images_designer_delete
  on storage.objects for delete
  using (
    bucket_id = 'design-images'
    and public.current_designer_id() is not null
  );

create policy reference_images_select
  on storage.objects for select
  using (
    bucket_id = 'reference-images'
    and (
      auth.uid()::text = (storage.foldername(name))[1]
      or public.current_designer_id() is not null
      or public.is_admin()
    )
  );

create policy reference_images_insert
  on storage.objects for insert
  with check (
    bucket_id = 'reference-images'
    and auth.uid() is not null
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy reference_images_delete
  on storage.objects for delete
  using (
    bucket_id = 'reference-images'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
