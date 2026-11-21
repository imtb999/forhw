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

  String get formattedPrice => formatPrice(price);

  // 54990.0 -> "54 990 ₸"
  static String formatPrice(double amount) {
    final digits = amount.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return '$buffer ₸';
  }
}
