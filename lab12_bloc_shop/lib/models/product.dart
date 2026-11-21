import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.price,
  });

  final int id;
  final String title;
  final String category;
  final String imagePath;
  final int price;

  String get formattedPrice => formatTenge(price);

  // 54990 -> "54 990 ₸"
  static String formatTenge(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return '$buffer ₸';
  }

  @override
  List<Object?> get props => [id, title, category, imagePath, price];
}
