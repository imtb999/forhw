import 'package:flutter/material.dart';

// Run with: flutter run -t lib/lab5.dart
void main() => runApp(const Lab5App());

class Lab5App extends StatelessWidget {
  const Lab5App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool saved = false;
  int cartCount = 0;

  @override
  Widget build(BuildContext context) {
    final cover = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=900&fit=crop',
              fit: BoxFit.cover,
              semanticLabel: 'Wireless over-ear headphones',
              errorBuilder: (context, error, stackTrace) => const ColoredBox(
                color: Color(0xFFE8EAF6),
                child: Center(child: Icon(Icons.headphones, size: 90)),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  tooltip: saved ? 'Remove bookmark' : 'Bookmark product',
                  onPressed: () => setState(() => saved = !saved),
                  icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wireless Headphones',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 6),
            Expanded(child: Text('4.8 / 5 (128 reviews)')),
          ],
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '29 990 KZT',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Chip(label: Text('In stock')),
          ],
        ),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text('Electronics')),
            Chip(label: Text('Audio')),
            Chip(label: Text('Wireless')),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'About this product',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Comfortable over-ear headphones for music, studying and everyday use. Soft ear cushions, clear sound and up to 30 hours of battery life.',
        ),
        const SizedBox(height: 16),
        Text('Items in cart: $cartCount'),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Product Preview')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: cover),
                        const SizedBox(width: 28),
                        Expanded(child: details),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [cover, const SizedBox(height: 24), details],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                ),
                onPressed: () {
                  setState(() => cartCount++);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
                child: const Text('Add to Cart', textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
