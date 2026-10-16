import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab7_navigation/main.dart';

void main() {
  testWidgets('push detail with product, save it, pop back, see in Favorites', (
    tester,
  ) async {
    await tester.pumpWidget(const SneakerApp());

    // Feed shows the list.
    expect(find.text('Nike Air Everyday'), findsOneWidget);
    expect(find.text('Forest Trail'), findsOneWidget);

    // Push DetailScreen with the full product.
    await tester.tap(find.text('Ocean Flyknit'));
    await tester.pumpAndSettle();
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('71 490 ₸'), findsOneWidget);
    expect(find.textContaining('deep blue knit'), findsOneWidget);

    await tester.ensureVisible(find.text('Add to favorites'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to favorites'));
    await tester.pump();

    // In-body back button pops to the feed.
    await tester.ensureVisible(find.text('Back to list'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to list'));
    await tester.pumpAndSettle();
    expect(find.text('Description'), findsNothing);

    // AppBar back icon also pops.
    await tester.tap(find.text('Cloud Runner'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Description'), findsNothing);

    // Favorites tab keeps the saved item.
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Ocean Flyknit'), findsWidgets);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Profile tab shows settings', (tester) async {
    await tester.pumpWidget(const SneakerApp());
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();
    expect(find.text('Dark mode'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));
  });
}
