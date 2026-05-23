import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/strings.dart';
import '../core/theme.dart';
import '../widgets/ai_magic.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

// ── ONBOARDING A — Warm hero ─────────────────────────────────────────────────
class OnboardingA extends StatelessWidget {
  const OnboardingA({super.key});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final lang = GlowTheme.of(context).config.lang;
    return GlowScreen(
      child: Stack(
        children: [
          // Hero photo
          SizedBox(
            height: 540,
            width: double.infinity,
            child: Stack(
              children: [
                const PhotoPlaceholder(
                  variant: PhotoVariant.moody,
                  product: ProductKind.skincare,
                  width: 402,
                  height: 540,
                  radius: 0,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1],
                        colors: [Colors.transparent, t.bg],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  right: 30,
                  child: GlowIcon('sparkle', size: 28, color: t.accent),
                ),
              ],
            ),
          ),
          // Skip
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                L.t('cta_skip', lang),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Logo
          const Positioned(
            top: 56,
            left: 20,
            child: GlowLogo(size: 32, withText: true, textColor: Colors.white),
          ),
          // Headline
          Positioned(
            left: 24,
            right: 24,
            bottom: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: t.text,
                      letterSpacing: -1,
                      height: 1.05,
                    ),
                    children: [
                      const TextSpan(text: 'Foto endorse-an\n'),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            colors: [t.accent, t.ai],
                          ).createShader(rect),
                          child: Text(
                            'jadi cuan',
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -1,
                              height: 1.05,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' 1 ketuk.'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'AI Photo Editor untuk content creator Indonesia. Auto-enhance, ganti scene, generate caption — semua dari hp.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: t.muted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Dots + CTA
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == 0 ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == 0 ? t.accent : t.line2,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                GlowBtn(
                  variant: BtnVariant.glow,
                  size: BtnSize.lg,
                  block: true,
                  child: Text(L.t('cta_get_started', lang)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── ONBOARDING B — Feature highlights ────────────────────────────────────────
class OnboardingB extends StatelessWidget {
  const OnboardingB({super.key});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final lang = GlowTheme.of(context).config.lang;
    final features = const [
      ('sparkle', '1-tap Auto Enhance', 'Lightroom-grade dalam 2 detik.'),
      ('bg', 'Ganti scene apa aja', 'Cafe? Beach? Studio? AI yang urus.'),
      ('chat', 'Caption + hashtag', 'Match tone kamu, auto-generate.'),
      ('inbox', 'Brief brand langsung', 'Brand kirim brief, kamu eksekusi.'),
    ];
    return GlowScreen(
      child: Stack(
        children: [
          const Positioned(top: 80, left: 24, child: GlowLogo(size: 48)),
          Positioned(
            top: 150,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Built for creators.',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: t.text,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '4 feature yang bikin endorse-an kamu naik level.',
                  style:
                      GoogleFonts.inter(fontSize: 14, color: t.muted, height: 1.5),
                ),
              ],
            ),
          ),
          Positioned(
            top: 260,
            left: 24,
            right: 24,
            child: Column(
              children: features.map((f) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: t.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: t.line),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                t.accent.withValues(alpha: 0.19),
                                t.ai.withValues(alpha: 0.19),
                              ],
                            ),
                            border: Border.all(
                              color: t.accent.withValues(alpha: 0.25),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: GlowIcon(f.$1, size: 20, color: t.accent),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.$2,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: t.text,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                f.$3,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: t.muted,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              children: [
                GlowBtn(
                  variant: BtnVariant.primary,
                  size: BtnSize.lg,
                  block: true,
                  icon: const GlowIcon('arrow_r', size: 18, color: Colors.white),
                  child: Text(L.t('cta_continue', lang)),
                ),
                const SizedBox(height: 14),
                Text.rich(
                  TextSpan(
                    style:
                        GoogleFonts.inter(fontSize: 13, color: t.muted),
                    children: [
                      const TextSpan(text: 'Udah punya akun? '),
                      TextSpan(
                        text: 'Masuk',
                        style: GoogleFonts.inter(
                          color: t.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── ONBOARDING C — Live AI demo loop ─────────────────────────────────────────
class OnboardingC extends StatefulWidget {
  const OnboardingC({super.key});
  @override
  State<OnboardingC> createState() => _OnboardingCState();
}

class _OnboardingCState extends State<OnboardingC>
    with SingleTickerProviderStateMixin {
  static const _variants = [
    PhotoVariant.raw,
    PhotoVariant.enhanced,
    PhotoVariant.moody,
    PhotoVariant.pastel,
  ];
  late final AnimationController _progress;
  int _phase = 0;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _tick();
  }

  void _tick() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 2400));
      if (!mounted) return;
      setState(() => _phase = (_phase + 1) % _variants.length);
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final lang = GlowTheme.of(context).config.lang;
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.line),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                L.t('cta_skip', lang),
                style: GoogleFonts.inter(
                  color: t.text2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 56,
            left: 20,
            child: GlowLogo(size: 32, withText: true),
          ),
          Positioned(
            top: 130,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: t.ai.withValues(alpha: 0.12),
                    border: Border.all(color: t.ai.withValues(alpha: 0.25)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: t.ai,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: t.ai, blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE DEMO',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: t.ai,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Liat AI ngerjain\nfotomu real-time',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: t.text,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 260,
            left: 36,
            right: 36,
            child: Center(
              child: SizedBox(
                width: 330,
                height: 420,
                child: Stack(
                  children: [
                    for (int i = 0; i < _variants.length; i++)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 700),
                        opacity: i == _phase ? 1 : 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: PhotoPlaceholder(
                            variant: _variants[i],
                            product: ProductKind.skincare,
                            width: 330,
                            height: 420,
                            radius: 0,
                          ),
                        ),
                      ),
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (_, __) {
                        return Positioned.fill(
                          child: AICanvasOverlay(
                            progress: _progress.value,
                            radius: 22,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 700,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  'AI WORKFLOW',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: t.muted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 22,
                  child: AIStatusCycler(
                    interval: const Duration(milliseconds: 2400),
                    messages: const [
                      '1. Remove background',
                      '2. Generate studio scene',
                      '3. Color grade match brand',
                      '4. Smart skin retouch',
                    ],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: t.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == 2 ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == 2 ? t.accent : t.line2,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                GlowBtn(
                  variant: BtnVariant.glow,
                  size: BtnSize.lg,
                  block: true,
                  icon:
                      const GlowIcon('sparkle', size: 18, color: Colors.white),
                  child: Text(L.t('cta_get_started', lang)),
                ),
                const SizedBox(height: 12),
                Text(
                  '7 hari Pro gratis · no kartu kredit',
                  style: GoogleFonts.inter(fontSize: 11, color: t.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
