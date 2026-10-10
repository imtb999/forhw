import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5_sneaker_store/main.dart';
import 'package:lab5_sneaker_store/screens/day_match_screen.dart';
import 'package:lab5_sneaker_store/services/day_match.dart';

void main() {
  test('Matches respect activity, budget and rating', () {
    expect(findDayMatch('Campus', 29989), isNull);
    expect(findDayMatch('Campus', 29990)!.name, 'Campus Basic');
    expect(findDayMatch('Campus', 60000)!.name, 'Nike Air Everyday');
    expect(findDayMatch('Walk', 40000)!.name, 'City Walk');
    expect(findDayMatch('Workout', 60000)!.name, 'Training Start');
    expect(findDayMatch('Workout', 65000)!.name, 'Cloud Runner');
    expect(findDayMatch('Unknown', 80000), isNull);
  });

  testWidgets('Catalog opens matcher and recommendation opens detail', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerStoreApp());
    await tester.tap(find.text('Find my pair for today'));
    await tester.pumpAndSettle();
    expect(find.byType(DayMatchScreen), findsOneWidget);
    await tester.tap(find.text('Workout'));
    await tester.pumpAndSettle();
    expect(find.text('Training Start'), findsOneWidget);
    await tester.ensureVisible(find.text('Training Start'));
    await tester.tap(find.text('Training Start'));
    await tester.pumpAndSettle();
    expect(find.text('Add to Cart'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ChoiceChip, 'Workout'), findsOneWidget);
  });

  for (final size in [
    const Size(280, 568),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    testWidgets('Matcher adapts to $size with large text and budget changes', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(const MaterialApp(home: DayMatchScreen()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final slider = find.byType(Slider);
      await tester.ensureVisible(slider);
      await tester.drag(slider, const Offset(-1500, 0));
      await tester.pumpAndSettle();
      expect(find.text('Budget: 20000 ₸'), findsOneWidget);
      expect(
        find.textContaining('No match within this budget.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.drag(slider, const Offset(1500, 0));
      await tester.pumpAndSettle();
      expect(find.text('Budget: 80000 ₸'), findsOneWidget);
      expect(find.text('Nike Air Everyday'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
