import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme.dart';
import 'screens/ai_recs.dart';
import 'screens/editor.dart';
import 'screens/flow.dart';
import 'screens/home.dart';
import 'screens/library_profile_paywall.dart';
import 'screens/onboarding.dart';
import 'screens/templates_compare.dart';
import 'widgets/glow_icon.dart';
import 'widgets/primitives.dart';

void main() {
  runApp(const GlowApp());
}

class GlowApp extends StatefulWidget {
  const GlowApp({super.key});
  @override
  State<GlowApp> createState() => _GlowAppState();
}

class _GlowAppState extends State<GlowApp> {
  GlowConfig _config = const GlowConfig();

  @override
  Widget build(BuildContext context) {
    final palette = _config.palette;
    return GlowTheme(
      config: _config,
      setConfig: (c) => setState(() => _config = c),
      child: MaterialApp(
        title: 'Glow — AI Photo Editor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: _config.dark ? Brightness.dark : Brightness.light,
          scaffoldBackgroundColor: palette.bg,
          textTheme: GoogleFonts.interTextTheme(
            _config.dark
                ? ThemeData.dark().textTheme
                : ThemeData.light().textTheme,
          ),
        ),
        home: const _Shell(),
      ),
    );
  }
}

/// 11 screen flows reachable via bottom tabs + a "View all" sheet that lists
/// every variant for the design walkthrough.
class _Shell extends StatefulWidget {
  const _Shell();
  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  static final _flow = <(_FlowSection, String, WidgetBuilder)>[
    (_FlowSection.onboarding, 'Onboarding · Welcome',
        (_) => const OnboardingA()),
    (_FlowSection.onboarding, 'Onboarding · Features',
        (_) => const OnboardingB()),
    (_FlowSection.onboarding, 'Onboarding · Live AI demo',
        (_) => const OnboardingC()),
    (_FlowSection.home, 'Home · Feed', (_) => const HomeA()),
    (_FlowSection.studio, 'Templates', (_) => const TemplatesScreen()),
    (_FlowSection.studio, 'AI Recommendations', (_) => const AIRecsScreen()),
    (_FlowSection.studio, 'Editor · Hybrid', (_) => const EditorC()),
    (_FlowSection.studio, 'Before / After', (_) => const BeforeAfterScreen()),
    (_FlowSection.briefs, 'Brand Inbox', (_) => const BrandInboxScreen()),
    (_FlowSection.briefs, 'Export sheet', (_) => const ExportScreen()),
    (_FlowSection.library, 'Library', (_) => const LibraryScreen()),
    (_FlowSection.profile, 'Profile', (_) => const ProfileScreen()),
    (_FlowSection.profile, 'Paywall · Glow Pro', (_) => const PaywallScreen()),
  ];

