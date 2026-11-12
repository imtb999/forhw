import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_badge.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _pageController = PageController();
  int _page = 0;
  // The API has one photo. These are three views, not additional product photos.
  static const _scales = [1.0, 1.3, 1.6];
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    final link = 'narxoz://store/product/${widget.product.id}';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Share product',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SelectableText(link),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copy Link'),
                onPressed: () async {
                  try {
                    await Clipboard.setData(ClipboardData(text: link));
                    if (!sheetContext.mounted) return;
                    Navigator.pop(sheetContext);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied')),
                    );
                  } catch (_) {
                    if (!sheetContext.mounted) return;
                    ScaffoldMessenger.of(sheetContext).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not copy. Select the link to copy it manually.',
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final inCart = context.watch<CartProvider>().contains(product);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            tooltip: 'Share',
            onPressed: _share,
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Hero(
            tag: 'product_image_${product.id}',
            flightShuttleBuilder: (_, _, _, _, _) => Material(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ProductImage(product: product),
              ),
            ),
            child: SizedBox(
              height: 300,
              child: Material(
                color: Colors.white,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _scales.length,
                      onPageChanged: (index) => setState(() => _page = index),
                      itemBuilder: (_, index) => ClipRect(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Transform.scale(
                            scale: _scales[index],
                            child: ProductImage(product: product),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            '${_page + 1} / ${_scales.length}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _scales.length,
              (index) => Semantics(
                label: 'View ${index + 1}',
                selected: _page == index,
                button: true,
                child: GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _page == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: _page == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Original • Close-up • Detail',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(label: Text(product.category)),
          ),
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              RatingBadge(rating: product.rating),
              Text('${product.reviewCount} reviews'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            product.formattedPrice,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(product.description),
          const SizedBox(height: 16),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: inCart
                  ? null
                  : () {
                      context.read<CartProvider>().add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart')),
                      );
                    },
              icon: Icon(inCart ? Icons.check : Icons.add_shopping_cart),
              label: Text(inCart ? 'Added to Cart' : 'Add to Cart'),
            ),
          ),
        ),
      ),
    );
  }
}
