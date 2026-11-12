class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'];
    final rating = rawRating is Map ? rawRating : const {};
    return Product(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      title: json['title'] is String
          ? json['title'] as String
          : 'Untitled product',
      price: json['price'] is num ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] is String
          ? json['description'] as String
          : 'No description available.',
      category: json['category'] is String
          ? json['category'] as String
          : 'Other',
      imageUrl: json['image'] is String ? json['image'] as String : '',
      rating: rating['rate'] is num ? (rating['rate'] as num).toDouble() : 0.0,
      reviewCount: rating['count'] is num
          ? (rating['count'] as num).toInt()
          : 0,
    );
  }

  // Fake Store prices are in USD, so keep the API currency.
  String get formattedPrice => formatPrice(price);
  static String formatPrice(double amount) => '\$${amount.toStringAsFixed(2)}';
}
