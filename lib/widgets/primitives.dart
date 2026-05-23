import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';
import '../core/strings.dart';
import 'glow_icon.dart';

/// Ports the small atoms: GlowLogo, Surface, Chip, ShimmerOverlay,
/// AIProcessingChip, StatusBar, Avatar, BrandMark, ToneSlider.

// ── Logo / wordmark ──────────────────────────────────────────────────────────
class GlowLogo extends StatelessWidget {
  final double size;
  final bool withText;
  final Color? textColor;

  const GlowLogo({
    super.key,
    this.size = 28,
    this.withText = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [t.accent, t.ai],
            ),
            boxShadow: [
              BoxShadow(
                color: t.accent.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: CustomPaint(
            size: Size(size * 0.6, size * 0.6),
            painter: _StarPainter(Colors.white),
          ),
        ),
        if (withText) ...[
          SizedBox(width: size * 0.28),
          Text(
            'Glow',
            style: GoogleFonts.inter(
              fontSize: size * 0.78,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: textColor ?? t.text,
            ),
          ),
        ],
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final w = size.width;
    final path = Path()
      ..moveTo(w * 0.5, w * 0.08)
      ..lineTo(w * 0.56, w * 0.38)
      ..lineTo(w * 0.83, w * 0.44)
      ..lineTo(w * 0.56, w * 0.5)
      ..lineTo(w * 0.5, w * 0.79)
      ..lineTo(w * 0.44, w * 0.5)
      ..lineTo(w * 0.17, w * 0.44)
      ..lineTo(w * 0.44, w * 0.38)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}

// ── Surface ──────────────────────────────────────────────────────────────────
class GlowSurface extends StatelessWidget {
  final Widget child;
  final bool padded;
  final bool raised;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final VoidCallback? onTap;

  const GlowSurface({
    super.key,
    required this.child,
    this.padded = true,
    this.raised = false,
    this.padding,
    this.radius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlowTheme.of(context);
    final t = theme.palette;
    final r = radius ?? theme.d(18);
    final pad = padded ? (padding ?? EdgeInsets.all(theme.d(16))) : EdgeInsets.zero;
    final body = Container(
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(r),
        boxShadow: raised
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                      alpha: t.name == 'dark' ? 0.4 : 0.1),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      padding: pad,
      child: child,
    );
    if (onTap == null) return body;
    return GestureDetector(onTap: onTap, child: body);
  }
}

// ── Chip / Pill ──────────────────────────────────────────────────────────────
enum ChipSize { sm, md, lg }

class GlowChip extends StatelessWidget {
  final Widget child;
  final bool active;
  final Widget? icon;
  final Color? color;
  final ChipSize size;
  final Color? bgOverride;
  final Color? textOverride;
  final Color? borderOverride;

  const GlowChip({
    super.key,
    required this.child,
    this.active = false,
    this.icon,
    this.color,
    this.size = ChipSize.md,
    this.bgOverride,
    this.textOverride,
    this.borderOverride,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final (double h, double px, double fs, double r) = switch (size) {
      ChipSize.sm => (28, 10, 12, 8),
      ChipSize.md => (34, 14, 13, 10),
      ChipSize.lg => (40, 16, 14, 12),
    };
    final bg = bgOverride ?? (active ? (color ?? t.accent) : t.chip);
    final fg = textOverride ?? (active ? Colors.white : t.chipText);
    final br = borderOverride ?? (active ? Colors.transparent : t.line);
    return Container(
      height: h,
      padding: EdgeInsets.symmetric(horizontal: px),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: br),
        borderRadius: BorderRadius.circular(r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 6),
          ],
          DefaultTextStyle.merge(
            style: GoogleFonts.inter(
              fontSize: fs,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Avatar ───────────────────────────────────────────────────────────────────
class Avatar extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const Avatar({super.key, this.name = 'A', this.size = 36, this.color});

  static const _colors = [
    Color(0xFFFF8A5C),
    Color(0xFF9B7DFF),
    Color(0xFF5BA8FF),
    Color(0xFF34D399),
    Color(0xFFF5C26B),
    Color(0xFFF87171),
    Color(0xFF7DD3A0),
  ];

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final c = color ??
        _colors[(name.codeUnitAt(0)) % _colors.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.45,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

// ── BrandMark ────────────────────────────────────────────────────────────────
class BrandMark extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const BrandMark({super.key, this.name = 'B', this.size = 44, this.color});

  static const _brandColors = <String, Color>{
    'Aura': Color(0xFFD9A877),
    'Sonder': Color(0xFFFF6B9D),
    'Onda': Color(0xFF5BA8FF),
    'Bali Bites': Color(0xFFFF8A5C),
    'Hush': Color(0xFF7DD3A0),
    'Lumo': Color(0xFF9B7DFF),
  };

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'B';
    final c = color ?? _brandColors[name] ?? const Color(0xFFFF8A5C);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: GoogleFonts.instrumentSerif(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ── Status bar (theme-aware mini bar) ────────────────────────────────────────
class StatusBar extends StatelessWidget {
  final bool? dark;
  const StatusBar({super.key, this.dark});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final isDark = dark ?? t.statusDark;
    final c = isDark ? Colors.white : Colors.black;
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 14, 26, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: c,
              ),
            ),
            Row(
              children: [
                _signal(c),
                const SizedBox(width: 6),
                _wifi(c),
                const SizedBox(width: 6),
                _battery(c),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _signal(Color c) => SizedBox(
        width: 17,
        height: 11,
        child: CustomPaint(painter: _SignalPainter(c)),
      );
  Widget _wifi(Color c) => Icon(Icons.wifi, size: 14, color: c);
  Widget _battery(Color c) => Container(
        width: 25,
        height: 12,
        decoration: BoxDecoration(
          border: Border.all(color: c.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(3.5),
        ),
        padding: const EdgeInsets.all(1.5),
        child: Container(
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _SignalPainter extends CustomPainter {
  final Color color;
  _SignalPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final heights = [4.0, 6.0, 8.5, 11.0];
    for (var i = 0; i < 4; i++) {
      final r = Rect.fromLTWH(
        i * 4.5,
        size.height - heights[i],
        3,
        heights[i],
      );
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(0.5)), p);
    }
  }

  @override
  bool shouldRepaint(_SignalPainter old) => old.color != color;
}

// ── Shimmer overlay (1.6s linear loop) ───────────────────────────────────────
class ShimmerOverlay extends StatefulWidget {
  final double radius;
  final double opacity;
  const ShimmerOverlay({super.key, this.radius = 0, this.opacity = 1});
  @override
  State<ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: IgnorePointer(
        child: Opacity(
          opacity: widget.opacity,
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              return CustomPaint(
                painter: _ShimmerPainter(
                  _c.value,
                  t.ai.withValues(alpha: 0.19),
                  t.accent.withValues(alpha: 0.25),
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double phase;
  final Color ai;
  final Color accent;
  _ShimmerPainter(this.phase, this.ai, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final shift = (phase * 3 - 1) * size.width;
    final r = Rect.fromLTWH(shift, 0, size.width * 0.5, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, ai, accent, ai, Colors.transparent],
        stops: const [0, 0.3, 0.5, 0.7, 1],
      ).createShader(r);
    canvas.drawRect(r, paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.phase != phase;
}

// ── ToneSlider (Lightroom-style, read-only display) ──────────────────────────
class ToneSlider extends StatelessWidget {
  final String label;
  final int value;
  final int minVal;
  final int maxVal;
  final Color? color;
  final String suffix;

  const ToneSlider({
    super.key,
    required this.label,
    this.value = 0,
    this.minVal = -100,
    this.maxVal = 100,
    this.color,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final pct = (value - minVal) / (maxVal - minVal);
    final centerPct = -minVal / (maxVal - minVal);
    final trackC = color ?? t.accent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: t.text2,
                letterSpacing: -0.1,
              ),
            ),
            Text(
              '${value > 0 ? '+' : ''}$value$suffix',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: value == 0 ? t.muted : t.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 18,
          child: LayoutBuilder(
            builder: (_, c) {
              final w = c.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: t.line2,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: (centerPct < pct ? centerPct : pct) * w,
                    child: Container(
                      width: (pct - centerPct).abs() * w,
                      height: 2,
                      decoration: BoxDecoration(
                        color: trackC,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Positioned(
                    left: centerPct * w,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: t.muted.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    left: pct * w - 7,
                    top: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── TabBar (bottom) ──────────────────────────────────────────────────────────
class GlowTabBar extends StatelessWidget {
  final String active;
  final ValueChanged<String>? onTap;
  const GlowTabBar({super.key, this.active = 'studio', this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final lang = GlowTheme.of(context).config.lang;
    final tabs = [
      ('home', 'image', L.t('tab_home', lang), false, null),
      ('studio', 'sparkle', L.t('tab_studio', lang), true, null),
      ('briefs', 'inbox', L.t('tab_briefs', lang), false, 3),
      ('library', 'folder', L.t('tab_library', lang), false, null),
      ('profile', 'user', L.t('tab_profile', lang), false, null),
    ];
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      decoration: BoxDecoration(
        color: t.bg.withValues(alpha: 0.94),
        border: Border(top: BorderSide(color: t.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tabs.map((tab) {
          final id = tab.$1 as String;
          final icon = tab.$2 as String;
          final label = tab.$3 as String;
          final highlight = tab.$4 as bool;
          final badge = tab.$5 as int?;
          final isActive = id == active;
          final c = isActive ? t.accent : t.muted;
          return GestureDetector(
            onTap: onTap == null ? null : () => onTap!(id),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (highlight)
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [t.accent, t.ai],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: GlowIcon(icon,
                              size: 20,
                              color: isActive ? Colors.white : c),
                        )
                      else
                        GlowIcon(icon, size: 22, color: c),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: c,
                        ),
                      ),
                    ],
                  ),
                  if (badge != null)
                    Positioned(
                      top: 0,
                      right: 6,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 16),
                        height: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: t.danger,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$badge',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
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
    );
  }
}

// ── Screen wrapper (phone frame look) ─────────────────────────────────────────
class GlowScreen extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const GlowScreen({
    super.key,
    required this.child,
    this.width = 402,
    this.height = 874,
  });

  @override
  Widget build(BuildContext context) {
    final theme = GlowTheme.of(context);
    final t = theme.palette;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: t.bg,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: t.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: t.name == 'dark' ? 0.5 : 0.15),
            blurRadius: 80,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (theme.config.showFrame) const _PhoneFrame(),
          Positioned.fill(child: child),
          if (!theme.config.showFrame)
            const Positioned(top: 0, left: 0, right: 0, child: StatusBar()),
        ],
      ),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame();
  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: StatusBar(),
    );
  }
}
