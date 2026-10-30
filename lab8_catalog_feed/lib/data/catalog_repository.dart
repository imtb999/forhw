import 'dart:math';

import '../models/product.dart';

class _Model {
  const _Model(this.title, this.category, this.imagePath);

  final String title;
  final String category;
  final String imagePath;
}

// Seed data plus a fake "server" that returns new arrivals.
class CatalogRepository {
  static const seedCount = 24;

  static const _models = [
    _Model('Nike Air Everyday', 'Lifestyle', 'assets/images/sneaker.jpg'),
    _Model('Cloud Runner', 'Running', 'assets/images/sneaker_light.jpg'),
    _Model('Ocean Flyknit', 'Running', 'assets/images/sneaker_blue.jpg'),
    _Model('Forest Trail', 'Outdoor', 'assets/images/sneaker_green.jpg'),
    _Model(
      'Street Classic',
      'Lifestyle',
      'assets/images/sneaker_light_blue.jpg',
    ),
    _Model('Tempo Racer', 'Running', 'assets/images/sneaker_orange.jpg'),
    _Model('Canyon Hiker', 'Outdoor', 'assets/images/sneaker_teal.jpg'),
    _Model('Night Sprint', 'Running', 'assets/images/sneaker_purple.jpg'),
  ];

  static const _editions = ['', ' 2', ' Pro', ' Lite', ' SE', ' Max'];

  final _random = Random();
  int _nextId = 1;

  // Same 24 sneakers every time, so "Reset Catalog" restores the start state.
  List<Product> seed() {
    final seeded = Random(8);
    return List.generate(seedCount, (i) {
      final model = _models[i % _models.length];
      final edition = _editions[(i ~/ _models.length) % _editions.length];
      return _build(model, edition, seeded);
    });
  }

  // Simulated network request for Pull-to-Refresh.
  Future<Product> fetchNewArrival() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final model = _models[_random.nextInt(_models.length)];
    return _build(model, ' New Drop', _random);
  }

  Product _build(_Model model, String edition, Random random) {
    return Product(
      id: _nextId++,
      title: '${model.title}$edition',
      category: model.category,
      imagePath: model.imagePath,
      price: 39990 + random.nextInt(40) * 1000,
      rating: 3.5 + random.nextInt(16) / 10,
    );
  }
}
