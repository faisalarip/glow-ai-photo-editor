import 'package:flutter/material.dart';

/// PhotoPlaceholder — ports the `Photo` component from primitives.jsx. Draws a
/// stylized creator + product silhouette over a mood-driven gradient. Scales
/// uniformly from a native 800×1100 canvas, just like the JSX version.
enum PhotoVariant { raw, enhanced, nobg, moody, studio, pastel, night }

enum ProductKind { skincare, fashion, food, gadget, none }

class PhotoPlaceholder extends StatelessWidget {
  static const double nativeW = 800;
  static const double nativeH = 1100;

  final PhotoVariant variant;
  final ProductKind product;
  final double width;
  final double height;
  final double radius;
  final bool showCheckerBg;

  const PhotoPlaceholder({
    super.key,
    this.variant = PhotoVariant.enhanced,
    this.product = ProductKind.skincare,
    this.width = 400,
    this.height = 550,
    this.radius = 16,
    this.showCheckerBg = false,
  });

  Gradient _bg() {
    switch (variant) {
      case PhotoVariant.raw:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB5AC9C), Color(0xFF968C7C)],
        );
      case PhotoVariant.enhanced:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF9E9D6), Color(0xFFF0C9A8), Color(0xFFD5926A)],
          stops: [0, 0.5, 1],
        );
      case PhotoVariant.nobg:
        return const LinearGradient(colors: [Colors.transparent, Colors.transparent]);
      case PhotoVariant.moody:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A1F3D), Color(0xFF5B3D7A)],
        );
      case PhotoVariant.studio:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2F3540), Color(0xFF4A5060)],
        );
      case PhotoVariant.pastel:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE4E1), Color(0xFFFFC0CB)],
        );
      case PhotoVariant.night:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        );
    }
  }

  Color _skin() => switch (variant) {
        PhotoVariant.raw => const Color(0xFFC8A98C),
        PhotoVariant.enhanced => const Color(0xFFE8C29D),
        PhotoVariant.moody => const Color(0xFFE8B8C0),
        PhotoVariant.nobg => const Color(0xFFE8C29D),
        PhotoVariant.studio => const Color(0xFFD4A57F),
        PhotoVariant.pastel => const Color(0xFFF5D5C5),
        PhotoVariant.night => const Color(0xFFC29D7F),
      };

  Color _hair() => switch (variant) {
        PhotoVariant.moody => const Color(0xFF2A1230),
        PhotoVariant.night => const Color(0xFF1A0F25),
        _ => const Color(0xFF2A1F18),
      };

  Color _shirt() => switch (variant) {
        PhotoVariant.raw => const Color(0xFF6E7A5E),
        PhotoVariant.enhanced => const Color(0xFFF5F1EB),
        PhotoVariant.nobg => const Color(0xFFF5F1EB),
        PhotoVariant.moody => const Color(0xFFE2B85A),
        PhotoVariant.studio => const Color(0xFF1F1E1B),
        PhotoVariant.pastel => Colors.white,
        PhotoVariant.night => const Color(0xFF7C5CFF),
      };

  @override
  Widget build(BuildContext context) {
    final scale = (width / nativeW > height / nativeH)
        ? width / nativeW
        : height / nativeH;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: showCheckerBg ? null : _bg(),
          color: showCheckerBg ? const Color(0xFFE9E4D4) : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (variant == PhotoVariant.raw)
              Positioned.fill(
                child: CustomPaint(painter: _RawClutterPainter()),
              ),
            if (variant == PhotoVariant.enhanced)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.4),
                      radius: 0.7,
                      colors: [
                        Color(0x99FFF0D2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              left: width / 2 - (nativeW * scale) / 2,
              top: height / 2 - (nativeH * scale) / 2,
              child: SizedBox(
                width: nativeW,
                height: nativeH,
                child: Transform.scale(
                  alignment: Alignment.center,
                  scale: scale,
                  child: _CreatorFigure(
                    skin: _skin(),
                    hair: _hair(),
                    shirt: _shirt(),
                    product: product,
                    variant: variant,
                  ),
                ),
              ),
            ),
            if (variant == PhotoVariant.moody)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.4, -0.6),
                        radius: 0.8,
                        colors: [Color(0x2EE65AB4), Colors.transparent],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RawClutterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()..color = const Color(0x805C4A38);
    canvas.save();
    canvas.translate(size.width * 0.1, size.height * 0.08);
    canvas.rotate(-0.14);
    canvas.drawRRect(
      RRect.fromLTRBR(
        0,
        0,
        size.width * 0.3,
        size.height * 0.25,
        const Radius.circular(8),
      ),
      paint1,
    );
    canvas.restore();
    final paint2 = Paint()..color = const Color(0x993E342A);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.7, size.height * 0.05,
          size.width * 0.18, size.height * 0.28),
      paint2,
    );
    // dark vignette bottom
    final paint3 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.4)],
      ).createShader(Rect.fromLTWH(
          0, size.height * 0.6, size.width, size.height * 0.4));
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      paint3,
    );
  }

  @override
  bool shouldRepaint(_RawClutterPainter old) => false;
}

