import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab8_catalog_feed/data/catalog_repository.dart';
import 'package:lab8_catalog_feed/main.dart';
import 'package:lab8_catalog_feed/widgets/product_list_tile.dart';

void main() {
  testWidgets('List Feed is lazy and switches to a 2-column grid', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerApp());
    expect(find.text('Sneaker Catalog (24)'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Divider), findsWidgets);
    // Lazy: only the visible rows are built, not all 24.
    expect(
      find.byType(ProductListTile).evaluate().length,
      lessThan(CatalogRepository.seedCount),
    );

    await tester.tap(find.text('Grid Catalog'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(tester.takeException(), isNull); // no RenderFlex overflow

    await tester.tap(find.byTooltip('Show list'));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Pull-to-Refresh adds a new item at index 0 after 1.5 s', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerApp());
    await tester.fling(find.byType(ListView), const Offset(0, 400), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Sneaker Catalog (24)'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    expect(find.text('Sneaker Catalog (25)'), findsOneWidget);
    expect(find.textContaining('New Drop'), findsOneWidget);
  });

  testWidgets('Swipe deletes, UNDO restores at the original index', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerApp());
    final secondTitle = find.text('Cloud Runner');
    expect(secondTitle, findsOneWidget);

    await tester.drag(secondTitle, const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Sneaker Catalog (23)'), findsOneWidget);
    expect(find.text('Cloud Runner'), findsNothing);
    expect(find.byIcon(Icons.delete), findsNothing);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('Sneaker Catalog (24)'), findsOneWidget);
    // Back between Nike Air Everyday (0) and Ocean Flyknit (2).
    final y = tester.getCenter(find.text('Cloud Runner')).dy;
    expect(y, greaterThan(tester.getCenter(find.text('Nike Air Everyday')).dy));
    expect(y, lessThan(tester.getCenter(find.text('Ocean Flyknit')).dy));
  });

  testWidgets('Empty state appears and Reset Catalog restores seed data', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerApp());
    // SnackBar has its own Dismissible, so only match product items.
    final items = find.byWidgetPredicate(
      (w) => w is Dismissible && w.key is ValueKey<int>,
    );
    while (items.evaluate().isNotEmpty) {
      await tester.drag(items.first, const Offset(-600, 0));
      await tester.pumpAndSettle();
    }
    expect(find.text('Catalog is Empty'), findsOneWidget);

    await tester.tap(find.text('Reset Catalog'));
    await tester.pumpAndSettle();
    expect(find.text('Sneaker Catalog (24)'), findsOneWidget);
  });
}
