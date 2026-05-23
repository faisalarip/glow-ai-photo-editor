import 'package:flutter/material.dart';

/// Inline-SVG-path icon set ported from primitives.jsx `Icon`. Each entry is the
/// raw `d=` path string, rendered with the same 24×24 viewBox.
class GlowIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final double strokeWidth;

  const GlowIcon(this.name,
      {super.key, this.size = 20, this.color, this.strokeWidth = 1.8});

  static const _paths = <String, String>{
    'light':
        'M12 2v3M12 19v3M4.2 4.2l2.1 2.1M17.7 17.7l2.1 2.1M2 12h3M19 12h3M4.2 19.8l2.1-2.1M17.7 6.3l2.1-2.1M12 17a5 5 0 100-10 5 5 0 000 10z',
    'contrast': 'M12 2v20M12 2a10 10 0 010 20',
    'crop': 'M6 2v16h16M2 6h16v16',
    'sparkle':
        'M12 3l1.5 5.5L19 10l-5.5 1.5L12 17l-1.5-5.5L5 10l5.5-1.5L12 3zM19 16l.6 2.4L22 19l-2.4.6L19 22l-.6-2.4L16 19l2.4-.6L19 16z',
    'bg': 'M3 7l9-4 9 4M3 7v10l9 4M3 7l9 4M21 7l-9 4M12 11v10',
    'palette':
        'M12 22c5.5 0 10-4.5 10-10S17.5 2 12 2 2 6.5 2 12c0 3 1.5 4 4 4h2a2 2 0 012 2v2c0 1.1.9 2 2 2zM7.5 10.5h.01M16.5 10.5h.01M16.5 14.5h.01',
    'text': 'M4 6V4h16v2M9 20h6M12 4v16',
    'layer':
        'M12 2L2 9l10 7 10-7-10-7zM2 17l10 7 10-7M2 13l10 7 10-7',
    'wand': 'M15 4l1 2 2 1-2 1-1 2-1-2-2-1 2-1 1-2zM5 19l9-9M19 5l-2 2',
    'image': 'M3 5h18v14H3zM3 16l5-5 4 4 3-3 6 6',
    'plus': 'M12 5v14M5 12h14',
    'chevron_r': 'M9 6l6 6-6 6',
    'chevron_l': 'M15 6l-6 6 6 6',
    'chevron_d': 'M6 9l6 6 6-6',
    'chevron_u': 'M6 15l6-6 6 6',
    'close': 'M6 6l12 12M18 6L6 18',
    'check': 'M5 13l5 5L20 7',
    'star': 'M12 3l2.8 6.5L22 11l-5 4.6L18.2 22 12 18.5 5.8 22 7 15.6 2 11l7.2-1.5L12 3z',
    'heart':
        'M12 21s-9-6.5-9-12.5A5.5 5.5 0 0112 5a5.5 5.5 0 019 3.5C21 14.5 12 21 12 21z',
    'share': 'M4 12v8h16v-8M16 6l-4-4-4 4M12 2v14',
    'download': 'M12 4v12M5 11l7 7 7-7M4 20h16',
    'play': 'M5 4l14 8-14 8z',
    'pause': 'M6 4v16M14 4v16',
    'settings':
        'M12 8a4 4 0 100 8 4 4 0 000-8zM19.4 15a1 1 0 00.2 1.1l.1.1a2 2 0 11-2.8 2.8l-.1-.1a1 1 0 00-1.1-.2 1 1 0 00-.6.9V20a2 2 0 11-4 0v-.1a1 1 0 00-.6-.9 1 1 0 00-1.1.2l-.1.1a2 2 0 11-2.8-2.8l.1-.1a1 1 0 00.2-1.1 1 1 0 00-.9-.6H4a2 2 0 110-4h.1a1 1 0 00.9-.6 1 1 0 00-.2-1.1l-.1-.1A2 2 0 117.5 4.6l.1.1a1 1 0 001.1.2H9a1 1 0 00.6-.9V4a2 2 0 014 0v.1a1 1 0 00.6.9 1 1 0 001.1-.2l.1-.1a2 2 0 112.8 2.8l-.1.1a1 1 0 00-.2 1.1V9a1 1 0 00.9.6H20a2 2 0 110 4h-.1a1 1 0 00-.9.6z',
    'user': 'M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2M12 11a4 4 0 100-8 4 4 0 000 8z',
    'inbox':
        'M22 12h-6l-2 3h-4l-2-3H2M5.45 5.11L2 12v6a2 2 0 002 2h16a2 2 0 002-2v-6l-3.45-6.89A2 2 0 0016.76 4H7.24a2 2 0 00-1.79 1.11z',
    'folder':
        'M22 19a2 2 0 01-2 2H4a2 2 0 01-2-2V5a2 2 0 012-2h5l2 3h9a2 2 0 012 2z',
    'lock': 'M5 11h14v10H5zM8 11V7a4 4 0 018 0v4',
    'bolt': 'M13 2L3 14h7l-1 8 10-12h-7l1-8z',
    'grid': 'M3 3h7v7H3zM14 3h7v7h-7zM14 14h7v7h-7zM3 14h7v7H3z',
    'chat': 'M21 11.5a8.4 8.4 0 01-9 8.4l-5 3v-5A8 8 0 1121 11.5z',
    'eye': 'M1 12s4-8 11-8 11 8 11 8-4 8-11 8S1 12 1 12zM12 15a3 3 0 100-6 3 3 0 000 6z',
    'flag': 'M4 22V4l8 4 8-4v14l-8 4-8-4z',
    'arrow_r': 'M5 12h14M13 5l7 7-7 7',
    'arrow_l': 'M19 12H5M11 5l-7 7 7 7',
    'swap': 'M16 3l4 4-4 4M4 7h16M8 21l-4-4 4-4M4 17h16',
    'filter': 'M3 4h18l-7 9v6l-4 2v-8L3 4z',
    'list': 'M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01',
    'camera':
        'M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2zM12 17a4 4 0 100-8 4 4 0 000 8z',
    'bookmark': 'M19 21l-7-5-7 5V5a2 2 0 012-2h10a2 2 0 012 2z',
    'search': 'M11 19a8 8 0 100-16 8 8 0 000 16zM21 21l-4.35-4.35',
    'bell': 'M18 8a6 6 0 10-12 0c0 7-3 9-3 9h18s-3-2-3-9zM13.7 21a2 2 0 01-3.4 0',
    'money': 'M12 1v22M17 5H9.5a3.5 3.5 0 100 7h5a3.5 3.5 0 110 7H6',
  };

  @override
  Widget build(BuildContext context) {
    final path = _paths[name];
    if (path == null) return SizedBox(width: size, height: size);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IconPainter(
          path: path,
          color: color ?? Colors.white,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

/// Parses a minimal SVG path subset (M, L, H, V, A as curve approximation,
/// Z, plus relative variants) — enough for the ~40 icons in the design.
class _IconPainter extends CustomPainter {
  final String path;
  final Color color;
  final double strokeWidth;

  _IconPainter({
    required this.path,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale, scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tokens = _tokenize(path);
    final p = Path();
    double x = 0, y = 0, sx = 0, sy = 0;
    String cmd = 'M';
    int i = 0;
    double take() => tokens[i++].toDouble();

    while (i < tokens.length) {
      final t = tokens[i];
      if (t is String) {
        cmd = t;
        i++;
        if (cmd == 'Z' || cmd == 'z') {
          p.close();
          x = sx;
          y = sy;
        }
        continue;
      }
      switch (cmd) {
        case 'M':
          x = take();
          y = take();
          p.moveTo(x, y);
          sx = x;
          sy = y;
          cmd = 'L';
          break;
        case 'm':
          x += take();
          y += take();
          p.moveTo(x, y);
          sx = x;
          sy = y;
          cmd = 'l';
          break;
        case 'L':
          x = take();
          y = take();
          p.lineTo(x, y);
          break;
        case 'l':
          x += take();
          y += take();
          p.lineTo(x, y);
          break;
        case 'H':
          x = take();
          p.lineTo(x, y);
          break;
        case 'h':
          x += take();
          p.lineTo(x, y);
          break;
        case 'V':
          y = take();
          p.lineTo(x, y);
          break;
        case 'v':
          y += take();
          p.lineTo(x, y);
          break;
        case 'A':
        case 'a': {
          final rx = take();
          final ry = take();
          take(); // x-axis-rotation (ignored — circles only)
          take(); // large-arc-flag
          take(); // sweep-flag
          final ex = cmd == 'A' ? take() : x + take();
          final ey = cmd == 'A' ? take() : y + take();
          p.arcToPoint(
            Offset(ex, ey),
            radius: Radius.elliptical(rx, ry),
            largeArc: false,
            clockwise: true,
          );
          x = ex;
          y = ey;
          break;
        }
        default:
          // Skip unknown number; safety
          i++;
      }
    }
    canvas.drawPath(p, paint);
  }

  static final _cmdRe = RegExp(r'[MmLlHhVvAaZzCcSsQqTt]');
  static final _numRe = RegExp(r'-?\d*\.?\d+');

  List<dynamic> _tokenize(String s) {
    final out = <dynamic>[];
    int i = 0;
    while (i < s.length) {
      final ch = s[i];
      if (_cmdRe.hasMatch(ch)) {
        out.add(ch);
        i++;
      } else if (ch == ' ' || ch == ',') {
        i++;
      } else {
        final m = _numRe.matchAsPrefix(s, i);
        if (m != null) {
          out.add(double.parse(m.group(0)!));
          i = m.end;
        } else {
          i++;
        }
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(_IconPainter old) =>
      old.path != path || old.color != color || old.strokeWidth != strokeWidth;
}
