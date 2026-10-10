import '../models/product.dart';

// Match only tagged activities within budget; prefer the highest demo rating.
Product? findDayMatch(String activity, int budget) {
  final matches = demoProducts.where((product) {
    return product.activities.contains(activity) && product.price <= budget;
  }).toList();
  matches.sort((a, b) {
    final ratingOrder = b.rating.compareTo(a.rating);
    return ratingOrder != 0 ? ratingOrder : a.price.compareTo(b.price);
  });
  return matches.isEmpty ? null : matches.first;
}
