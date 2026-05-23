import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Ports `Btn` from primitives.jsx — same variants and sizes, with hover-lift
/// on web/desktop and press-squish on all platforms.
enum BtnVariant { primary, secondary, ghost, glow, danger, outline }

enum BtnSize { sm, md, lg }

class GlowBtn extends StatefulWidget {
  final Widget child;
  final BtnVariant variant;
  final BtnSize size;
  final bool block;
  final Widget? icon;
  final VoidCallback? onTap;

  const GlowBtn({
    super.key,
    required this.child,
    this.variant = BtnVariant.primary,
    this.size = BtnSize.md,
    this.block = false,
    this.icon,
    this.onTap,
  });

  @override
  State<GlowBtn> createState() => _GlowBtnState();
}

class _GlowBtnState extends State<GlowBtn> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final dpx = GlowTheme.of(context).d;

    final (double h, double px, double fs, double gap, double r) =
        switch (widget.size) {
      BtnSize.sm => (32, 12, 13, 6, 10),
      BtnSize.md => (dpx(44), 16, 15, 8, 12),
      BtnSize.lg => (dpx(56), 20, 17, 10, 14),
    };

    // Variant -> background, foreground, border
    Color bg;
    Color fg;
    Color border = Colors.transparent;
    Gradient? gradient;
    switch (widget.variant) {
      case BtnVariant.primary:
        bg = t.accent;
        fg = Colors.white;
        break;
      case BtnVariant.secondary:
        bg = t.chip;
        fg = t.text;
        border = t.line;
        break;
      case BtnVariant.ghost:
        bg = Colors.transparent;
        fg = t.text;
        break;
      case BtnVariant.glow:
        bg = Colors.transparent;
        fg = Colors.white;
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [t.accent, t.ai],
        );
        break;
      case BtnVariant.danger:
        bg = t.danger;
        fg = Colors.white;
        break;
      case BtnVariant.outline:
        bg = Colors.transparent;
        fg = t.text;
        border = t.line2;
        break;
    }

    final baseShadow = switch (widget.variant) {
      BtnVariant.glow => [
          BoxShadow(
            color: t.accent.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      BtnVariant.primary => [
          BoxShadow(
            color: t.accent.withValues(alpha: 0.19),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      _ => <BoxShadow>[],
    };
    final hoverShadow = switch (widget.variant) {
      BtnVariant.glow => [
          BoxShadow(
            color: t.accent.withValues(alpha: 0.38),
            blurRadius: 36,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: t.accent.withValues(alpha: 0.19),
            blurRadius: 24,
          ),
        ],
      BtnVariant.primary => [
          BoxShadow(
            color: t.accent.withValues(alpha: 0.31),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      _ => <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
    };

    final scale = _pressed ? 0.96 : 1.0;
    final dy = _pressed ? 0.0 : (_hover ? -1.0 : 0.0);

    final btn = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      height: h,
      width: widget.block ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: px),
      decoration: BoxDecoration(
        color: gradient == null ? bg : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(r),
        border: border == Colors.transparent
            ? null
            : Border.all(color: border, width: 1),
        boxShadow: _hover && !_pressed ? hoverShadow : baseShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            SizedBox(width: gap),
          ],
          DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: fs,
              fontWeight: FontWeight.w600,
              color: fg,
              letterSpacing: -0.15,
            ),
            child: widget.child,
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 140),
          offset: Offset(0, dy / 40),
          curve: Curves.easeOut,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 140),
            scale: scale,
            curve: Curves.easeOut,
            child: widget.block
                ? SizedBox(width: double.infinity, child: btn)
                : btn,
          ),
        ),
      ),
    );
  }
}
