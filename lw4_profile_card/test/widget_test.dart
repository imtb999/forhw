import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lw4_profile_card/main.dart';

void main() {
  testWidgets(
    'Follow and Like toggle independently and Reset restores defaults',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Temirlan'), findsOneWidget);
      expect(find.text('Followers: 0'), findsOneWidget);
      expect(find.text('Likes: 0'), findsOneWidget);
      await tester.tap(find.text('Follow'));
      await tester.pump();
      expect(find.text('Following'), findsOneWidget);
      expect(find.text('Followers: 1'), findsOneWidget);
      await tester.tap(find.text('Likes: 0'));
      await tester.pump();
      expect(find.text('Likes: 1'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      await tester.tap(find.text('Likes: 1'));
      await tester.pump();
      expect(find.text('Likes: 0'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
      await tester.tap(find.text('Following'));
      await tester.pump();
      expect(find.text('Follow'), findsOneWidget);
      expect(find.text('Followers: 0'), findsOneWidget);
      await tester.tap(find.text('Follow'));
      await tester.tap(find.text('Likes: 0'));
      await tester.pump();
      await tester.tap(find.text('Reset'));
      await tester.pump();
      expect(find.text('Follow'), findsOneWidget);
      expect(find.text('Followers: 0'), findsOneWidget);
      expect(find.text('Likes: 0'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      await tester.tap(find.text('Reset'));
      await tester.pump();
      expect(find.text('Likes: 0'), findsOneWidget);
    },
  );

  testWidgets('Card fits a narrow phone and Reset remains reachable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Reset'));
    await tester.tap(find.text('Reset'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
