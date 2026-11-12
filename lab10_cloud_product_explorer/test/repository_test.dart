import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab10_cloud_product_explorer/data/product_repository.dart';

void main() {
  test('GET endpoint and parse 200', () async {
    final repository = ProductRepository(
      client: MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.toString(), 'https://fakestoreapi.com/products');
        return http.Response('[{"id":1,"price":15,"title":"Bag"}]', 200);
      }),
    );
    addTearDown(repository.dispose);
    expect((await repository.fetchProducts()).single.title, 'Bag');
  });
  for (final status in [404, 500]) {
    test('HTTP $status', () async {
      final repository = ProductRepository(
        client: MockClient((_) async => http.Response('', status)),
      );
      addTearDown(repository.dispose);
      await expectLater(
        repository.fetchProducts(),
        throwsA(
          isA<ProductRequestException>().having(
            (e) => e.message,
            'status',
            contains('$status'),
          ),
        ),
      );
    });
  }
  test('connection failure', () async {
    final repository = ProductRepository(
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    addTearDown(repository.dispose);
    await expectLater(
      repository.fetchProducts(),
      throwsA(isA<ProductRequestException>()),
    );
  });
  test('hanging request times out', () async {
    final repository = ProductRepository(
      timeout: const Duration(milliseconds: 10),
      client: MockClient((_) => Completer<http.Response>().future),
    );
    addTearDown(repository.dispose);
    await expectLater(
      repository.fetchProducts(),
      throwsA(
        isA<ProductRequestException>().having(
          (e) => e.message,
          'message',
          contains('timed out'),
        ),
      ),
    );
  });
  for (final body in ['invalid', '{}', '[4]']) {
    test('invalid response $body', () async {
      final repository = ProductRepository(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      addTearDown(repository.dispose);
      await expectLater(
        repository.fetchProducts(),
        throwsA(isA<ProductRequestException>()),
      );
    });
  }
}
