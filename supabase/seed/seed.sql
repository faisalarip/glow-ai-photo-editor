-- Seed brands + briefs so a fresh Supabase project has data to render. Safe to
-- re-run: every insert uses `on conflict do nothing`. Run from Studio SQL editor.

insert into public.brands (id, name, category, logo_color) values
  ('00000000-0000-0000-0000-000000000001', 'Aura',       'Skincare',  '#D9A877'),
  ('00000000-0000-0000-0000-000000000002', 'Sonder',     'Fashion',   '#FF6B9D'),
  ('00000000-0000-0000-0000-000000000003', 'Bali Bites', 'Food',      '#FF8A5C'),
  ('00000000-0000-0000-0000-000000000004', 'Lumo',       'Tech',      '#9B7DFF'),
  ('00000000-0000-0000-0000-000000000005', 'Hush',       'Lifestyle', '#7DD3A0')
on conflict (id) do nothing;

insert into public.briefs (brand_id, title, deliverables, rate, deadline, mood, product_kind, status) values
  ('00000000-0000-0000-0000-000000000001', 'Serum endorse', '5 foto + 1 reels',   'Rp 4.5jt + 8% komisi', '2026-05-21', 'pastel',  'skincare', 'open'),
  ('00000000-0000-0000-0000-000000000002', 'Summer lookbook', '8 outfit',          'Rp 8jt fixed',          '2026-05-25', 'night',   'fashion',  'open'),
  ('00000000-0000-0000-0000-000000000003', 'Menu launch',    '1 reels + carousel','Rp 3.2jt + dinner',     '2026-05-24', 'enhanced','food',     'open'),
  ('00000000-0000-0000-0000-000000000004', 'Smart light review', '3 foto',         'Rp 2.8jt + free unit',  '2026-05-29', 'moody',   'gadget',   'open'),
  ('00000000-0000-0000-0000-000000000005', 'Morning routine','1 vlog',             'Rp 5jt',                '2026-06-02', 'studio',  'skincare', 'open');
