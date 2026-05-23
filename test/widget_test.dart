import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:glow_app/core/theme.dart';
import 'package:glow_app/widgets/glow_icon.dart';
import 'package:glow_app/widgets/primitives.dart';

void main() {
  Widget _wrap(Widget child, {bool dark = true}) {
    return MaterialApp(
      home: Material(
        child: Builder(
          builder: (_) {
            late GlowConfig cfg;
            cfg = GlowConfig(dark: dark);
            return GlowTheme(
              config: cfg,
              setConfig: (_) {},
              child: child,
            );
          },
        ),
      ),
    );
  }

  testWidgets('GlowLogo renders without overflow', (tester) async {
    await tester.pumpWidget(_wrap(const Center(child: GlowLogo(withText: true))));
    expect(find.text('Glow'), findsOneWidget);
  });

  testWidgets('GlowIcon renders a known icon', (tester) async {
    await tester.pumpWidget(_wrap(const Center(child: GlowIcon('sparkle'))));
    expect(find.byType(GlowIcon), findsOneWidget);
  });

  testWidgets('Avatar shows initial', (tester) async {
    await tester.pumpWidget(_wrap(const Center(child: Avatar(name: 'Andin'))));
    expect(find.text('A'), findsOneWidget);
  });
}
