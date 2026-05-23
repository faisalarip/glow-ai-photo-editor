import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/ai_magic.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

class AIRecsScreen extends StatelessWidget {
  const AIRecsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 56,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AIOrb(size: 36, glow: false),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI PICK',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: t.ai,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Personalized untuk Andin',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: t.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Cocok buat brief\nAura Skincare 🤍',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: t.text,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI baca brand kit Aura + audience kamu, lalu kasih 6 template paling match.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: t.muted,
                  ),
                ),
              ],
            ),
          ),
          // Top match card
          Positioned(
            top: 220,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: t.accent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: t.accent.withValues(alpha: 0.25),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 240,
                  child: Stack(
                    children: [
                      const PhotoPlaceholder(
                        variant: PhotoVariant.moody,
                        product: ProductKind.skincare,
                        width: 370,
                        height: 240,
                        radius: 0,
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: t.accent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '★ TOP MATCH',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const BrandMatchMeter(
                            value: 96,
                            size: 68,
                            label: 'match',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Editorial Soft Beauty',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Match brand mood · Avg ER 7.2%',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // More recs
          Positioned(
            top: 490,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Juga cocok',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                        child:
                            _RecThumb(variant: PhotoVariant.pastel, score: 92)),
                    SizedBox(width: 8),
                    Expanded(
                        child: _RecThumb(
                            variant: PhotoVariant.enhanced, score: 88)),
                    SizedBox(width: 8),
                    Expanded(
                        child: _RecThumb(variant: PhotoVariant.night, score: 81)),
                  ],
                ),
              ],
            ),
          ),
          // Why this
          Positioned(
            top: 680,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.ai.withValues(alpha: 0.06),
                border: Border.all(color: t.ai.withValues(alpha: 0.19)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GlowIcon('sparkle', size: 12, color: t.ai),
                      const SizedBox(width: 6),
                      Text(
                        'WHY THIS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: t.ai,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: t.text2,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Brand Aura pakai palette warm + editorial. 3 post terakhir dengan mood ini hit ',
                        ),
                        TextSpan(
                          text: '+34% engagement',
                          style: GoogleFonts.inter(
                            color: t.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 36,
            child: GlowBtn(
              variant: BtnVariant.glow,
              size: BtnSize.lg,
              block: true,
              icon: const GlowIcon('sparkle', size: 18, color: Colors.white),
              child: const Text('Apply top match'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecThumb extends StatelessWidget {
  final PhotoVariant variant;
  final int score;
  const _RecThumb({required this.variant, required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          PhotoPlaceholder(
            variant: variant,
            product: ProductKind.skincare,
            width: double.infinity,
            height: 150,
            radius: 10,
          ),
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '$score%',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
