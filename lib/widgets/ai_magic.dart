import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme.dart';

/// Ports the AI processing visual kit from ai-magic.jsx.

// ── AIOrb ────────────────────────────────────────────────────────────────────
class AIOrb extends StatefulWidget {
  final double size;
  final double intensity;
  final bool paused;
  final bool glow;
  const AIOrb({
    super.key,
    this.size = 120,
    this.intensity = 1,
    this.paused = false,
    this.glow = true,
  });

  @override
  State<AIOrb> createState() => _AIOrbState();
}

class _AIOrbState extends State<AIOrb> with TickerProviderStateMixin {
  late final AnimationController _ring;
  late final AnimationController _sweep;
  late final AnimationController _breath;
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _ring = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();
    _sweep = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();
    _breath = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);
    _orbit = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 4000))
      ..repeat();
  }

  @override
  void dispose() {
    _ring.dispose();
    _sweep.dispose();
    _breath.dispose();
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final size = widget.size;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (widget.glow)
            Positioned(
              left: -size * 0.4,
              top: -size * 0.4,
              right: -size * 0.4,
              bottom: -size * 0.4,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        t.ai.withValues(alpha: 0.37 * widget.intensity),
                        t.accent.withValues(alpha: 0.19),
                        Colors.transparent,
                      ],
                      stops: const [0, 0.35, 0.65],
                    ),
                  ),
                ),
              ),
            ),
          // Concentric rings
          for (int i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: _ring,
              builder: (_, __) {
                final phase = (_ring.value + i / 3) % 1;
                final s = 0.6 + phase * 1.8;
                final opacity = phase < 0.8
                    ? (1 - phase) * 0.8
                    : 0.0;
                return Opacity(
                  opacity: widget.paused ? 0 : opacity.clamp(0, 1),
                  child: Transform.scale(
                    scale: s,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: t.accent, width: 1.5),
                      ),
                    ),
                  ),
                );
              },
            ),
          // Conic sweep
          AnimatedBuilder(
            animation: _sweep,
            builder: (_, __) {
              return Transform.rotate(
                angle: _sweep.value * 2 * math.pi,
                child: Container(
                  width: size * 0.88,
                  height: size * 0.88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        Colors.transparent,
                        t.ai.withValues(alpha: 0.25),
                        t.accent.withValues(alpha: 0.5),
                        t.ai.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Core orb
          ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.08).animate(
              CurvedAnimation(parent: _breath, curve: Curves.easeInOut),
            ),
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.4),
                  colors: [
                    Colors.white,
                    t.accent,
                    t.ai,
                  ],
                  stops: const [0, 0.3, 0.8],
                ),
                boxShadow: [
                  BoxShadow(
                    color: t.accent.withValues(alpha: 0.5),
                    blurRadius: size * 0.2,
                  ),
                ],
              ),
              child: Align(
                alignment: const Alignment(-0.5, -0.5),
                child: Container(
                  width: size * 0.18,
                  height: size * 0.14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xE6FFFFFF), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Orbit dots
          if (!widget.paused)
            for (int i = 0; i < 4; i++)
              AnimatedBuilder(
                animation: _orbit,
                builder: (_, __) {
                  final angle = (_orbit.value + i / 4) * 2 * math.pi;
                  final r = size * 0.46;
                  final dx = r * math.cos(angle);
                  final dy = r * math.sin(angle);
                  return Transform.translate(
                    offset: Offset(dx, dy),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i % 2 == 0 ? t.accent : t.ai,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (i % 2 == 0 ? t.accent : t.ai),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}

// ── ParticleField ────────────────────────────────────────────────────────────
class ParticleField extends StatefulWidget {
  final int count;
  final Color? color;
  final int seed;
  const ParticleField({super.key, this.count = 12, this.color, this.seed = 1});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_Dot> _dots;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
    final rng = math.Random(widget.seed);
    _dots = List.generate(widget.count, (_) {
      return _Dot(
        left: rng.nextDouble(),
        bottom: rng.nextDouble(),
        size: 2 + rng.nextDouble() * 4,
        dx: (rng.nextDouble() - 0.5) * 40,
        dy: -20 - rng.nextDouble() * 60,
        delay: rng.nextDouble() * 3,
        duration: 2 + rng.nextDouble() * 2,
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? GlowTheme.of(context).palette.accent;
    return IgnorePointer(
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final tNow = _c.lastElapsedDuration?.inMilliseconds ?? 0;
            return Stack(
              children: _dots.map((d) {
                final localT = ((tNow / 1000) - d.delay) % d.duration;
                if (localT < 0) return const SizedBox.shrink();
                final phase = localT / d.duration;
                final opacity = phase < 0.2
                    ? phase / 0.2
                    : 1 - (phase - 0.2) / 0.8;
                return Positioned(
                  left: d.left * (MediaQuery.maybeOf(context)?.size.width ?? 320) * 0.0 + d.left * 320,
                  bottom: d.bottom * 420 + (-d.dy * phase),
                  child: Transform.translate(
                    offset: Offset(d.dx * phase, 0),
                    child: Opacity(
                      opacity: opacity.clamp(0, 1),
                      child: Container(
                        width: d.size,
                        height: d.size,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: color, blurRadius: d.size * 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _Dot {
  final double left, bottom, size, dx, dy, delay, duration;
  _Dot({
    required this.left,
    required this.bottom,
    required this.size,
    required this.dx,
    required this.dy,
    required this.delay,
    required this.duration,
  });
}

// ── Scan line ────────────────────────────────────────────────────────────────
class ScanLineFx extends StatefulWidget {
  final Color? color;
  final double speed;
  final bool glow;
  const ScanLineFx(
      {super.key, this.color, this.speed = 2.2, this.glow = true});
  @override
  State<ScanLineFx> createState() => _ScanLineFxState();
}

class _ScanLineFxState extends State<ScanLineFx>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? GlowTheme.of(context).palette.ai;
    return ClipRect(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (_, c) {
            return AnimatedBuilder(
              animation: _c,
              builder: (_, __) {
                final eased = Curves.easeInOut.transform(_c.value);
                final top = -0.1 + eased * 1.1;
                final pixelTop = top * c.maxHeight;
                return Stack(
                  children: [
                    Positioned(
                      top: pixelTop,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              color.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: pixelTop + 39,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: color,
                          boxShadow: [
                            BoxShadow(color: color, blurRadius: 16),
                            BoxShadow(color: color, blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ── Waveform (audio-style bars) ──────────────────────────────────────────────
class Waveform extends StatefulWidget {
  final int bars;
  final double height;
  final Color? color;
  const Waveform({super.key, this.bars = 16, this.height = 24, this.color});
  @override
  State<Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? GlowTheme.of(context).palette.accent;
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.bars, (i) {
          final baseH = 0.3 + (math.sin(i * 0.9) * 0.5 + 0.5) * 0.7;
          return AnimatedBuilder(
            animation: _c,
            builder: (_, __) {
              final localPhase = (_c.value + i * 0.04) % 1;
              final scale = 0.4 + math.sin(localPhase * math.pi) * 0.6;
              return Container(
                width: 2,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                height: widget.height * baseH * scale,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.4 + baseH * 0.6),
                  borderRadius: BorderRadius.circular(1),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ── AIProgressBar ────────────────────────────────────────────────────────────
class AIProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  const AIProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        color: t.line,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [t.accent, t.ai],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: const _ShimmerFill(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerFill extends StatefulWidget {
  const _ShimmerFill();
  @override
  State<_ShimmerFill> createState() => _ShimmerFillState();
}

class _ShimmerFillState extends State<_ShimmerFill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return ClipRect(
          child: FractionalTranslation(
            translation: Offset(_c.value * 3 - 1, 0),
            child: const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0x80FFFFFF),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── AI Status Cycler ─────────────────────────────────────────────────────────
class AIStatusCycler extends StatefulWidget {
  final List<String>? messages;
  final Duration interval;
  final TextStyle? style;
  const AIStatusCycler({
    super.key,
    this.messages,
    this.interval = const Duration(milliseconds: 1400),
    this.style,
  });

  @override
  State<AIStatusCycler> createState() => _AIStatusCyclerState();
}

class _AIStatusCyclerState extends State<AIStatusCycler> {
  late final List<String> _list;
  int _idx = 0;

  static const _defaults = [
    'Analyzing photo…',
    'Removing background…',
    'Generating scene…',
    'Matching brand mood…',
    'Color grading…',
    'Polishing skin retouch…',
    'Finalizing details…',
  ];

  @override
  void initState() {
    super.initState();
    _list = widget.messages ?? _defaults;
    _tick();
  }

  void _tick() async {
    while (mounted) {
      await Future<void>.delayed(widget.interval);
      if (!mounted) return;
      setState(() => _idx = (_idx + 1) % _list.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        );
    return SizedBox(
      height: 22,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.4),
              end: Offset.zero,
            ).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
        },
        child: Text(
          _list[_idx],
          key: ValueKey(_idx),
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ── AICanvasOverlay ──────────────────────────────────────────────────────────
class AICanvasOverlay extends StatelessWidget {
  final double progress;
  final double radius;
  const AICanvasOverlay({super.key, this.progress = 0.6, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return IgnorePointer(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      t.ai.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.7],
                  ),
                ),
              ),
            ),
            const Positioned.fill(child: ScanLineFx()),
            const Positioned.fill(child: ParticleField(count: 18)),
            Align(
              alignment: const Alignment(0, -0.2),
              child: const AIOrb(size: 88),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 50,
              child: const AIStatusCycler(),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                children: [
                  AIProgressBar(progress: progress, height: 4),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GENERATING',
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── BrandMatchMeter ──────────────────────────────────────────────────────────
class BrandMatchMeter extends StatefulWidget {
  final int value;
  final double size;
  final String? label;
  const BrandMatchMeter({
    super.key,
    this.value = 96,
    this.size = 80,
    this.label,
  });

  @override
  State<BrandMatchMeter> createState() => _BrandMatchMeterState();
}

class _BrandMatchMeterState extends State<BrandMatchMeter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _anim = Tween(begin: 0.0, end: widget.value.toDouble())
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final displayed = _anim.value.round();
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _MeterPainter(
                  value: _anim.value / 100,
                  bg: t.line,
                  fg: t.accent,
                  strokeWidth: 5,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$displayed',
                        style: GoogleFonts.inter(
                          fontSize: widget.size * 0.28,
                          fontWeight: FontWeight.w800,
                          color: t.text,
                          letterSpacing: -1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: widget.size * 0.06),
                        child: Text(
                          '%',
                          style: GoogleFonts.inter(
                            fontSize: widget.size * 0.14,
                            color: t.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.label != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.label!.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: widget.size * 0.11,
                          fontWeight: FontWeight.w600,
                          color: t.muted,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MeterPainter extends CustomPainter {
  final double value;
  final Color bg;
  final Color fg;
  final double strokeWidth;
  _MeterPainter({
    required this.value,
    required this.bg,
    required this.fg,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = (size.width - strokeWidth) / 2;
    final bgP = Paint()
      ..color = bg
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, r, bgP);
    final fgP = Paint()
      ..color = fg
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
    final rect = Rect.fromCircle(center: center, radius: r);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * value,
      false,
      fgP,
    );
  }

  @override
  bool shouldRepaint(_MeterPainter old) => old.value != value;
}
