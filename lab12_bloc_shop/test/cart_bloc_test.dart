import 'package:flutter_test/flutter_test.dart';
import 'package:lab12_bloc_shop/cart/cart_bloc.dart';
import 'package:lab12_bloc_shop/data/catalog.dart';

Future<void> settle() => Future<void>.delayed(Duration.zero);

void main() {
  test('add, add same, remove and clear', () async {
    final bloc = CartBloc();
    bloc
      ..add(AddProductEvent(catalog[0]))
      ..add(AddProductEvent(catalog[0]))
      ..add(AddProductEvent(catalog[1]));
    await settle();
    expect(bloc.state.count, 3);
    expect(bloc.state.items.length, 2);
    expect(bloc.state.items.first.quantity, 2);
    expect(bloc.state.totalPrice, 54990 * 2 + 47990);

    bloc.add(RemoveProductEvent(catalog[0].id));
    await settle();
    expect(bloc.state.count, 1);
    expect(bloc.state.totalPrice, 47990);

    bloc.add(const ClearCartEvent());
    await settle();
    expect(bloc.state, const CartState());
    await bloc.close();
  });
}
