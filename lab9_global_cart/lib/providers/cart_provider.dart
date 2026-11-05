import 'package:flutter/foundation.dart';

import '../models/product.dart';

// Global cart state shared by every screen.
// Each change calls notifyListeners(), so all listening widgets rebuild at once.
class CartProvider extends ChangeNotifier {
  // Map literal = LinkedHashMap: keeps the order in which items were added
  // and cannot contain the same product twice.
  final Map<int, Product> _items = {};

  List<Product> get items => List.unmodifiable(_items.values);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  int get totalPrice =>
      _items.values.fold(0, (sum, product) => sum + product.price);

  bool contains(Product product) => _items.containsKey(product.id);

  void add(Product product) {
    if (contains(product)) return;
    _items[product.id] = product;
    notifyListeners();
  }

  void remove(Product product) {
    if (_items.remove(product.id) != null) notifyListeners();
  }

  // "Add to Cart" toggle: adds if absent, removes if present.
  void toggle(Product product) =>
      contains(product) ? remove(product) : add(product);

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
