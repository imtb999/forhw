import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/catalog_product_card.dart';
import 'cart_screen.dart';

// Screen 1: 6 sneakers with Add to Cart toggles and a live cart badge.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sneaker Store'),
        actions: [
          CartBadgeButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: catalog.length,
        separatorBuilder: (_, _) => const SizedBox(height: 4),
        itemBuilder: (_, i) => CatalogProductCard(product: catalog[i]),
      ),
    );
  }
}
