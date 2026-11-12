import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    if (product.imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported_outlined, size: 40);
    }
    return Image.network(
      product.imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          const Center(child: Icon(Icons.broken_image_outlined, size: 40)),
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
    );
  }
}
