import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

// ── TEMPLATES ────────────────────────────────────────────────────────────────
class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  static const _categories = ['Semua', 'Beauty', 'Fashion', 'Food', 'Tech', 'Lifestyle'];
  static const _templates = <_Template>[
    _Template('Marble Studio', PhotoVariant.enhanced, ProductKind.skincare,
        'Beauty', false),
    _Template('Editorial Soft', PhotoVariant.moody, ProductKind.skincare,
        'Beauty', true),
    _Template('Street Lookbook', PhotoVariant.night, ProductKind.fashion,
        'Fashion', false),
    _Template('Pastel Dreamy', PhotoVariant.pastel, ProductKind.skincare,
        'Beauty', false),
    _Template('Bali Sunset', PhotoVariant.enhanced, ProductKind.food, 'Food', true),
    _Template('Studio Clean', PhotoVariant.studio, ProductKind.gadget, 'Tech',
        false),
  ];

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Template scene',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: t.text,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      '240+ template, 1-tap apply',
                      style: GoogleFonts.inter(fontSize: 12, color: t.muted),
                    ),
                  ],
                ),
                GlowIcon('search', size: 22, color: t.text),
              ],
            ),
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) =>
                    GlowChip(active: i == 0, child: Text(_categories[i])),
              ),
            ),
          ),
          Positioned(
            top: 184,
            left: 16,
            right: 16,
            bottom: 100,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 172 / 228,
              ),
              itemCount: _templates.length,
              itemBuilder: (_, i) => _TemplateCard(tmpl: _templates[i]),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlowTabBar(active: 'studio'),
          ),
        ],
      ),
    );
  }
}

class _Template {
  final String name;
  final PhotoVariant variant;
  final ProductKind product;
  final String category;
  final bool pro;
  const _Template(
      this.name, this.variant, this.product, this.category, this.pro);
}

class _TemplateCard extends StatelessWidget {
  final _Template tmpl;
  const _TemplateCard({required this.tmpl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => Stack(
        children: [
          Positioned.fill(
            child: PhotoPlaceholder(
              variant: tmpl.variant,
              product: tmpl.product,
              width: c.maxWidth,
              height: c.maxHeight,
              radius: 14,
            ),
          ),
        if (tmpl.pro)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const GlowIcon('star', size: 9, color: Color(0xFFFFD580)),
                  const SizedBox(width: 3),
                  Text(
                    'PRO',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFFD580),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tmpl.name,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  tmpl.category,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    );
  }
}

// ── BEFORE / AFTER ───────────────────────────────────────────────────────────
class BeforeAfterScreen extends StatefulWidget {
  const BeforeAfterScreen({super.key});
  @override
  State<BeforeAfterScreen> createState() => _BeforeAfterScreenState();
}

class _BeforeAfterScreenState extends State<BeforeAfterScreen> {
  double sliderPos = 0.55;

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    const w = 370.0;
    const h = 500.0;
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
                GlowIcon('chevron_l', size: 22, color: t.text),
                Text(
                  'Sebelum vs Sesudah',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: t.text,
                  ),
                ),
                GlowIcon('share', size: 20, color: t.text),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: Center(
              child: SizedBox(
                width: w,
                height: h,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) {
                    setState(() {
                      sliderPos =
                          (sliderPos + d.delta.dx / w).clamp(0.0, 1.0);
                    });
                  },
                  child: Stack(
                    children: [
                      const PhotoPlaceholder(
                        variant: PhotoVariant.raw,
                        product: ProductKind.skincare,
                        width: w,
                        height: h,
                        radius: 16,
                      ),
                      ClipPath(
                        clipper: _VerticalClipper(sliderPos),
                        child: const PhotoPlaceholder(
                          variant: PhotoVariant.enhanced,
                          product: ProductKind.skincare,
                          width: w,
                          height: h,
                          radius: 16,
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'BEFORE',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: t.accent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'AFTER',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: sliderPos * w - 1,
                        child: Container(width: 2, color: Colors.white),
                      ),
                      Positioned(
                        left: sliderPos * w - 24,
                        top: h / 2 - 24,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GlowIcon('chevron_l', size: 16, color: t.bg),
                              GlowIcon('chevron_r', size: 16, color: t.bg),
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
          Positioned(
            top: 630,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'APA YANG BERUBAH',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: t.muted,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: t.surface,
                    border: Border.all(color: t.line),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _ChangeRow(
                          label: 'Background',
                          value: 'Removed + studio scene',
                          color: t.accent),
                      _ChangeRow(
                          label: 'Lighting',
                          value: '+12 EV · warm grade',
                          color: t.warn),
                      _ChangeRow(
                          label: 'Color',
                          value: 'Match brand kit Aura',
                          color: t.ai),
                      _ChangeRow(
                          label: 'Skin',
                          value: 'Auto retouch · soft',
                          color: t.success,
                          last: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 36,
            child: Row(
              children: [
                const Expanded(
                  child: GlowBtn(
                    variant: BtnVariant.outline,
                    size: BtnSize.lg,
                    child: Text('Undo'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: GlowBtn(
                    variant: BtnVariant.primary,
                    size: BtnSize.lg,
                    icon:
                        const GlowIcon('check', size: 18, color: Colors.white),
                    child: const Text('Pakai versi ini'),
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

class _VerticalClipper extends CustomClipper<Path> {
  final double pos;
  _VerticalClipper(this.pos);
  @override
  Path getClip(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, size.width * pos, size.height));
  }

  @override
  bool shouldReclip(_VerticalClipper old) => old.pos != pos;
}

class _ChangeRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool last;
  const _ChangeRow({
    required this.label,
    required this.value,
    required this.color,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: last ? null : Border(bottom: BorderSide(color: t.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: t.text2,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: t.text,
            ),
          ),
        ],
      ),
    );
  }
}
