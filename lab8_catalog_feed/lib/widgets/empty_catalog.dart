import 'package:flutter/material.dart';

class EmptyCatalog extends StatelessWidget {
  const EmptyCatalog({super.key, required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 96,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('Catalog is Empty', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'All sneakers were removed.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
