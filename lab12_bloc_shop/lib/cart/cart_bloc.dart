import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

export 'cart_event.dart';
export 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddProductEvent>(_onAdd);
    on<RemoveProductEvent>(_onRemove);
    on<ClearCartEvent>(_onClear);
  }

  void _onAdd(AddProductEvent event, Emitter<CartState> emit) {
    final items = [...state.items];
    final index = items.indexWhere((i) => i.product.id == event.product.id);
    if (index == -1) {
      items.add(CartItem(product: event.product));
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    }
    emit(CartState.fromItems(items));
  }

  void _onRemove(RemoveProductEvent event, Emitter<CartState> emit) {
    emit(
      CartState.fromItems(
        state.items.where((i) => i.product.id != event.productId).toList(),
      ),
    );
  }

  void _onClear(ClearCartEvent event, Emitter<CartState> emit) =>
      emit(const CartState());
}
