import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../services/briefs_repo.dart';
import '../services/models/models.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

// ── EXPORT ───────────────────────────────────────────────────────────────────
class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  static const _formats = [
    ('TikTok', '9:16', Color(0xFFFE2C55), '♪', '1080×1920'),
    ('Instagram Reels', '9:16', null, '◉', '1080×1920'),
    ('Instagram Feed', '1:1', null, '◻', '1080×1080'),
    ('Shopee', '1:1', Color(0xFFEE4D2D), '⌂', '1024×1024'),
    ('Tokopedia', '4:5', Color(0xFF03AC0E), '⌂', '900×1125'),
    ('YouTube Shorts', '9:16', Color(0xFFFF0000), '▶', '1080×1920'),
  ];
  static const _selected = {0, 1, 2, 4};
  static const _gradients = <int, List<Color>>{
    1: [Color(0xFFFFC83C), Color(0xFFF9296F), Color(0xFFC13584)],
    2: [Color(0xFFF9296F), Color(0xFF833AB4)],
  };

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 54,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlowIcon('close', size: 22, color: t.text),
                Text(
                  'Export',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: t.text,
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
          ),
          // Preview
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  const PhotoPlaceholder(
                    variant: PhotoVariant.enhanced,
                    product: ProductKind.skincare,
                    width: 180,
                    height: 240,
                    radius: 12,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Aura Serum · Edit 4',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section header
          Positioned(
            top: 364,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih format',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4 dipilih · AI auto-crop tiap rasio',
                      style: GoogleFonts.inter(fontSize: 11, color: t.muted),
                    ),
                  ],
                ),
                Text(
                  'Pilih semua',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: t.accent,
                  ),
                ),
              ],
            ),
          ),
          // Format list
          Positioned(
            top: 414,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.line),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(_formats.length, (i) {
                  final f = _formats[i];
                  final selected = _selected.contains(i);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? t.accent.withValues(alpha: 0.06)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: _gradients[i] == null
                                ? null
                                : LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _gradients[i]!,
                                  ),
                            color: f.$3,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            f.$4,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.$1,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: t.text,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '${f.$2} · ${f.$5}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10,
                                  color: t.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: selected ? t.accent : Colors.transparent,
                            border: Border.all(
                              color: selected ? t.accent : t.line2,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: selected
                              ? const GlowIcon(
                                  'check',
                                  size: 13,
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                )
                              : null,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          // Options
          Positioned(
            top: 728,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(child: _Opt(label: 'Quality', value: 'High')),
                const SizedBox(width: 8),
                Expanded(child: _Opt(label: 'Format', value: 'PNG + JPG')),
              ],
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
              icon: const GlowIcon('download', size: 18, color: Colors.white),
              child: const Text('Export 4 format · 1 klik'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Opt extends StatelessWidget {
  final String label;
  final String value;
  const _Opt({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: t.muted,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.text,
                ),
              ),
              GlowIcon('chevron_d', size: 12, color: t.muted),
            ],
          ),
        ],
      ),
    );
  }
}

// ── BRAND INBOX ──────────────────────────────────────────────────────────────
class BrandInboxScreen extends StatefulWidget {
  const BrandInboxScreen({super.key});
  @override
  State<BrandInboxScreen> createState() => _BrandInboxScreenState();
}

class _BrandInboxScreenState extends State<BrandInboxScreen> {
  late final Future<List<Brief>> _briefsFuture = BriefsRepo.openBriefs();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  static const _weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  String _formatDeadline(DateTime d) {
    final wd = _weekdays[(d.weekday - 1) % 7];
    return '$wd, ${d.day} ${_months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return GlowScreen(
      child: FutureBuilder<List<Brief>>(
        future: _briefsFuture,
        builder: (context, snap) {
          final briefs = snap.data ?? const <Brief>[];
          final newCount = briefs.where((b) => b.isNew).length;
          return Stack(
            children: [
              Positioned(
                top: 56,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Inbox brief',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: t.text,
                            letterSpacing: -1,
                          ),
                        ),
                        GlowIcon('filter', size: 20, color: t.text),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snap.connectionState == ConnectionState.waiting
                          ? 'Memuat brief…'
                          : '$newCount brief baru · cocok ${briefs.length} untuk kamu',
                      style: GoogleFonts.inter(fontSize: 12, color: t.muted),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 134,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      GlowChip(
                          active: true,
                          child: Text('Semua · ${briefs.length}')),
                      const SizedBox(width: 6),
                      GlowChip(child: Text('Baru · $newCount')),
                      const SizedBox(width: 6),
                      const GlowChip(child: Text('High pay')),
                      const SizedBox(width: 6),
                      const GlowChip(child: Text('Beauty')),
                      const SizedBox(width: 6),
                      const GlowChip(child: Text('Fashion')),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 188,
                left: 16,
                right: 16,
                bottom: 100,
                child: snap.connectionState == ConnectionState.waiting
                    ? Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: t.accent,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: briefs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _BriefCard(
                          brief: briefs[i],
                          formatDeadline: _formatDeadline,
                        ),
                      ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GlowTabBar(active: 'briefs'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BriefCard extends StatelessWidget {
  final Brief brief;
  final String Function(DateTime) formatDeadline;
  const _BriefCard({required this.brief, required this.formatDeadline});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(
              color: brief.isNew
                  ? t.accent.withValues(alpha: 0.31)
                  : t.line,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandMark(name: brief.brandName, size: 42),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              brief.brandName,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: t.text,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: t.chip,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                brief.brandCategory,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: t.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          brief.title,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: t.text2,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: t.line)),
                ),
                child: Row(
                  children: [
                    GlowIcon('money', size: 12, color: t.success),
                    const SizedBox(width: 5),
                    Text(
                      brief.rate,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: t.success,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 1,
                      height: 12,
                      color: t.line,
                    ),
                    GlowIcon('flag', size: 12, color: t.muted),
                    const SizedBox(width: 5),
                    Text(
                      formatDeadline(brief.deadline),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: t.muted,
                      ),
                    ),
                    const Spacer(),
                    PhotoPlaceholder(
                      variant: brief.mood,
                      product: brief.productKind,
                      width: 28,
                      height: 36,
                      radius: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (brief.isNew)
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: t.accent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'BARU',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
