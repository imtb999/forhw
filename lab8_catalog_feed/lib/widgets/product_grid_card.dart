import 'package:flutter/material.dart';

import '../models/product.dart';
import 'category_chip.dart';
import 'rating_badge.dart';

// Card for the 2-column grid. The photo is Expanded, so the card takes
// whatever height childAspectRatio gives it and never overflows.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Image.asset(product.imagePath, fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                CategoryChip(label: product.category),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingBadge(rating: product.rating),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        product.formattedPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
