import 'package:equatable/equatable.dart';

import '../models/product.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddProductEvent extends CartEvent {
  const AddProductEvent(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

class RemoveProductEvent extends CartEvent {
  const RemoveProductEvent(this.productId);

  final int productId;

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
