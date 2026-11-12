import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:lab10_cloud_product_explorer/data/product_repository.dart';
import 'package:lab10_cloud_product_explorer/providers/cart_provider.dart';
import 'package:lab10_cloud_product_explorer/screens/catalog_screen.dart';

void main() {
  testWidgets('loading, retry, refresh, carousel, cart and copy', (
    tester,
  ) async {
    var calls = 0;
    final first = Completer<http.Response>();
    final repository = ProductRepository(
      client: MockClient((_) {
        calls++;
        if (calls == 1) return first.future;
        return Future.value(
          http.Response(
            '[{"id":7,"title":"Test Bag","price":12,"description":"Full description","category":"Bags"}]',
            200,
          ),
        );
      }),
    );
    addTearDown(repository.dispose);
    final cart = CartProvider();
    addTearDown(cart.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: cart,
        child: MaterialApp(home: CatalogScreen(repository: repository)),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    first.completeError(http.ClientException('offline'));
    await tester.pumpAndSettle();
    expect(find.text('Retry Connection'), findsOneWidget);
    await tester.tap(find.text('Retry Connection'));
    await tester.pumpAndSettle();
    expect(find.text('Test Bag'), findsOneWidget);
    expect(calls, 2);
    await tester.drag(find.byType(ListView), const Offset(0, 400));
    await tester.pumpAndSettle();
    expect(calls, 3);
    await tester.tap(find.text('Test Bag'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(PageView), const Offset(-700, 0));
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();
    expect(cart.count, 1);
    expect(cart.totalPrice, 12.0);
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.tap(find.byTooltip('Share'));
    await tester.pumpAndSettle();
    expect(find.text('narxoz://store/product/7'), findsOneWidget);
    await tester.tap(find.text('Copy Link'));
    await tester.pumpAndSettle();
    expect(copied, 'narxoz://store/product/7');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cart (1)'));
    await tester.pumpAndSettle();
    expect(find.text('Test Bag'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
