import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5_sneaker_store/screens/catalog_screen.dart';
import 'package:lab5_sneaker_store/widgets/product_card.dart';

void main() {
  testWidgets('Catalog filters and return navigation work', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CatalogScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(2));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Running'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);
    expect(find.text('Nike Air Everyday'), findsNothing);
    await tester.ensureVisible(find.text('Cloud Runner'));
    await tester.tap(find.text('Cloud Runner'));
    await tester.pumpAndSettle();
    expect(find.text('62990 ₸'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsNWidgets(2));
  });

  for (final size in [
    const Size(280, 568),
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('No overflow at $size with text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(const MaterialApp(home: CatalogScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Nike Air Everyday'));
        await tester.tap(find.text('Nike Air Everyday'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final button = find.widgetWithText(FilledButton, 'Add to Cart');
        expect(button.hitTestable(), findsOneWidget);
        final position = tester.getTopLeft(button);
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -1500),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(tester.getTopLeft(button), position);
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Cloud Runner'));
        await tester.tap(find.text('Cloud Runner'));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -1500),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(button.hitTestable(), findsOneWidget);
      });
    }
  }

  testWidgets('Bookmark, size selection and cart work', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CatalogScreen()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Nike Air Everyday'));
    await tester.tap(find.text('Nike Air Everyday'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final button = find.widgetWithText(FilledButton, 'Add to Cart');
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    await tester.tap(find.byTooltip('Save product'));
    await tester.pump();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove bookmark'));
    await tester.pump();
    expect(find.byTooltip('Save product'), findsOneWidget);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, '42'));
    await tester.tap(find.widgetWithText(ChoiceChip, '42'));
    await tester.pump();
    await tester.tap(button);
    await tester.pump();
    expect(find.text('EU 42 · Items in cart: 1'), findsOneWidget);
    expect(find.text('Size 42 added to cart'), findsOneWidget);
    await tester.tap(button);
    await tester.pump();
    expect(find.text('EU 42 · Items in cart: 2'), findsOneWidget);
  });
}
