import 'package:flutter/material.dart';

import '../models/product.dart';
import '../screens/detail_screen.dart';
import '../state/favorites.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, this.useHero = true});

  final Product product;

  // Feed and Favorites are both alive inside IndexedStack, so only one of them
  // may own the Hero tag for a product.
  final bool useHero;

  void _openDetail(BuildContext context) {
    // Navigator.push with arguments: the full Product object goes to DetailScreen.
    Navigator.pushNamed(context, DetailScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favorites = FavoritesScope.of(context);
    final isFavorite = favorites.contains(product);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetail(context),
        child: Row(
          children: [
            HeroMode(
              enabled: useHero,
              child: Hero(
                tag: product.id,
                child: Image.asset(
                  product.imagePath,
                  width: 120,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.category} · ${product.date}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
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
            ),
            IconButton(
              tooltip: isFavorite ? 'Remove from favorites' : 'Save',
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
              color: theme.colorScheme.primary,
              onPressed: () => favorites.toggle(product),
            ),
          ],
        ),
      ),
    );
  }
}
