import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile_card/main.dart';

void main() {
  testWidgets('Follow, like, unlike and reset update the profile', (
    tester,
  ) async {
    await tester.pumpWidget(const ProfileApp());
    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('2400'), findsOneWidget);
    expect(find.text('Like · 128'), findsOneWidget);

    await tester.tap(find.text('Follow'));
    await tester.pump();
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('2401'), findsOneWidget);
    await tester.tap(find.text('Following'));
    await tester.pump();
    expect(find.text('2400'), findsOneWidget);

    await tester.tap(find.text('Like · 128'));
    await tester.pump();
    expect(find.text('Liked · 129'), findsOneWidget);
    await tester.tap(find.text('Liked · 129'));
    await tester.pump();
    expect(find.text('Like · 128'), findsOneWidget);

    await tester.tap(find.text('Follow'));
    await tester.tap(find.text('Like · 128'));
    await tester.pump();
    await tester.ensureVisible(find.text('Reset'));
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(find.text('Follow'), findsOneWidget);
    expect(find.text('2400'), findsOneWidget);
    expect(find.text('Like · 128'), findsOneWidget);
  });

  testWidgets('Fits a small phone without layout overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ProfileApp());
    await tester.ensureVisible(find.text('Reset'));
    expect(tester.takeException(), isNull);
  });
}
