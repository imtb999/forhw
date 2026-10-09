import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5_sneaker_store/main.dart';
import 'package:lab5_sneaker_store/screens/catalog_screen.dart';

Finder field(String key) => find.byKey(Key(key));
Finder get confirmation => find.byType(TextFormField).at(3);

Future<void> enter(WidgetTester tester, Finder target, String text) async {
  await tester.ensureVisible(target);
  await tester.enterText(target, text);
  await tester.pumpAndSettle();
}

Future<void> submit(WidgetTester tester) async {
  tester.testTextInput.hide();
  await tester.ensureVisible(field('register'));
  await tester.tap(field('register'));
  await tester.pumpAndSettle();
}

Future<void> fillValid(WidgetTester tester) async {
  await enter(tester, field('fullName'), '  Test Student  ');
  await enter(tester, field('email'), '  student@narxoz.kz  ');
  await enter(tester, field('password'), 'abc123');
  await enter(tester, confirmation, 'abc123');
}

void main() {
  testWidgets('Submit validates all empty fields and unchecked terms', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerStoreApp());
    expect(find.text('Enter your full name.'), findsNothing);
    await submit(tester);
    for (final error in [
      'Enter your full name.',
      'Enter your email.',
      'Enter a password.',
      'Confirm your password.',
      'Accept the Terms and Conditions to continue.',
    ]) {
      expect(find.text(error), findsOneWidget);
    }
    expect(find.byType(CatalogScreen), findsNothing);
    await enter(tester, field('fullName'), '   ');
    expect(find.text('Enter your full name.'), findsOneWidget);
  });

  testWidgets(
    'Email and password validate live and confirmation follows password edits',
    (tester) async {
      await tester.pumpWidget(const SneakerStoreApp());
      for (final email in [
        'invalid',
        'name@narxoz',
        'name.narxoz.kz',
        '@.',
        'a b@c.kz',
        'a@@b.kz',
      ]) {
        await enter(tester, field('email'), email);
        expect(find.text('Use an email like name@narxoz.kz.'), findsOneWidget);
      }
      await enter(tester, field('email'), 'name@narxoz.kz');
      expect(find.text('Use an email like name@narxoz.kz.'), findsNothing);
      await enter(tester, field('password'), '12345');
      expect(find.text('Use at least 6 characters.'), findsOneWidget);
      await enter(tester, field('password'), '123456');
      expect(find.text('Use at least 6 characters.'), findsNothing);
      await enter(tester, confirmation, '123456 ');
      expect(find.text('Passwords must match exactly.'), findsOneWidget);
      await enter(tester, confirmation, '123456');
      expect(find.text('Passwords must match exactly.'), findsNothing);
      await enter(tester, field('password'), '654321');
      expect(find.text('Passwords must match exactly.'), findsOneWidget);
      await enter(tester, confirmation, '654321');
      expect(find.text('Passwords must match exactly.'), findsNothing);
      expect(
        tester.widget<TextFormField>(field('password')).controller!.text,
        '654321',
      );
      final inputs = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .toList();
      expect(inputs[2].obscureText, isTrue);
      expect(inputs[3].obscureText, isTrue);
    },
  );

  testWidgets(
    'Terms block submission; valid profile and selected role reach catalog',
    (tester) async {
      final messages = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) messages.add(message);
      };
      addTearDown(() => debugPrint = originalDebugPrint);
      await tester.pumpWidget(const SneakerStoreApp());
      await fillValid(tester);
      await submit(tester);
      expect(find.byType(CatalogScreen), findsNothing);
      expect(messages, isEmpty);
      await tester.ensureVisible(field('role'));
      await tester.tap(field('role'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Developer').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(field('terms'));
      await tester.tap(field('terms'));
      await tester.pump();
      expect(
        find.text('Accept the Terms and Conditions to continue.'),
        findsNothing,
      );
      await tester.tap(field('terms'));
      await tester.pump();
      expect(
        find.text('Accept the Terms and Conditions to continue.'),
        findsOneWidget,
      );
      await tester.tap(field('terms'));
      await submit(tester);
      expect(find.byType(CatalogScreen), findsOneWidget);
      expect(find.text('Welcome, Test Student!'), findsOneWidget);
      expect(find.text('Developer'), findsOneWidget);
      expect(
        find.text('Registration successful! Welcome to Sneaker Store.'),
        findsOneWidget,
      );
      final profile = tester
          .widget<CatalogScreen>(find.byType(CatalogScreen))
          .profile!;
      expect(profile.email, 'student@narxoz.kz');
      expect(messages.join(), contains('student@narxoz.kz'));
      expect(messages.join(), isNot(contains('abc123')));
      debugPrint = originalDebugPrint;
      expect(tester.takeException(), isNull);
    },
  );

  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'Registration layout $size, text $scale, keyboard and errors',
        (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetViewInsets);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await tester.pumpWidget(const SneakerStoreApp());
          await submit(tester);
          expect(tester.takeException(), isNull);
          tester.view.viewInsets = const FakeViewPadding(bottom: 180);
          await enter(tester, field('email'), 'wrong');
          expect(tester.takeException(), isNull);
          tester.view.resetViewInsets();
          await tester.pumpAndSettle();
          await fillValid(tester);
          await tester.ensureVisible(field('terms'));
          await tester.tap(field('terms'));
          await submit(tester);
          expect(find.byType(CatalogScreen), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
