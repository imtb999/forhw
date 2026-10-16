import 'package:flutter/material.dart';

import 'models/product.dart';
import 'screens/detail_screen.dart';
import 'screens/root_screen.dart';
import 'state/favorites.dart';

void main() {
  runApp(const SneakerApp());
}

class SneakerApp extends StatefulWidget {
  const SneakerApp({super.key});

  @override
  State<SneakerApp> createState() => _SneakerAppState();
}

class _SneakerAppState extends State<SneakerApp> {
  final _favorites = FavoritesController();
  final _themeMode = ValueNotifier(ThemeMode.light);

  @override
  void dispose() {
    _favorites.dispose();
    _themeMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFE53935);
    return FavoritesScope(
      controller: _favorites,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: _themeMode,
        builder: (context, mode, _) => MaterialApp(
          title: 'Sneaker Store',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
          darkTheme: ThemeData(
            colorSchemeSeed: seed,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: RootScreen(themeMode: _themeMode),
          // Named route that receives the whole Product as its argument.
          onGenerateRoute: (settings) {
            if (settings.name == DetailScreen.routeName) {
              final product = settings.arguments as Product;
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => DetailScreen(product: product),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
