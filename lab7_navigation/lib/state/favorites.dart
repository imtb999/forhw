import 'package:flutter/widgets.dart';

import '../models/product.dart';

// Holds the saved items. It lives above the Navigator, so pushing and popping
// screens never resets it.
class FavoritesController extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  bool contains(Product product) => _items.any((p) => p.id == product.id);

  void toggle(Product product) {
    if (contains(product)) {
      _items.removeWhere((p) => p.id == product.id);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }
}

// Gives every screen access to the controller and rebuilds them on changes.
class FavoritesScope extends InheritedNotifier<FavoritesController> {
  const FavoritesScope({
    super.key,
    required FavoritesController controller,
    required super.child,
  }) : super(notifier: controller);

  static FavoritesController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FavoritesScope>();
    assert(scope != null, 'FavoritesScope not found in the widget tree');
    return scope!.notifier!;
  }
}
