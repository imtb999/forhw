import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:lab9_global_cart/data/catalog.dart';
import 'package:lab9_global_cart/main.dart';
import 'package:lab9_global_cart/providers/cart_provider.dart';

Widget _app() => ChangeNotifierProvider(
  create: (_) => CartProvider(),
  child: const SneakerApp(),
);

// iPhone-sized screen so all 6 catalog cards are built.
Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1206, 2622);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app());
}

// Number shown on the AppBar badge ("0" when hidden).
String _badge(WidgetTester tester) {
  final badge = tester.widget<Badge>(
    find.descendant(
      of: find.byKey(const Key('cartBadgeButton')).first,
      matching: find.byType(Badge),
    ),
  );
  return badge.isLabelVisible ? (badge.label! as Text).data! : '0';
}

void main() {
  test('CartProvider: toggle, total, remove, clear', () {
    final cart = CartProvider();
    var notifications = 0;
    cart.addListener(() => notifications++);

    cart.toggle(catalog[0]);
    cart.toggle(catalog[1]);
    expect(cart.count, 2);
    expect(cart.totalPrice, 54990 + 47990);

    cart.toggle(catalog[0]);
    expect(cart.contains(catalog[0]), isFalse);

    cart.add(catalog[1]); // already in cart: no change, no notify
    cart.clear();
    expect(cart.isEmpty, isTrue);
    expect(notifications, 4);
  });

  testWidgets('Catalog shows 6 sneakers and the badge updates live', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text('Add'), findsNWidgets(6));
    expect(_badge(tester), '0');

    await tester.tap(find.byKey(const Key('toggle_1_out')));
    await tester.tap(find.byKey(const Key('toggle_3_out')));
    await tester.pumpAndSettle();
    expect(_badge(tester), '2');
    expect(find.text('In Cart'), findsNWidgets(2));

    await tester.tap(find.byKey(const Key('toggle_1_in')));
    await tester.pumpAndSettle();
    expect(_badge(tester), '1');
  });

  testWidgets('Changes on the Cart screen sync back to the Catalog', (
    tester,
  ) async {
    await _pumpApp(tester);
    for (final id in [1, 2, 5]) {
      await tester.tap(find.byKey(Key('toggle_${id}_out')));
    }
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cartBadgeButton')));
    await tester.pumpAndSettle();
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('161 970 ₸'), findsOneWidget); // 54990+47990+58990

    // Remove on Screen 2 -> total updates.
    await tester.tap(find.byKey(const Key('remove_2')));
    await tester.pumpAndSettle();
    expect(find.text('113 980 ₸'), findsOneWidget);

    // UNDO adds it back from Screen 2.
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('161 970 ₸'), findsOneWidget);

    // Remove another one, go back: Catalog already reflects it.
    await tester.tap(find.byKey(const Key('remove_5')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(_badge(tester), '2');
    expect(find.byKey(const Key('toggle_5_out')), findsOneWidget);
    expect(find.byKey(const Key('toggle_1_in')), findsOneWidget);
    expect(find.byKey(const Key('toggle_2_in')), findsOneWidget);

    // Clear All on Screen 2 resets every toggle on Screen 1.
    await tester.tap(find.byKey(const Key('cartBadgeButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('clearAllButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmClearButton')));
    await tester.pumpAndSettle();
    expect(find.text('Cart is Empty'), findsOneWidget);
    expect(find.text('0 ₸'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(_badge(tester), '0');
    expect(find.text('Add'), findsNWidgets(6));
  });
}
