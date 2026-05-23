import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/strings.dart';
import '../core/theme.dart';
import '../widgets/ai_magic.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/photo.dart';
import '../widgets/primitives.dart';

// ── EDITOR C — Hybrid (recommended) ─────────────────────────────────────────
class EditorC extends StatelessWidget {
  const EditorC({super.key});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final lang = GlowTheme.of(context).config.lang;
    return GlowScreen(
      child: Stack(
        children: [
          Positioned(
            top: 54,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GlowIcon('chevron_l', size: 22, color: t.text),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aura Serum',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: t.text,
                          ),
                        ),
                        Text(
                          'Edit · auto-saved 2s lalu',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: t.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    _IconButton(icon: 'swap'),
                    const SizedBox(width: 6),
                    _IconButton(icon: 'share'),
                    const SizedBox(width: 6),
                    GlowBtn(
                      variant: BtnVariant.primary,
                      size: BtnSize.sm,
                      child: Text(L.t('cta_done', lang)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Canvas
          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: Center(
              child: SizedBox(
                width: 370,
                height: 460,
                child: Stack(
                  children: [
                    const PhotoPlaceholder(
                      variant: PhotoVariant.enhanced,
                      product: ProductKind.skincare,
                      width: 370,
                      height: 460,
                      radius: 14,
                    ),
                    // Edit badges
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Badge(
                            icon: 'layer',
                            text: '4 layers',
                          ),
                          const SizedBox(height: 6),
                          _DotBadge(text: 'AI: scene gen', color: t.ai),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const GlowIcon('eye', size: 12, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              'Tahan untuk before',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
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
          // AI prompt bar
          Positioned(
            top: 590,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
              decoration: BoxDecoration(
                color: t.surface,
                border: Border.all(color: t.ai.withValues(alpha: 0.25)),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: t.ai.withValues(alpha: 0.08),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const AIOrb(size: 32, glow: false),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'taro di scene cafe Bali sore hari',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: t.text,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [t.accent, t.ai],
                      ),
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: t.accent.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const GlowIcon(
                      'arrow_r',
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Quick adjust
          Positioned(
            top: 670,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    'QUICK ADJUST',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: t.muted,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: 56,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _QuickAdjust(
                          value: '+12',
                          label: 'Exposure',
                          highlight: true),
                      const SizedBox(width: 10),
                      _QuickAdjust(value: '-34', label: 'Highlights'),
                      const SizedBox(width: 10),
                      _QuickAdjust(value: '+28', label: 'Shadows'),
                      const SizedBox(width: 10),
                      _QuickAdjust(value: '+15', label: 'Saturation'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tool dock
          Positioned(
            left: 16,
            right: 16,
            bottom: 36,
            child: Row(
              children: [
                Expanded(
                  child: _ToolDockBtn(
                    icon: 'sparkle',
                    label: 'Auto',
                    glow: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      _ToolDockBtn(icon: 'settings', label: 'Tools'),
                ),
                const SizedBox(width: 8),
                Expanded(child: _ToolDockBtn(icon: 'bg', label: 'Scene')),
                const SizedBox(width: 8),
                Expanded(child: _ToolDockBtn(icon: 'text', label: 'Text')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final String icon;
  const _IconButton({required this.icon});
  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: GlowIcon(icon, size: 14, color: t.text),
    );
  }
}

class _Badge extends StatelessWidget {
  final String icon;
  final String text;
  const _Badge({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlowIcon(icon, size: 11, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _DotBadge({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAdjust extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;
  const _QuickAdjust({
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: highlight ? t.accent : t.line),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: highlight ? t.accent : t.muted,
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

class _ToolDockBtn extends StatelessWidget {
  final String icon;
  final String label;
  final bool glow;
  const _ToolDockBtn({
    required this.icon,
    required this.label,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: glow
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [t.accent, t.ai],
              )
            : null,
        color: glow ? null : t.surface,
        border: glow ? null : Border.all(color: t.line),
        borderRadius: BorderRadius.circular(14),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: t.accent.withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlowIcon(
            icon,
            size: 18,
            color: glow ? Colors.white : t.text2,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: glow ? Colors.white : t.text2,
            ),
          ),
        ],
      ),
    );
  }
}
