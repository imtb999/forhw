import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_cloud_product_explorer/models/product.dart';

void main() {
  test('integer, decimal and malformed JSON numbers', () {
    final product = Product.fromJson({
      'id': 1,
      'price': 12,
      'rating': {'rate': 4, 'count': 20},
    });
    expect(product.price, 12.0);
    expect(product.rating, 4.0);
    expect(product.reviewCount, 20);
    expect(Product.fromJson({'price': 12.99}).price, 12.99);
    for (final json in <Map<String, dynamic>>[
      {},
      {'price': null, 'rating': null},
      {'id': 'bad', 'price': 'bad', 'rating': [], 'image': 8},
    ]) {
      final fallback = Product.fromJson(json);
      expect(fallback.price, 0.0);
      expect(fallback.rating, 0.0);
      expect(fallback.reviewCount, 0);
      expect(fallback.imageUrl, '');
    }
  });
}
