import 'package:flutter/material.dart';

import '../data/catalog_repository.dart';
import '../models/product.dart';
import '../widgets/delete_background.dart';
import '../widgets/empty_catalog.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';

enum ViewMode { list, grid }

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _repository = CatalogRepository();
  late List<Product> _products = _repository.seed();
  var _viewMode = ViewMode.list;

  void _setViewMode(ViewMode mode) => setState(() => _viewMode = mode);

  // Pull-to-Refresh: 1.5 s fake request, then the new item goes to index 0.
  Future<void> _onRefresh() async {
    final product = await _repository.fetchNewArrival();
    if (!mounted) return;
    setState(() => _products.insert(0, product));
  }

  // Swipe-to-Delete: remember the index so UNDO can put the item back there.
  void _remove(Product product) {
    final index = _products.indexOf(product);
    setState(() => _products.removeAt(index));

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('${product.title} removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => _undo(product, index),
        ),
      ),
    );
  }

  void _undo(Product product, int index) {
    // clamp: other items may have been deleted after this one.
    setState(() => _products.insert(index.clamp(0, _products.length), product));
  }

  void _reset() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _products = _repository.seed());
  }

  Widget _dismissible(Product product, Widget child, {BorderRadius? radius}) {
    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: DeleteBackground(borderRadius: radius ?? BorderRadius.zero),
      onDismissed: (_) => _remove(product),
      child: child,
    );
  }

  Widget _buildList() {
    return ListView.separated(
      // Pull-to-Refresh must work even when the list is shorter than the screen.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _products.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 0.5, indent: 84),
      itemBuilder: (context, index) {
        final product = _products[index];
        return _dismissible(product, ProductListTile(product: product));
      },
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return _dismissible(
          product,
          ProductGridCard(product: product),
          radius: BorderRadius.circular(16),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isList = _viewMode == ViewMode.list;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sneaker Catalog (${_products.length})'),
        actions: [
          IconButton(
            tooltip: isList ? 'Show grid' : 'Show list',
            icon: Icon(isList ? Icons.grid_view_rounded : Icons.view_list),
            onPressed: () =>
                _setViewMode(isList ? ViewMode.grid : ViewMode.list),
          ),
        ],
      ),
      body: _products.isEmpty
          ? EmptyCatalog(onReset: _reset)
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: isList ? _buildList() : _buildGrid(),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _viewMode.index,
        onDestinationSelected: (i) => _setViewMode(ViewMode.values[i]),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list),
            label: 'List Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Grid Catalog',
          ),
        ],
      ),
    );
  }
}
