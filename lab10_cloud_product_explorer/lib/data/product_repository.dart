import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductRequestException implements Exception {
  const ProductRequestException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ProductRepository {
  ProductRepository({
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client();
  final http.Client _client;
  final Duration timeout;

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client
          .get(Uri.parse('https://fakestoreapi.com/products'))
          .timeout(timeout);
      if (response.statusCode != 200) {
        throw ProductRequestException(switch (response.statusCode) {
          404 => 'Products were not found (404). Please try again.',
          >= 500 =>
            'The server is unavailable (${response.statusCode}). Please try again.',
          _ => 'Request failed (${response.statusCode}). Please try again.',
        });
      }
      final data = jsonDecode(response.body);
      if (data is! List) throw const FormatException('Expected a product list');
      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid product');
        }
        return Product.fromJson(item);
      }).toList();
    } on TimeoutException {
      throw const ProductRequestException(
        'The request timed out after 10 seconds. Check your connection.',
      );
    } on http.ClientException {
      throw const ProductRequestException(
        'Unable to connect. Check your internet connection and try again.',
      );
    } on FormatException {
      throw const ProductRequestException(
        'The server returned invalid product data. Please try again.',
      );
    } on ProductRequestException {
      rethrow;
    } catch (_) {
      throw const ProductRequestException(
        'Unable to load products. Check your connection and try again.',
      );
    }
  }

  void dispose() => _client.close();
}
