import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_cubit.dart';
import '../cart/cart_bloc.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../widgets/cart_badge_button.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static const route = '/catalog';

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
    context.read<CartBloc>().add(const ClearCartEvent());
    Navigator.of(context).pushReplacementNamed(LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final name = auth is AuthSuccess ? auth.username : 'Guest';
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Catalog'),
            Text('Hi, $name', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          CartBadgeButton(
            onPressed: () => Navigator.of(context).pushNamed(CartScreen.route),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: catalog.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _ProductCard(product: catalog[index]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(product.imagePath),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
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
            const SizedBox(width: 8),
            FilledButton.icon(
              key: Key('add_${product.id}'),
              onPressed: () {
                context.read<CartBloc>().add(AddProductEvent(product));
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${product.title} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
