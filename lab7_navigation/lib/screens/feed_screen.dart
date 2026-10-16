import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_tile.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: demoProducts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) =>
            ProductTile(product: demoProducts[index]),
      ),
    );
  }
}