class _CreatorFigure extends StatelessWidget {
  final Color skin;
  final Color hair;
  final Color shirt;
  final ProductKind product;
  final PhotoVariant variant;
  const _CreatorFigure({
    required this.skin,
    required this.hair,
    required this.shirt,
    required this.product,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {
    const cx = PhotoPlaceholder.nativeW / 2;
    const cy = PhotoPlaceholder.nativeH * 0.55;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Head backplate (hair-dark halo)
        Positioned(
          left: cx - 180,
          top: cy - 380,
          child: Container(
            width: 360,
            height: 280,
            decoration: BoxDecoration(
              color: hair,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(180, 168),
                topRight: Radius.elliptical(180, 168),
                bottomLeft: Radius.elliptical(180, 112),
                bottomRight: Radius.elliptical(180, 112),
              ),
            ),
          ),
        ),
        // Face
        Positioned(
          left: cx - 140,
          top: cy - 320,
          child: Container(
            width: 280,
            height: 340,
            decoration: BoxDecoration(
              color: skin,
              borderRadius: const BorderRadius.all(
                Radius.elliptical(130, 170),
              ),
            ),
            child: Stack(
              children: [
                // Eyes
                Positioned(
                  left: 56,
                  top: 140,
                  child: Container(
                    width: 36,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1F18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Positioned(
                  right: 56,
                  top: 140,
                  child: Container(
                    width: 36,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1F18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Mouth
                Positioned(
                  left: 100,
                  top: 240,
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(color: Color(0xFF2A1F18), width: 6),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(40, 30),
                        bottomRight: Radius.elliptical(40, 30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Hair top cap
        Positioned(
          left: cx - 140,
          top: cy - 320,
          child: Container(
            width: 280,
            height: 100,
            decoration: BoxDecoration(
              color: hair,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(130, 80),
                topRight: Radius.elliptical(130, 80),
              ),
            ),
          ),
        ),
        // Neck
        Positioned(
          left: cx - 35,
          top: cy + 0,
          child: Container(width: 70, height: 60, color: skin),
        ),
        // Shoulders / shirt
        Positioned(
          left: cx - 280,
          top: cy + 50,
          child: Container(
            width: 560,
            height: 480,
            decoration: BoxDecoration(
              color: shirt,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(120),
                topRight: Radius.circular(120),
              ),
            ),
          ),
        ),
        // Arm
        Positioned(
          left: cx - 60,
          top: cy + 80,
          child: Transform.rotate(
            angle: -0.14,
            child: Container(
              width: 120,
              height: 220,
              decoration: BoxDecoration(
                color: skin,
                borderRadius: BorderRadius.circular(60),
              ),
            ),
          ),
        ),
        // Product
        Positioned(
          left: cx - 100,
          top: cy + 200,
          child: _Product(kind: product, variant: variant),
        ),
      ],
    );
  }
}

class _Product extends StatelessWidget {
  final ProductKind kind;
  final PhotoVariant variant;
  const _Product({required this.kind, required this.variant});

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case ProductKind.skincare:
        return SizedBox(
          width: 140,
          height: 200,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFEFCF8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 50, 12, 30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF5E5D5), Color(0xFFD9A877)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'aura',
                        style: TextStyle(
                          fontFamily: 'Instrument Serif',
                          fontStyle: FontStyle.italic,
                          fontSize: 22,
                          color: Color(0xFF1F1E1B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'SERUM',
                        style: TextStyle(
                          fontSize: 8,
                          letterSpacing: 1.4,
                          color: Color(0xFF1F1E1B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 50,
                top: -20,
                child: Container(
                  width: 40,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4B896),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      case ProductKind.fashion:
        return Container(
          width: 200,
          height: 180,
          decoration: BoxDecoration(
            color: variant == PhotoVariant.moody
                ? const Color(0xFFE2B85A)
                : const Color(0xFFD97757),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 30,
                offset: Offset(0, 14),
              ),
            ],
          ),
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              color: variant == PhotoVariant.moody
                  ? const Color(0xFFC99B3D)
                  : const Color(0xFFB85C3F),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(30, 32),
                topRight: Radius.elliptical(30, 32),
              ),
            ),
          ),
        );
      case ProductKind.food:
        return Container(
          width: 180,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 30,
                offset: Offset(0, 14),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment(-0.2, -0.4),
                colors: [Color(0xFFF5D082), Color(0xFFB87333)],
              ),
            ),
          ),
        );
      case ProductKind.gadget:
        return SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            children: [
              Positioned(
                left: 30,
                top: 30,
                right: 30,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Color(0xFF1F1E1B), width: 14),
                      top: BorderSide(color: Color(0xFF1F1E1B), width: 14),
                      right: BorderSide(color: Color(0xFF1F1E1B), width: 14),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(120),
                      topRight: Radius.circular(120),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 80,
                child: Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1E1B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 80,
                child: Container(
                  width: 50,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1E1B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        );
      case ProductKind.none:
        return const SizedBox.shrink();
    }
  }
}
