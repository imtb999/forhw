import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';
import 'day_match_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final visibleProducts = demoProducts.where((product) {
      return selectedCategory == 'All' ||
          product.categories.contains(selectedCategory);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('SNEAKER / STORE')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FIND YOUR NEXT PAIR',
                    style: TextStyle(letterSpacing: 2, color: Colors.brown),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Everyday starts\nwith a good pair.',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Explore sneakers, pick your size and make them yours.',
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text(
                      'Find my pair for today',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const DayMatchScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All', 'Lifestyle', 'Running'].map((category) {
                      return ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text('${visibleProducts.length} styles to explore'),
                  const SizedBox(height: 12),
                  // Cards have natural height, so larger text can wrap freely.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = constraints.maxWidth >= 600
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth;
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: visibleProducts.map((product) {
                          return SizedBox(
                            width: cardWidth,
                            child: ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) =>
                                        ProductScreen(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('A small collection. A great place to start.'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
