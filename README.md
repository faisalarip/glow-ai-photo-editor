# Glow — AI Photo Editor (Flutter)

AI photo editor for Indonesian content creators. Drop endorsement photos, AI handles background removal, scene generation, color grading, skin retouch, and multi-format export.

Flutter implementation of the [Claude Design](https://claude.ai/design) prototype. The original `HTML/JSX` mockup lives under `/Users/faisalnurarif/Documents/glow-ai-photo-editor`; this app re-creates the same visual language, design system, and 13 screens in Flutter so it can ship to iOS, Android, and the web from a single codebase.

## What's inside

```
lib/
├── core/
│   ├── theme.dart       # GlowConfig + palettes + accents + density
│   └── strings.dart     # ID + EN copy
├── widgets/
│   ├── glow_icon.dart   # ~40-icon set, inline-SVG-path painter
│   ├── glow_btn.dart    # primary / secondary / glow / ghost / outline / danger
│   ├── primitives.dart  # GlowLogo, Surface, Chip, Avatar, BrandMark, TabBar, ScreenFrame
│   ├── photo.dart       # PhotoPlaceholder (creator + product silhouette)
│   └── ai_magic.dart    # AIOrb, ScanLineFx, ParticleField, BrandMatchMeter, AICanvasOverlay…
├── services/
│   ├── env.dart                # --dart-define loader (SUPABASE_URL/SUPABASE_ANON_KEY)
│   ├── supabase_client.dart    # SupabaseInit + client accessor
│   ├── auth_service.dart       # signIn / signUp / signOut (no-ops when offline)
│   ├── profiles_repo.dart      # current user's profile
│   ├── briefs_repo.dart        # open briefs (joined with brand)
│   ├── projects_repo.dart      # owner's projects (joined with brand)
│   └── models/models.dart      # Profile, Brand, Brief, Project + enum mappers
└── screens/
    ├── onboarding.dart            # A · welcome / B · features / C · live AI demo loop
    ├── home.dart                  # Home (greeting + brief banner from repo)
    ├── editor.dart                # Hybrid editor (tools + AI prompt)
    ├── ai_recs.dart               # AI Recommendations + BrandMatchMeter
    ├── flow.dart                  # Export sheet + Brand Inbox (FutureBuilder over BriefsRepo)
    ├── templates_compare.dart     # Templates gallery + Before/After slider
    └── library_profile_paywall.dart # Library (ProjectsRepo), Profile (ProfilesRepo), Paywall
```

## Backend — Supabase

Schema lives under `supabase/migrations/0001_init.sql` — five tables (`profiles`, `brands`, `briefs`, `brief_applications`, `projects`) with row-level security and a trigger that auto-creates a profile on signup. Seed data is in `supabase/seed/seed.sql`.

### Setup (5 min)

1. **Create a Supabase project** at https://supabase.com/dashboard
2. **Run the schema** — open the SQL Editor in Supabase Studio, paste the contents of `supabase/migrations/0001_init.sql`, run. Then paste `supabase/seed/seed.sql` and run.
3. **Copy your project URL + anon key** from Project Settings → API
4. **Run the app with the keys passed in:**

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJh...
```

When `SUPABASE_URL` is unset, `Env.isConfigured == false` and every repo returns the original demo data — so you can keep iterating the UI offline without a backend.

### What's wired

- **Home A** → `ProfilesRepo.currentProfile()` (greeting) + `BriefsRepo.openBriefs()` (top banner)
- **Brand Inbox** → `BriefsRepo.openBriefs()` (full list with `brands` join, deadline formatting)
- **Library** → `ProjectsRepo.myProjects()` (grid with `brands` join, status mapping)
- **Profile** → `ProfilesRepo.currentProfile()` (name, handle, follower count, Pro/free chip)

The Editor, AI Recs, Templates, and Paywall remain static — they're either purely visual or need real AI/payment integrations (Replicate + RevenueCat) before they're worth wiring.

### Auth flow

The app boots into `_AuthGate` (`lib/main.dart`) which streams `auth.onAuthStateChange`:

- **No Supabase configured** → gate bypassed, shell renders with mock data
- **Configured + signed out** → `AuthScreen` (email/password, toggleable sign-in / sign-up)
- **Configured + signed in** → shell with live data; Profile → Library → "Keluar" row signs out

Sign-up does **email confirmation by default**. For local dev, turn it off at **Authentication → Sign In / Providers → Email → uncheck "Confirm email"** in Supabase Studio so you can land in the app immediately after signing up.

The Library screen has a floating **"+" button** that inserts a sample project (`ProjectsRepo.createSample`) tied to the current user — that's the simplest way to verify auth + RLS + the user-scoped read all work end-to-end.

### What's not in scope yet

- **Storage** — original/edited photos. Pattern: bucket per-user, `projects.photo_path` column pointing at `${owner_id}/${project_id}/edit.jpg`.
- **AI pipeline** — when the user taps "Generate" in Editor, hit a Supabase Edge Function that calls Replicate / fal.ai and updates a `projects.edit_jobs` row with progress.
- **Payments** — Paywall → RevenueCat → webhook → `profiles.tier = 'pro'`.

## Design tokens

Ported 1:1 from `primitives.jsx`:

- **Themes** — `dark` (default) + `light`
- **Accents** — coral, azure, matcha, candy, amber (toggled via the tweaks sheet)
- **Density** — `compact / regular / comfy` (scales button heights, surface padding)
- **Languages** — `id / en` (toggled live)
- **Phone frame** — optional iOS-style frame overlay

Drives every screen through the `GlowTheme` inherited widget — flipping a tweak ripples to all 13 screens.

## Run

```bash
flutter pub get
flutter run -d chrome      # web preview (fastest)
flutter run                # macOS / iOS sim / Android
```

The first launch lands on **Onboarding C** — the live AI demo loop screen (orb breathing, scan line sweeping, particles drifting, photo crossfading between raw → enhanced → moody → pastel). The chevrons on either side of the device frame walk through all 13 designs; the **Auto-demo** pill at the top-left cycles through them every 3.2s. **Tweaks** pill at the top-right opens the theme / accent / density / language / frame controls.

## Provenance

- README and chats: `/tmp/design_extract/ai-photo-editor/` (extracted from the Claude Design handoff bundle)
- Original HTML prototype: `/Users/faisalnurarif/Documents/glow-ai-photo-editor/`
