import 'package:flutter/material.dart';

import '../state/favorites.dart';
import '../widgets/product_tile.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final items = FavoritesScope.of(context).items;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite_border, size: 64),
                    const SizedBox(height: 12),
                    const Text(
                      'No saved items yet.\nTap the heart on any sneaker to save it.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: onBrowse,
                      child: const Text('Browse feed'),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) =>
                  ProductTile(product: items[index], useHero: false),
            ),
    );
  }
}
