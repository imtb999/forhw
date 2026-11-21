import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab12_bloc_shop/main.dart';

void main() {
  testWidgets('login error, login success, badge sync and cart', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BlocShopApp(authDelay: Duration(milliseconds: 300)),
    );

    // Wrong password -> spinner, then red floating SnackBar.
    await tester.enterText(
      find.byKey(const Key('email_field')),
      'student@narxoz.kz',
    );
    await tester.enterText(find.byKey(const Key('password_field')), '000000');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsNothing);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    final bar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(bar.backgroundColor, Colors.red);
    expect(bar.behavior, SnackBarBehavior.floating);
    expect(find.text('Invalid email or password'), findsOneWidget);

    // Correct password -> Catalog.
    await tester.enterText(find.byKey(const Key('password_field')), '123456');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Catalog'), findsOneWidget);
    expect(find.text('Hi, student'), findsOneWidget);
    expect(find.byKey(const Key('cart_badge')), findsNothing);

    await tester.tap(find.byKey(const Key('add_1')));
    await tester.tap(find.byKey(const Key('add_1')));
    await tester.tap(find.byKey(const Key('add_2')));
    await tester.pump();
    expect(find.text('3'), findsOneWidget);

    // Cart screen: same live badge, remove, total, clear all.
    await tester.tap(find.byKey(const Key('cart_button')));
    await tester.pumpAndSettle();
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('157 970 ₸'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remove_1')));
    await tester.pump();
    expect(find.byKey(const Key('cart_total')), findsOneWidget);
    expect(find.text('Total (1 items)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clear_all')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm_clear')));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Back on catalog the badge is gone too.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cart_badge')), findsNothing);
  });
}
