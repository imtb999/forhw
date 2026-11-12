import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_image.dart';
import '../widgets/rating_badge.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

enum FeedState { loading, success, error }

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, this.repository});
  final ProductRepository? repository;
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final ProductRepository _repository;
  FeedState _state = FeedState.loading;
  List<Product> _products = [];
  String _error = '';

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ProductRepository();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = FeedState.loading);
    try {
      final products = await _repository.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _state = FeedState.success;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _state = FeedState.error;
      });
    }
  }

  @override
  void dispose() {
    if (widget.repository == null) _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Cloud Product Explorer'),
      actions: [
        CartBadgeButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
        ),
      ],
    ),
    body: switch (_state) {
      FeedState.loading => const Center(child: CircularProgressIndicator()),
      FeedState.error => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 72),
              const SizedBox(height: 16),
              Text(
                'Unable to load products',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(_error, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry Connection'),
              ),
            ],
          ),
        ),
      ),
      FeedState.success => RefreshIndicator(
        onRefresh: _load,
        child: _products.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 160),
                  Center(child: Text('No products yet. Pull down to refresh.')),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: _products.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Hero(
                              tag: 'product_image_${product.id}',
                              child: Container(
                                width: 76,
                                height: 88,
                                padding: const EdgeInsets.all(6),
                                color: Colors.white,
                                child: ProductImage(product: product),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    product.formattedPrice,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      RatingBadge(rating: product.rating),
                                      Text('(${product.reviewCount} reviews)'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    },
  );
}
