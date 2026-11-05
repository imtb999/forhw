import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_badge_button.dart';

// Screen 2: selected sneakers, remove buttons, total and Clear All.
// All changes go through the shared CartProvider, so the Catalog
// is already up to date when the user goes back.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          TextButton.icon(
            key: const Key('clearAllButton'),
            onPressed: cart.isEmpty ? null : () => _confirmClear(context),
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Clear All'),
          ),
          const CartBadgeButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.count,
              itemBuilder: (_, i) => _CartItemTile(product: cart.items[i]),
            ),
      bottomNavigationBar: _TotalBar(count: cart.count, total: cart.totalPrice),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All sneakers will be removed from the cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            key: const Key('confirmClearButton'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CartProvider>().clear();
    }
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(product.imagePath),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          product.formattedPrice,
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        trailing: IconButton(
          key: Key('remove_${product.id}'),
          tooltip: 'Remove',
          icon: const Icon(Icons.remove_circle_outline),
          color: theme.colorScheme.error,
          onPressed: () => _remove(context),
        ),
      ),
    );
  }

  void _remove(BuildContext context) {
    final cart = context.read<CartProvider>();
    cart.remove(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.title} removed'),
          // UNDO adds the item back from Screen 2 - the Catalog syncs too.
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () => cart.add(product),
          ),
        ),
      );
  }
}

class _TotalBar extends StatelessWidget {
  const _TotalBar({required this.count, required this.total});

  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Text(
                '$count ${count == 1 ? 'item' : 'items'}',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(width: 16),
              // FittedBox shrinks a long total instead of overflowing.
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text('Total: ', style: theme.textTheme.titleMedium),
                      Text(
                        Product.formatTenge(total),
                        key: const Key('totalPrice'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 72,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text('Cart is Empty', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Add sneakers on the Catalog screen'),
        ],
      ),
    );
  }
}
