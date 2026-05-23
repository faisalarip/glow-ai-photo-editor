import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

// ── LIBRARY ──────────────────────────────────────────────────────────────────
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _projects = <_Project>[
    _Project('Aura Serum', PhotoVariant.enhanced, ProductKind.skincare, '14 Mei',
        5, 'Done', 'Aura'),
    _Project('Sonder Outfit', PhotoVariant.moody, ProductKind.fashion, '12 Mei',
        8, 'Draft', 'Sonder'),
    _Project('Bali Bites Menu', PhotoVariant.pastel, ProductKind.food, '10 Mei',
        12, 'Done', 'Bali Bites'),
    _Project('Lumo Light', PhotoVariant.studio, ProductKind.gadget, '8 Mei', 3,
        'In Edit', 'Lumo'),
    _Project('Morning Self', PhotoVariant.night, ProductKind.skincare, '6 Mei',
        4, 'Done', null),
    _Project('Hush Routine', PhotoVariant.pastel, ProductKind.skincare, '4 Mei',
        7, 'Done', 'Hush'),
  ];

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final statusColor = <String, Color>{
      'Done': t.success,
      'Draft': t.warn,
      'In Edit': t.info,
    };
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 56,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      '142 foto · 2.4 GB',
                      style: GoogleFonts.inter(fontSize: 12, color: t.muted),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _ViewToggle(icon: 'grid', active: true),
                    const SizedBox(width: 8),
                    _ViewToggle(icon: 'list'),
                  ],
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
                children: const [
                  GlowChip(active: true, child: Text('Semua')),
                  SizedBox(width: 6),
                  GlowChip(child: Text('Done')),
                  SizedBox(width: 6),
                  GlowChip(child: Text('Draft')),
                  SizedBox(width: 6),
                  GlowChip(child: Text('Sponsored')),
                  SizedBox(width: 6),
                  GlowChip(child: Text('Personal')),
                ],
              ),
            ),
          ),
          Positioned(
            top: 188,
            left: 16,
            right: 16,
            bottom: 100,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: _projects.length,
              itemBuilder: (_, i) {
                final p = _projects[i];
                final sc = statusColor[p.status] ?? t.muted;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 228,
                      child: Stack(
                        children: [
                          PhotoPlaceholder(
                            variant: p.variant,
                            product: p.product,
                            width: 172,
                            height: 228,
                            radius: 12,
                          ),
                          if (p.count > 1)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const GlowIcon('layer',
                                        size: 10, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${p.count}',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (p.brand != null)
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: BrandMark(name: p.brand!, size: 24),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  p.label,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: t.text,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: 6,
                                height: 6,
                                decoration:
                                    BoxDecoration(color: sc, shape: BoxShape.circle),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Text(
                            '${p.date} · ${p.status}',
                            style: GoogleFonts.inter(fontSize: 10, color: t.muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlowTabBar(active: 'library'),
          ),
        ],
      ),
    );
  }
}

class _Project {
  final String label;
  final PhotoVariant variant;
  final ProductKind product;
  final String date;
  final int count;
  final String status;
  final String? brand;
  const _Project(this.label, this.variant, this.product, this.date, this.count,
      this.status, this.brand);
}

class _ViewToggle extends StatelessWidget {
  final String icon;
  final bool active;
  const _ViewToggle({required this.icon, this.active = false});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: GlowIcon(icon, size: 16, color: active ? t.accent : t.muted),
    );
  }
}

