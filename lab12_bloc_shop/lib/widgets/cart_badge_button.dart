import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/cart_bloc.dart';

/// AppBar cart icon. Only this widget rebuilds when the count changes.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) => prev.count != curr.count,
      builder: (context, state) => IconButton(
        key: const Key('cart_button'),
        tooltip: 'Cart',
        onPressed: onPressed,
        icon: Badge(
          isLabelVisible: state.count > 0,
          label: Text('${state.count}', key: const Key('cart_badge')),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
      ),
    );
  }
}
