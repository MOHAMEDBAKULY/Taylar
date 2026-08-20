-- TailorFit MVP seed: one designer, catalog defaults, delivery cities.

-- ---------------------------------------------------------------------------
-- Categories
-- ---------------------------------------------------------------------------

insert into public.categories (id, name, slug, description) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001', 'Dresses', 'dresses', 'Custom dresses for women and girls'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002', 'Suits', 'suits', 'Tailored women''s suits and jackets'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0003', 'Skirts', 'skirts', 'Custom skirts in designer fabrics'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004', 'Tops', 'tops', 'Blouses and tailored tops'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005', 'Trousers', 'trousers', 'Custom trousers and pants'),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0006', 'Other', 'other', 'Other women''s clothing');

-- ---------------------------------------------------------------------------
-- Measurement types (cm)
-- ---------------------------------------------------------------------------

insert into public.measurement_types (
  id, name, unit, default_min, default_max, default_required, default_instructions
) values
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0001', 'Bust', 'cm', 50, 200, true, 'Measure around the fullest part of the bust, keeping the tape level.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0002', 'Waist', 'cm', 40, 180, true, 'Measure around the natural waistline.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0003', 'Hips', 'cm', 50, 200, true, 'Measure around the fullest part of the hips.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0004', 'Shoulder', 'cm', 20, 80, true, 'Measure from shoulder point to shoulder point across the back.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0005', 'Neck', 'cm', 20, 60, true, 'Measure around the base of the neck.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0006', 'Arm circumference', 'cm', 15, 70, true, 'Measure around the fullest part of the upper arm.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0007', 'Sleeve length', 'cm', 10, 90, true, 'Measure from the shoulder point down to the desired sleeve end.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0008', 'Dress length', 'cm', 40, 180, true, 'Measure from the highest shoulder point down to the desired hem.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0009', 'Jacket length', 'cm', 40, 120, true, 'Measure from the highest shoulder point down to the desired jacket hem.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0010', 'Skirt length', 'cm', 30, 140, true, 'Measure from the waist down to the desired skirt hem.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0011', 'Thigh', 'cm', 30, 120, true, 'Measure around the fullest part of the thigh.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0012', 'Knee', 'cm', 20, 80, true, 'Measure around the knee.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0013', 'Inseam', 'cm', 40, 120, true, 'Measure from the crotch down the inside leg to the ankle.'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbb0014', 'Outseam', 'cm', 50, 140, true, 'Measure from the waist down the outside of the leg to the ankle.');

-- Platform default category ↔ measurement associations
insert into public.category_measurements (
  designer_id, category_id, measurement_type_id, min_value, max_value, required, instructions
)
select
  null,
  c.category_id,
  mt.id,
  mt.default_min,
  mt.default_max,
  mt.default_required,
  mt.default_instructions
from public.measurement_types mt
join (
  values
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Bust'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Waist'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Hips'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Shoulder'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Neck'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Arm circumference'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Sleeve length'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001'::uuid, 'Dress length'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Bust'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Waist'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Shoulder'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Neck'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Arm circumference'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Sleeve length'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0002'::uuid, 'Jacket length'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0003'::uuid, 'Waist'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0003'::uuid, 'Hips'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0003'::uuid, 'Skirt length'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004'::uuid, 'Bust'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004'::uuid, 'Waist'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004'::uuid, 'Shoulder'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004'::uuid, 'Neck'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004'::uuid, 'Arm circumference'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0004'::uuid, 'Sleeve length'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005'::uuid, 'Waist'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005'::uuid, 'Hips'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005'::uuid, 'Thigh'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005'::uuid, 'Knee'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005'::uuid, 'Inseam'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0005'::uuid, 'Outseam'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0006'::uuid, 'Bust'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0006'::uuid, 'Waist'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0006'::uuid, 'Hips')
) as c(category_id, measurement_name)
  on mt.name = c.measurement_name;

-- ---------------------------------------------------------------------------
-- Designer (link user_id after Google OAuth in the dashboard)
-- ---------------------------------------------------------------------------

