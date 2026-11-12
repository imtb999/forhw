import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

// AppBar cart icon with a live item counter.
// context.select rebuilds this widget only when the count changes.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((cart) => cart.count);
    return IconButton(
      key: const Key('cartBadgeButton'),
      tooltip: 'Cart ($count)',
      onPressed: onPressed,
      icon: Badge.count(
        count: count,
        isLabelVisible: count > 0,
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
