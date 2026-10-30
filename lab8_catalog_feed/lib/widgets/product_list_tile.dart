import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_chip.dart';
import 'rating_badge.dart';

// One row of the List Feed: avatar, title, category, rating and price.
class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: AssetImage(product.imagePath),
      ),
      title: Text(
        product.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            CategoryChip(label: product.category),
            const SizedBox(width: 8),
            RatingBadge(rating: product.rating),
          ],
        ),
      ),
      trailing: Text(
        product.formattedPrice,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
