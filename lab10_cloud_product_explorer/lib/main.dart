import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => CartProvider(),
    child: const CloudProductApp(),
  ),
);

class CloudProductApp extends StatelessWidget {
  const CloudProductApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cloud Product Explorer',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: const Color(0xFFE53935),
      useMaterial3: true,
    ),
    home: const CatalogScreen(),
  );
}
