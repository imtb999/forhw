class Product {
  const Product({
    required this.name,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imagePath,
    required this.description,
    required this.categories,
    required this.sizes,
  });

  final String name;
  final int price;
  final double rating;
  final int reviewCount;
  final String imagePath;
  final String description;
  final List<String> categories;
  final List<int> sizes;
}

// Demo data. Later this product can come from an API.
const sampleProduct = Product(
  name: 'Nike Air Everyday',
  price: 54990,
  rating: 4.8,
  reviewCount: 124,
  imagePath: 'assets/images/sneaker.jpg',
  description:
      'A bold red sneaker for your everyday rotation. '
      'A lightweight feel, cushioned steps and a sporty silhouette '
      'take you from your morning walk to a day in the city.',
  categories: ['Sneakers', 'Lifestyle', 'Unisex'],
  sizes: [38, 39, 40, 41, 42, 43, 44, 45],
);
