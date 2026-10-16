class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.date,
  });

  final String id;
  final String title;
  final String description;
  final String imagePath;
  final int price;
  final String category;
  final String date;

  // 54990 -> "54 990 ₸"
  String get formattedPrice {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return '$buffer ₸';
  }
}

// Demo data for the Feed tab. Images are bundled, so the app works offline.
const demoProducts = [
  Product(
    id: 'air-everyday',
    title: 'Nike Air Everyday',
    description:
        'A bold red sneaker for your everyday rotation. A lightweight feel, '
        'cushioned steps and a sporty silhouette take you from your morning '
        'walk to a day in the city.',
    imagePath: 'assets/images/sneaker.jpg',
    price: 54990,
    category: 'Lifestyle',
    date: '12 Oct 2026',
  ),
  Product(
    id: 'cloud-runner',
    title: 'Cloud Runner',
    description:
        'An easy everyday pair with a fresh, light look. Breathable mesh and a '
        'soft midsole bring a little more comfort to your daily routine.',
    imagePath: 'assets/images/sneaker_light.jpg',
    price: 62990,
    category: 'Running',
    date: '10 Oct 2026',
  ),
  Product(
    id: 'ocean-flyknit',
    title: 'Ocean Flyknit',
    description:
        'A deep blue knit upper that hugs your foot like a sock. Built for '
        'long runs and fast tempo days, with a responsive foam sole.',
    imagePath: 'assets/images/sneaker_blue.jpg',
    price: 71490,
    category: 'Running',
    date: '7 Oct 2026',
  ),
  Product(
    id: 'forest-trail',
    title: 'Forest Trail',
    description:
        'A green, grippy pair for weekend hikes and park runs. Reinforced '
        'toe and a durable outsole keep you steady on any surface.',
    imagePath: 'assets/images/sneaker_green.jpg',
    price: 48990,
    category: 'Outdoor',
    date: '3 Oct 2026',
  ),
];