// ── PROFILE ──────────────────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 56,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profil',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: t.text,
                    letterSpacing: -1,
                  ),
                ),
                GlowIcon('settings', size: 22, color: t.text),
              ],
            ),
          ),
          // Profile card
          Positioned(
            top: 110,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.line),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [t.accent, t.ai],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const ClipOval(
                      child: Avatar(name: 'Andin', size: 59),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Andin Pradipta',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: t.text,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '@andin.id · 124k followers',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: t.muted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GlowChip(
                              size: ChipSize.sm,
                              bgOverride: t.accent.withValues(alpha: 0.12),
                              textOverride: t.accent,
                              borderOverride:
                                  t.accent.withValues(alpha: 0.25),
                              icon:
                                  GlowIcon('star', size: 11, color: t.accent),
                              child: const Text('Pro'),
                            ),
                            const SizedBox(width: 6),
                            const GlowChip(
                              size: ChipSize.sm,
                              child: Text('Beauty · Lifestyle'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Stats
          Positioned(
            top: 270,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Expanded(child: _Stat(label: 'Foto', value: '342')),
                const SizedBox(width: 8),
                Expanded(child: _Stat(label: 'Brief', value: '28')),
                const SizedBox(width: 8),
                Expanded(child: _Stat(label: 'Earnings', value: 'Rp 124jt')),
              ],
            ),
          ),
          // Menu list
          Positioned(
            top: 370,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.line),
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: const [
                  _MenuRow(icon: 'palette', label: 'Brand kit kamu', sub: '3 mood disimpan'),
                  _MenuRow(icon: 'money', label: 'Pendapatan & withdraw', sub: 'Rp 4.2jt available'),
                  _MenuRow(icon: 'flag', label: 'Goals minggu ini', sub: '4 dari 7 selesai'),
                  _MenuRow(icon: 'bell', label: 'Notifikasi', sub: 'Push + email'),
                  _MenuRow(icon: 'lock', label: 'Privasi & keamanan', last: true),
                ],
              ),
            ),
          ),
          // Pro upsell
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    t.accent.withValues(alpha: 0.08),
                    t.ai.withValues(alpha: 0.08),
                  ],
                ),
                border: Border.all(
                  color: t.accent.withValues(alpha: 0.38),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text('⚡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Glow Pro',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: t.text,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Unlimited edit + scene generator',
                          style:
                              GoogleFonts.inter(fontSize: 11, color: t.muted),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Upgrade →',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: t.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlowTabBar(active: 'profile'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: t.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 10, color: t.muted),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String icon;
  final String label;
  final String? sub;
  final bool last;
  const _MenuRow({
    required this.icon,
    required this.label,
    this.sub,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: t.line)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: t.surface2,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: GlowIcon(icon, size: 16, color: t.text2),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    sub!,
                    style: GoogleFonts.inter(fontSize: 11, color: t.muted),
                  ),
                ],
              ],
            ),
          ),
          GlowIcon('chevron_r', size: 16, color: t.muted),
        ],
      ),
    );
  }
}

// ── PAYWALL ──────────────────────────────────────────────────────────────────
class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  static const _plans = [
    ('monthly', 'Bulanan', 'Rp 49rb', 'per bulan', false, null),
    ('yearly', 'Tahunan', 'Rp 399rb', 'Rp 33rb/bulan', true, 'Hemat 32%'),
    ('lifetime', 'Lifetime', 'Rp 1.49jt', 'bayar sekali', false, null),
  ];

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return GlowScreen(
      child: Stack(
        children: [
          // Gradient header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 280,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 1),
                  radius: 0.9,
                  colors: [
                    t.accent.withValues(alpha: 0.19),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Close
          Positioned(
            top: 60,
            right: 20,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.line),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: GlowIcon('close', size: 16, color: t.text),
            ),
          ),
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: t.accent.withValues(alpha: 0.12),
                  border: Border.all(color: t.accent.withValues(alpha: 0.25)),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlowIcon('sparkle', size: 14, color: t.accent),
                    const SizedBox(width: 10),
                    Text(
                      'GLOW PRO',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: t.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 165,
            left: 24,
            right: 24,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: t.text,
                  letterSpacing: -1,
                  height: 1.1,
                ),
                children: [
                  const TextSpan(text: 'Edit tanpa batas.\n'),
                  WidgetSpan(
                    child: ShaderMask(
                      shaderCallback: (r) =>
                          LinearGradient(colors: [t.accent, t.ai]).createShader(r),
                      child: Text(
                        'Jadi creator pro.',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Features
          Positioned(
            top: 300,
            left: 24,
            right: 24,
            child: Column(
              children: const [
                _PaywallFeature(
                    text: 'Unlimited AI enhance',
                    sub: 'No watermark, no batch limit'),
                _PaywallFeature(
                    text: 'Scene generator + style transfer',
                    sub: '40+ template eksklusif'),
                _PaywallFeature(
                    text: 'Brand kit & multi-format export',
                    sub: 'Auto-sync ke 8 platform'),
                _PaywallFeature(
                    text: 'Priority brief dari brand',
                    sub: '+30% rate average'),
              ],
            ),
          ),
          // Plans
          Positioned(
            top: 540,
            left: 20,
            right: 20,
            child: Row(
              children: _plans.map((p) {
                final active = p.$1 == 'yearly';
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: active
                                ? t.accent.withValues(alpha: 0.08)
                                : t.surface,
                            border: Border.all(
                              color: active ? t.accent : t.line,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                p.$2,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: t.muted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.$3,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: t.text,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                p.$4,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: t.muted,
                                ),
                              ),
                              if (p.$6 != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  p.$6!,
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: t.success,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (p.$5)
                          Positioned(
                            top: -8,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: t.accent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'POPULAR',
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
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
            left: 20,
            right: 20,
            bottom: 40,
            child: Column(
              children: [
                const GlowBtn(
                  variant: BtnVariant.glow,
                  size: BtnSize.lg,
                  block: true,
                  child: Text('Mulai Pro · 7 hari gratis'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cancel kapan aja · Auto-renew · Terms',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: t.muted,
                    height: 1.5,
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

class _PaywallFeature extends StatelessWidget {
  final String text;
  final String sub;
  const _PaywallFeature({required this.text, required this.sub});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: t.success,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const GlowIcon(
              'check',
              size: 13,
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  sub,
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
