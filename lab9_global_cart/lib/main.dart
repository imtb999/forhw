import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(
    // The provider is ABOVE MaterialApp, so every route (Catalog and Cart)
    // reads the same CartProvider instance.
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const SneakerApp(),
    ),
  );
}

class SneakerApp extends StatelessWidget {
  const SneakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFE53935);
    return MaterialApp(
      title: 'Sneaker Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      home: const CatalogScreen(),
    );
  }
}
