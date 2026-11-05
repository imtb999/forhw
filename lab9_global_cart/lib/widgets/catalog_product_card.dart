import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'category_chip.dart';
import 'rating_badge.dart';

// Catalog row: photo, title, category, rating, price and the Add to Cart toggle.
class CatalogProductCard extends StatelessWidget {
  const CatalogProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Rebuild only this card when ITS in-cart state changes.
    final inCart = context.select<CartProvider, bool>(
      (cart) => cart.contains(product),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(product.imagePath),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Wrap instead of Row: moves the rating to a new line
                  // on narrow screens instead of overflowing.
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CategoryChip(label: product.category),
                      RatingBadge(rating: product.rating),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.formattedPrice,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _CartToggle(product: product, inCart: inCart),
          ],
        ),
      ),
    );
  }
}

class _CartToggle extends StatelessWidget {
  const _CartToggle({required this.product, required this.inCart});

  final Product product;
  final bool inCart;

  @override
  Widget build(BuildContext context) {
    void onPressed() => context.read<CartProvider>().toggle(product);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: inCart
          ? FilledButton.tonalIcon(
              key: Key('toggle_${product.id}_in'),
              onPressed: onPressed,
              icon: const Icon(Icons.check),
              label: const Text('In Cart'),
            )
          : FilledButton.icon(
              key: Key('toggle_${product.id}_out'),
              onPressed: onPressed,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add'),
            ),
    );
  }
}