  int _idx = 2; // start on Onboarding C — the wow screen
  bool _autoPlay = false;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 3200));
      if (!mounted || !_autoPlay) continue;
      setState(() => _idx = (_idx + 1) % _flow.length);
    }
  }

  void _onTabTap(String tab) {
    final section = switch (tab) {
      'home' => _FlowSection.home,
      'studio' => _FlowSection.studio,
      'briefs' => _FlowSection.briefs,
      'library' => _FlowSection.library,
      'profile' => _FlowSection.profile,
      _ => _FlowSection.home,
    };
    final target = _flow.indexWhere((e) => e.$1 == section);
    if (target != -1) setState(() => _idx = target);
  }

  @override
  Widget build(BuildContext context) {
    final theme = GlowTheme.of(context);
    final palette = theme.palette;
    final cur = _flow[_idx];

    return Scaffold(
      backgroundColor: palette.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _Stage(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(anim);
                    return FadeTransition(
                      opacity: anim,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey('${cur.$2}-${theme.config.hashCode}'),
                    child: _ScreenHost(
                      label: cur.$2,
                      onPrev: () => setState(() =>
                          _idx = (_idx - 1 + _flow.length) % _flow.length),
                      onNext: () => setState(() =>
                          _idx = (_idx + 1) % _flow.length),
                      onTabTap: _onTabTap,
                      child: cur.$3(context),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  _PillBtn(
                    label: _autoPlay ? 'Pause' : 'Auto-demo',
                    icon: _autoPlay ? 'pause' : 'play',
                    onTap: () => setState(() => _autoPlay = !_autoPlay),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: palette.surface,
                      border: Border.all(color: palette.line),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${_idx + 1} / ${_flow.length}  ·  ${cur.$2}',
                      style: GoogleFonts.jetBrainsMono(
                        color: palette.text2,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _PillBtn(
                label: 'Tweaks',
                icon: 'settings',
                onTap: () => _openTweaks(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTweaks(BuildContext context) {
    final theme = GlowTheme.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TweaksSheet(
        config: theme.config,
        onChanged: (c) => theme.setConfig(c),
      ),
    );
  }
}

enum _FlowSection { onboarding, home, studio, briefs, library, profile }

class _Stage extends StatelessWidget {
  final Widget child;
  const _Stage({required this.child});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: child,
        ),
      ),
    );
  }
}

class _ScreenHost extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<String> onTabTap;
  const _ScreenHost({
    required this.child,
    required this.label,
    required this.onPrev,
    required this.onNext,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return ScreenInteractionScope(
      onTabTap: onTabTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavArrow(icon: 'chevron_l', onTap: onPrev, color: t.text2),
          const SizedBox(width: 24),
          child,
          const SizedBox(width: 24),
          _NavArrow(icon: 'chevron_r', onTap: onNext, color: t.text2),
        ],
      ),
    );
  }
}

class ScreenInteractionScope extends InheritedWidget {
  final ValueChanged<String> onTabTap;
  const ScreenInteractionScope({
    super.key,
    required this.onTabTap,
    required super.child,
  });
  static ValueChanged<String>? of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<ScreenInteractionScope>()?.onTabTap;
  @override
  bool updateShouldNotify(ScreenInteractionScope old) => false;
}

class _NavArrow extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final Color color;
  const _NavArrow({required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: GlowIcon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _PillBtn extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;
  const _PillBtn(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: t.surface,
            border: Border.all(color: t.line),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlowIcon(icon, size: 14, color: t.text2),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: t.text2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TweaksSheet extends StatefulWidget {
  final GlowConfig config;
  final ValueChanged<GlowConfig> onChanged;
  const _TweaksSheet({required this.config, required this.onChanged});

  @override
  State<_TweaksSheet> createState() => _TweaksSheetState();
}

class _TweaksSheetState extends State<_TweaksSheet> {
  late GlowConfig _c = widget.config;

  void _set(GlowConfig next) {
    setState(() => _c = next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = _c.palette;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tweaks',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: t.text,
              ),
            ),
            const SizedBox(height: 16),
            _section('Theme'),
            Row(
              children: [
                _seg('Dark', _c.dark,
                    () => _set(_c.copyWith(dark: true))),
                const SizedBox(width: 6),
                _seg('Light', !_c.dark,
                    () => _set(_c.copyWith(dark: false))),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: AccentName.values.map((a) {
                final selected = a == _c.accent;
                final color = Accents.forTheme(a, _c.dark);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _set(_c.copyWith(accent: a)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: color,
                                  blurRadius: 0,
                                  spreadRadius: 2,
                                ),
                                const BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 0,
                                  spreadRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: selected
                          ? const GlowIcon('check',
                              size: 14, color: Colors.white, strokeWidth: 2.5)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            _section('Layout'),
            Row(
              children: Density.values.map((d) {
                final selected = d == _c.density;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _set(_c.copyWith(density: d)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? t.accent.withValues(alpha: 0.15)
                            : t.surface,
                        border: Border.all(
                          color: selected ? t.accent : t.line,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        d.name,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? t.accent : t.text2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _c.showFrame,
              onChanged: (v) => _set(_c.copyWith(showFrame: v)),
              activeColor: t.accent,
              title: Text(
                'Phone frame',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.text,
                ),
              ),
            ),
            const SizedBox(height: 6),
            _section('Language'),
            Row(
              children: AppLang.values.map((l) {
                final selected = l == _c.lang;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _set(_c.copyWith(lang: l)),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? t.accent.withValues(alpha: 0.15)
                            : t.surface,
                        border: Border.all(
                          color: selected ? t.accent : t.line,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        l.name.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected ? t.accent : t.text2,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          s.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: _c.palette.muted,
            letterSpacing: 1.2,
          ),
        ),
      );

  Widget _seg(String label, bool selected, VoidCallback onTap) {
    final t = _c.palette;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                selected ? t.accent.withValues(alpha: 0.15) : t.surface,
            border: Border.all(color: selected ? t.accent : t.line),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? t.accent : t.text2,
            ),
          ),
        ),
      ),
    );
  }
}
