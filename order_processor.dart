// Task: Safe E-Commerce Order Processor
// Named parameters + sound null safety (?, ??)

const double defaultDeliveryFee = 500.0;
const String validPromo = 'SAVE10';
const double discountRate = 0.10;

double processOrder({
  required String orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  // 1. Promo code: applied only on exact match
  final bool promoApplied = promoCode == validPromo;
  final double discount = promoApplied ? itemPrice * discountRate : 0.0;
  final double priceAfterDiscount = itemPrice - discount;

  // 2. Delivery fee: null defaults to 500.0 ₸ via ??
  final double fee = deliveryFee ?? defaultDeliveryFee;

  // 3. Final total
  final double total = priceAfterDiscount + fee;

  // 4. Order summary
  print('===== ORDER $orderId =====');
  print('Item price:      ${itemPrice.toStringAsFixed(2)} ₸');
  if (promoApplied) {
    print('Promo code:      $promoCode (-10%)');
    print('Discount:        -${discount.toStringAsFixed(2)} ₸');
  } else if (promoCode == null) {
    print('Promo code:      not provided');
  } else {
    print('Promo code:      $promoCode (invalid, no discount)');
  }
  print('Delivery fee:    ${fee.toStringAsFixed(2)} ₸'
      '${deliveryFee == null ? " (default)" : ""}');
  print('-------------------------');
  print('TOTAL:           ${total.toStringAsFixed(2)} ₸');
  print('');

  return total;
}

void main() {
  // Valid promo + custom delivery
  processOrder(
    orderId: 'A-1001',
    itemPrice: 12000.0,
    promoCode: 'SAVE10',
    deliveryFee: 800.0,
  );

  // Valid promo, delivery fee omitted -> 500.0 by default
  processOrder(
    orderId: 'A-1002',
    itemPrice: 12000.0,
    promoCode: 'SAVE10',
  );

  // No promo at all, explicit null delivery -> 500.0
  processOrder(
    orderId: 'A-1003',
    itemPrice: 7500.0,
    deliveryFee: null,
  );

  // Invalid promo code -> no discount
  processOrder(
    orderId: 'A-1004',
    itemPrice: 3200.0,
    promoCode: 'SAVE50',
  );

  // Free delivery (0.0 is a real value, ?? does not replace it)
  final double total = processOrder(
    orderId: 'A-1005',
    itemPrice: 25000.0,
    promoCode: 'SAVE10',
    deliveryFee: 0.0,
  );

  print('Returned total for A-1005: ${total.toStringAsFixed(2)} ₸');
}
