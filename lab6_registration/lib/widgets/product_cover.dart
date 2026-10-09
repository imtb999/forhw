import 'package:flutter/material.dart';

class ProductCover extends StatelessWidget {
  const ProductCover({
    super.key,
    required this.imagePath,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  final String imagePath;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Chip(label: Text('NEW ARRIVAL')),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: IconButton.filledTonal(
              tooltip: isFavorite ? 'Remove bookmark' : 'Save product',
              onPressed: onFavoritePressed,
              icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border),
            ),
          ),
        ],
      ),
    );
  }
}
