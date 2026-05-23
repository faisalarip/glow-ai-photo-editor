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
└── screens/
    ├── onboarding.dart            # A · welcome / B · features / C · live AI demo loop
    ├── home.dart                  # Home (feed)
    ├── editor.dart                # Hybrid editor (tools + AI prompt)
    ├── ai_recs.dart               # AI Recommendations + BrandMatchMeter
    ├── flow.dart                  # Export sheet + Brand Inbox
    ├── templates_compare.dart     # Templates gallery + Before/After slider
    └── library_profile_paywall.dart # Library, Profile, Paywall · Glow Pro
```

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
