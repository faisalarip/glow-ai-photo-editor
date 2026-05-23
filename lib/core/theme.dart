import 'package:flutter/material.dart';

/// Ports `THEMES` and `ACCENTS` from primitives.jsx. Drives every screen via
/// `GlowTheme.of(context)`.
@immutable
class GlowPalette {
  final String name;
  final Color bg, surface, surface2, surface3;
  final Color line, line2;
  final Color text, text2, muted, mute2;
  final Color accent, ai, info, success, danger, warn;
  final Color chip, chipText, overlay;
  final bool statusDark;

  const GlowPalette({
    required this.name,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surface3,
    required this.line,
    required this.line2,
    required this.text,
    required this.text2,
    required this.muted,
    required this.mute2,
    required this.accent,
    required this.ai,
    required this.info,
    required this.success,
    required this.danger,
    required this.warn,
    required this.chip,
    required this.chipText,
    required this.overlay,
    required this.statusDark,
  });

  GlowPalette withAccent(Color a) => GlowPalette(
        name: name,
        bg: bg,
        surface: surface,
        surface2: surface2,
        surface3: surface3,
        line: line,
        line2: line2,
        text: text,
        text2: text2,
        muted: muted,
        mute2: mute2,
        accent: a,
        ai: ai,
        info: info,
        success: success,
        danger: danger,
        warn: warn,
        chip: chip,
        chipText: chipText,
        overlay: overlay,
        statusDark: statusDark,
      );

  static const dark = GlowPalette(
    name: 'dark',
    bg: Color(0xFF0B0B0E),
    surface: Color(0xFF16161C),
    surface2: Color(0xFF1F1F27),
    surface3: Color(0xFF2A2A33),
    line: Color(0xFF28282F),
    line2: Color(0xFF3A3A44),
    text: Color(0xFFF5F5F8),
    text2: Color(0xFFC5C5CC),
    muted: Color(0xFF8A8A95),
    mute2: Color(0xFF5A5A65),
    accent: Color(0xFFFF8A5C),
    ai: Color(0xFF9B7DFF),
    info: Color(0xFF5B9DEF),
    success: Color(0xFF34D399),
    danger: Color(0xFFF87171),
    warn: Color(0xFFF5C26B),
    chip: Color(0x0FFFFFFF),
    chipText: Color(0xFFC5C5CC),
    overlay: Color(0x80000000),
    statusDark: true,
  );

  static const light = GlowPalette(
    name: 'light',
    bg: Color(0xFFF7F6F2),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFF0EEE9),
    surface3: Color(0xFFE6E3DA),
    line: Color(0xFFE3E0D8),
    line2: Color(0xFFC9C5BA),
    text: Color(0xFF1A1A20),
    text2: Color(0xFF3F3F48),
    muted: Color(0xFF6E6E78),
    mute2: Color(0xFFA0A0A8),
    accent: Color(0xFFD97757),
    ai: Color(0xFF7C5CFF),
    info: Color(0xFF3A78D6),
    success: Color(0xFF2D8659),
    danger: Color(0xFFC2412B),
    warn: Color(0xFFC99B3D),
    chip: Color(0x0A000000),
    chipText: Color(0xFF3F3F48),
    overlay: Color(0x80000000),
    statusDark: false,
  );
}

enum AccentName { coral, azure, matcha, candy, amber }

class Accents {
  static const _map = <AccentName, (Color, Color)>{
    AccentName.coral: (Color(0xFFFF8A5C), Color(0xFFD97757)),
    AccentName.azure: (Color(0xFF5BA8FF), Color(0xFF3A78D6)),
    AccentName.matcha: (Color(0xFF7DD3A0), Color(0xFF2D8659)),
    AccentName.candy: (Color(0xFFFF4D8C), Color(0xFFE63D7A)),
    AccentName.amber: (Color(0xFFFFB845), Color(0xFFD9952C)),
  };
  static Color forTheme(AccentName a, bool dark) =>
      dark ? _map[a]!.$1 : _map[a]!.$2;
}

enum Density { compact, regular, comfy }

extension DensityMul on Density {
  double get mul => switch (this) {
        Density.compact => 0.88,
        Density.regular => 1.0,
        Density.comfy => 1.12,
      };
  double scale(double v) => v * mul;
}

enum AppLang { id, en }

/// Theme config, exposed via [GlowTheme.of].
@immutable
class GlowConfig {
  final bool dark;
  final AccentName accent;
  final Density density;
  final AppLang lang;
  final bool showFrame;
  final double demoSpeed;

  const GlowConfig({
    this.dark = true,
    this.accent = AccentName.coral,
    this.density = Density.regular,
    this.lang = AppLang.id,
    this.showFrame = true,
    this.demoSpeed = 1.0,
  });

  GlowConfig copyWith({
    bool? dark,
    AccentName? accent,
    Density? density,
    AppLang? lang,
    bool? showFrame,
    double? demoSpeed,
  }) =>
      GlowConfig(
        dark: dark ?? this.dark,
        accent: accent ?? this.accent,
        density: density ?? this.density,
        lang: lang ?? this.lang,
        showFrame: showFrame ?? this.showFrame,
        demoSpeed: demoSpeed ?? this.demoSpeed,
      );

  GlowPalette get palette {
    final base = dark ? GlowPalette.dark : GlowPalette.light;
    return base.withAccent(Accents.forTheme(accent, dark));
  }
}

class GlowTheme extends InheritedWidget {
  final GlowConfig config;
  final ValueChanged<GlowConfig> setConfig;

  const GlowTheme({
    super.key,
    required this.config,
    required this.setConfig,
    required super.child,
  });

  static GlowTheme of(BuildContext c) {
    final w = c.dependOnInheritedWidgetOfExactType<GlowTheme>();
    assert(w != null, 'GlowTheme.of called without an ancestor GlowTheme.');
    return w!;
  }

  GlowPalette get palette => config.palette;
  double d(double v) => config.density.scale(v);

  @override
  bool updateShouldNotify(GlowTheme old) => old.config != config;
}
