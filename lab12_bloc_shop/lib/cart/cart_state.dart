import 'package:equatable/equatable.dart';

import '../models/product.dart';

class CartItem extends Equatable {
  const CartItem({required this.product, this.quantity = 1});

  final Product product;
  final int quantity;

  int get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}

class CartState extends Equatable {
  const CartState({this.items = const [], this.totalPrice = 0, this.count = 0});

  /// Builds a state with totalPrice and count derived from [items].
  factory CartState.fromItems(List<CartItem> items) => CartState(
    items: List.unmodifiable(items),
    totalPrice: items.fold(0, (sum, i) => sum + i.subtotal),
    count: items.fold(0, (sum, i) => sum + i.quantity),
  );

  final List<CartItem> items;
  final int totalPrice;
  final int count;

  bool get isEmpty => items.isEmpty;

  @override
  List<Object?> get props => [items, totalPrice, count];
}
