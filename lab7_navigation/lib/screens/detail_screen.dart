import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/favorites.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.product});

  static const routeName = '/detail';

  // The complete object received from the Feed through route arguments.
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favorites = FavoritesScope.of(context);
    final isFavorite = favorites.contains(product);

    return Scaffold(
      appBar: AppBar(
        // AppBar back icon: Navigator.pop returns to the previous screen.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product.title),
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove from favorites' : 'Save',
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => favorites.toggle(product),
          ),
        ],
      ),
      body: ListView(
        children: [
          Hero(
            tag: product.id,
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Image.asset(product.imagePath, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Chip(label: Text(product.category)),
                    const Spacer(),
                    Text(product.date, style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.formattedPrice,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Description', style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(product.description, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 24),
                FilledButton.tonalIcon(
                  onPressed: () => favorites.toggle(product),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    isFavorite ? 'Remove from favorites' : 'Add to favorites',
                  ),
                ),
                const SizedBox(height: 12),
                // In-body back button: same Navigator.pop, app state is kept.
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to list'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
