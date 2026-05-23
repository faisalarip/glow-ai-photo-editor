import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/strings.dart';
import '../core/theme.dart';
import '../services/briefs_repo.dart';
import '../services/models/models.dart';
import '../services/profiles_repo.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

// ── HOME A — Feed-style (Lightroom Mobile inspired) ─────────────────────────
class HomeA extends StatefulWidget {
  const HomeA({super.key});
  @override
  State<HomeA> createState() => _HomeAState();
}

class _HomeAState extends State<HomeA> {
  late final Future<Profile> _profile = ProfilesRepo.currentProfile();
  late final Future<List<Brief>> _briefs = BriefsRepo.openBriefs();

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final lang = GlowTheme.of(context).config.lang;
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 54,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L.t('greeting', lang),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: t.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    FutureBuilder<Profile>(
                      future: _profile,
                      builder: (_, snap) {
                        final first = (snap.data?.fullName ?? 'Andin')
                            .split(' ')
                            .first;
                        return Text(
                          '$first ✨',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: t.text,
                            letterSpacing: -1,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: t.surface,
                        border: Border.all(color: t.line),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Center(
                            child: GlowIcon('bell', size: 18, color: t.text),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: t.accent,
                                shape: BoxShape.circle,
                                border: Border.all(color: t.surface, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Avatar(name: 'Andin', size: 40),
                  ],
                ),
              ],
            ),
          ),
          // Hero card
          Positioned(
            top: 130,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [t.accent, t.ai],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 14,
                    child: GlowIcon(
                      'sparkle',
                      size: 56,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1-TAP MAGIC',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Drop foto, AI\nyang kerjain',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rata-rata 2.4 detik',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 14),
                      GlowBtn(
                        variant: BtnVariant.secondary,
                        size: BtnSize.sm,
                        icon: GlowIcon('plus', size: 14, color: t.text),
                        child: const Text('Foto baru'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Brief notification (live from BriefsRepo)
          Positioned(
            top: 320,
            left: 20,
            right: 20,
            child: FutureBuilder<List<Brief>>(
              future: _briefs,
              builder: (_, snap) {
                final brief = (snap.data?.isNotEmpty ?? false)
                    ? snap.data!.first
                    : null;
                final brand = brief?.brandName ?? 'Aura';
                final sub = brief != null
                    ? '${brief.title.split(' · ').first}, ${brief.rate}'
                    : 'Endorse serum, Rp 4.5jt + komisi 8%';
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: t.surface,
                    border: Border.all(color: t.line),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      BrandMark(name: brand, size: 42),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '$brand ${brief?.brandCategory ?? 'Skincare'}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: t.text,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: t.accent.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'BRIEF BARU',
                                    style: GoogleFonts.inter(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: t.accent,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              sub,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: t.muted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GlowIcon('chevron_r', size: 18, color: t.muted),
                    ],
                  ),
                );
              },
            ),
          ),
          // Recent projects
          Positioned(
            top: 416,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Project terakhir',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: t.text,
                        ),
                      ),
                      Text(
                        L.t('cta_view_all', lang),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: t.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _ProjectTile(
                        variant: PhotoVariant.enhanced,
                        product: ProductKind.skincare,
                        label: 'Aura Serum',
                        time: '2j',
                      ),
                      const SizedBox(width: 10),
                      _ProjectTile(
                        variant: PhotoVariant.moody,
                        product: ProductKind.fashion,
                        label: 'Sonder Tee',
                        time: '1h',
                      ),
                      const SizedBox(width: 10),
                      _ProjectTile(
                        variant: PhotoVariant.pastel,
                        product: ProductKind.food,
                        label: 'Bali Bites',
                        time: '2h',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // AI recs strip
          Positioned(
            top: 662,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI rekomendasi buat kamu',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: t.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GlowChip(
                      size: ChipSize.sm,
                      bgOverride: t.ai.withValues(alpha: 0.12),
                      textOverride: t.ai,
                      borderOverride: t.ai.withValues(alpha: 0.25),
                      icon: GlowIcon('sparkle', size: 11, color: t.ai),
                      child: const Text('NEW'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _RecCard(
                        text: 'Beauty mood',
                        gradient: const [Color(0xFFFF6B9D), Color(0xFFC44569)],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RecCard(
                        text: 'Street style',
                        gradient: const [Color(0xFFFF8A5C), Color(0xFFB85C3F)],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RecCard(
                        text: 'Cafe vibe',
                        gradient: const [Color(0xFF9B7DFF), Color(0xFF5B3DAA)],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlowTabBar(active: 'home'),
          ),
        ],
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final PhotoVariant variant;
  final ProductKind product;
  final String label;
  final String time;
  const _ProjectTile({
    required this.variant,
    required this.product,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhotoPlaceholder(
            variant: variant,
            product: product,
            width: 130,
            height: 170,
            radius: 14,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: t.text,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '$time lalu',
            style: GoogleFonts.inter(fontSize: 10, color: t.muted),
          ),
        ],
      ),
    );
  }
}

class _RecCard extends StatelessWidget {
  final String text;
  final List<Color> gradient;
  const _RecCard({required this.text, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
