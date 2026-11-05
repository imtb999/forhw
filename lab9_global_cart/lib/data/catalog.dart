import '../models/product.dart';

// The 6 sneakers shown on the Catalog screen.
const catalog = <Product>[
  Product(
    id: 1,
    title: 'Nike Air Everyday',
    category: 'Lifestyle',
    imagePath: 'assets/images/sneaker.jpg',
    price: 54990,
    rating: 4.8,
  ),
  Product(
    id: 2,
    title: 'Cloud Runner',
    category: 'Running',
    imagePath: 'assets/images/sneaker_light.jpg',
    price: 47990,
    rating: 4.5,
  ),
  Product(
    id: 3,
    title: 'Ocean Flyknit',
    category: 'Running',
    imagePath: 'assets/images/sneaker_blue.jpg',
    price: 62990,
    rating: 4.7,
  ),
  Product(
    id: 4,
    title: 'Forest Trail',
    category: 'Outdoor',
    imagePath: 'assets/images/sneaker_green.jpg',
    price: 69990,
    rating: 4.4,
  ),
  Product(
    id: 5,
    title: 'Tempo Racer',
    category: 'Running',
    imagePath: 'assets/images/sneaker_orange.jpg',
    price: 58990,
    rating: 4.6,
  ),
  Product(
    id: 6,
    title: 'Night Sprint',
    category: 'Running',
    imagePath: 'assets/images/sneaker_purple.jpg',
    price: 44990,
    rating: 4.3,
  ),
];