insert into public.designers (
  id, display_name, bio, telegram_username, production_time_days, is_active
) values (
  '22222222-2222-2222-2222-222222222222',
  'Amina Atelier',
  'Custom-made clothing for women and girls in Kenya. Share your measurements, choose fabric and color, and we will make it to fit.',
  'aminaatelier',
  14,
  true
);

insert into public.delivery_rules (designer_id, city, price_kes, is_available) values
  ('22222222-2222-2222-2222-222222222222', 'Mombasa', 400, true),
  ('22222222-2222-2222-2222-222222222222', 'Nairobi', 400, true),
  ('22222222-2222-2222-2222-222222222222', 'Nakuru', 400, true);

insert into public.custom_design_categories (designer_id, tier, price_kes) values
  ('22222222-2222-2222-2222-222222222222', 'Simple', 3000),
  ('22222222-2222-2222-2222-222222222222', 'Moderate', 6000),
  ('22222222-2222-2222-2222-222222222222', 'Complex', 10000);

insert into public.fabrics (id, designer_id, name, texture, price_kes) values
  ('cccccccc-cccc-cccc-cccc-cccccccc0001', '22222222-2222-2222-2222-222222222222', 'Cotton voile', 'Light, breathable, smooth', 1000),
  ('cccccccc-cccc-cccc-cccc-cccccccc0002', '22222222-2222-2222-2222-222222222222', 'Silk crepe', 'Soft drape with a subtle sheen', 2500),
  ('cccccccc-cccc-cccc-cccc-cccccccc0003', '22222222-2222-2222-2222-222222222222', 'Linen blend', 'Textured, airy, slightly slubbed', 1800);

insert into public.colors (id, designer_id, name, hex_code) values
  ('dddddddd-dddd-dddd-dddd-dddddddd0001', '22222222-2222-2222-2222-222222222222', 'Ivory', '#F7F1E5'),
  ('dddddddd-dddd-dddd-dddd-dddddddd0002', '22222222-2222-2222-2222-222222222222', 'Navy', '#1F2A44'),
  ('dddddddd-dddd-dddd-dddd-dddddddd0003', '22222222-2222-2222-2222-222222222222', 'Burgundy', '#6B1D2A');

insert into public.customization_options (id, designer_id, group_name, name, price_modifier_kes) values
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0001', '22222222-2222-2222-2222-222222222222', 'Sleeves', 'Sleeveless', 0),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0002', '22222222-2222-2222-2222-222222222222', 'Sleeves', 'Short sleeve', 200),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0003', '22222222-2222-2222-2222-222222222222', 'Sleeves', 'Long sleeve', 400),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0004', '22222222-2222-2222-2222-222222222222', 'Neck', 'Round', 0),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0005', '22222222-2222-2222-2222-222222222222', 'Neck', 'V-neck', 150),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0006', '22222222-2222-2222-2222-222222222222', 'Neck', 'Square', 150),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0007', '22222222-2222-2222-2222-222222222222', 'Neck', 'High neck', 200),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0008', '22222222-2222-2222-2222-222222222222', 'Length', 'Short', 0),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0009', '22222222-2222-2222-2222-222222222222', 'Length', 'Medium', 200),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeee0010', '22222222-2222-2222-2222-222222222222', 'Length', 'Long', 400);

insert into public.designs (
  id, designer_id, category_id, name, description, estimated_production_days, is_published
) values
  (
    'ffffffff-ffff-ffff-ffff-ffffffff0001',
    '22222222-2222-2222-2222-222222222222',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0001',
    'Evening Dress',
    'A fitted evening dress made to your measurements. Choose fabric, color, sleeves, and length.',
    14,
    true
  ),
  (
    'ffffffff-ffff-ffff-ffff-ffffffff0002',
    '22222222-2222-2222-2222-222222222222',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0003',
    'Tailored Skirt',
    'A custom skirt with your choice of fabric, color, and length. Pair it with a blouse or jacket.',
    10,
    true
  );
