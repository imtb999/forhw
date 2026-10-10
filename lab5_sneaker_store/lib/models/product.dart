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
    this.activities = const [],
  });

  final String name;
  final int price;
  final double rating;
  final int reviewCount;
  final String imagePath;
  final String description;
  final List<String> categories;
  final List<int> sizes;
  final List<String> activities;
}

// Demo data. Later this product can come from an API.
const sampleProduct = Product(
  name: 'Nike Air Everyday',
  activities: ['Campus', 'Walk'],
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

const demoProducts = [
  sampleProduct,
  Product(
    name: 'Cloud Runner',
    activities: ['Workout'],
    price: 62990,
    rating: 4.7,
    reviewCount: 86,
    imagePath: 'assets/images/sneaker_light.jpg',
    description:
        'An easy everyday pair with a fresh, light look. '
        'Choose your fit and bring a little more comfort to your daily routine.',
    categories: ['Sneakers', 'Running', 'Unisex'],
    sizes: [39, 40, 41, 42, 43, 44],
  ),
  Product(
    name: 'Campus Basic',
    price: 29990,
    rating: 4.3,
    reviewCount: 42,
    imagePath: 'assets/images/sneaker_light.jpg',
    description: 'A budget-friendly everyday option in our demo collection.',
    categories: ['Sneakers', 'Lifestyle', 'Unisex'],
    sizes: [38, 39, 40, 41, 42, 43],
    activities: ['Campus'],
  ),
  Product(
    name: 'City Walk',
    price: 39990,
    rating: 4.6,
    reviewCount: 58,
    imagePath: 'assets/images/sneaker_light.jpg',
    description: 'An everyday walking option in our demo collection.',
    categories: ['Sneakers', 'Lifestyle', 'Unisex'],
    sizes: [39, 40, 41, 42, 43, 44],
    activities: ['Walk'],
  ),
  Product(
    name: 'Training Start',
    price: 44990,
    rating: 4.5,
    reviewCount: 35,
    imagePath: 'assets/images/sneaker.jpg',
    description: 'An entry-level training option in our demo collection.',
    categories: ['Sneakers', 'Running', 'Unisex'],
    sizes: [38, 39, 40, 41, 42, 43, 44],
    activities: ['Workout'],
  ),
];
