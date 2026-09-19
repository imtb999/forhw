abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem({required this.id, required this.title, required this.price});

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Downloading "$title"...');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook({
    required String id,
    required String title,
    required double price,
    required this.durationHours,
    required this.narrator,
  }) : super(id: id, title: title, price: price);

  @override
  String getDetails() {
    return 'Audiobook [$id]: $title | Narrator: $narrator | '
        'Duration: $durationHours hours | \$${price.toStringAsFixed(2)}';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook({
    required String id,
    required String title,
    required double price,
    required this.fileSizeMB,
    required this.author,
  }) : super(id: id, title: title, price: price);

  @override
  String getDetails() {
    return 'EBook [$id]: $title | Author: $author | '
        'File size: $fileSizeMB MB | \$${price.toStringAsFixed(2)}';
  }
}

class ShoppingCart {
  final List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    final subtotal = _items.fold<double>(
      0.0,
      (total, item) => total + item.price,
    );
    return subtotal * (1 + taxRate);
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) => item.price <= maxPrice).toList();
  }

  void printReceipt() {
    print('=== Digital Media Store Receipt ===');
    for (final item in _items) {
      print(item.getDetails());
      if (item is Downloadable) {
        (item as Downloadable).download(item.title);
      }
    }
    print(
      'Total including 12% tax: '
      '\$${calculateTotalWithTax().toStringAsFixed(2)}',
    );
  }
}

void main() {
  final cart = ShoppingCart();

  cart.addItem(
    Audiobook(
      id: 'A001',
      title: 'A Journey Through Space',
      price: 20.00,
      durationHours: 6.5,
      narrator: 'Alex Morgan',
    ),
  );
  cart.addItem(
    EBook(
      id: 'E001',
      title: 'Learning Dart',
      price: 15.00,
      fileSizeMB: 4.2,
      author: 'Sam Taylor',
    ),
  );
  cart.addItem(
    EBook(
      id: 'E002',
      title: 'Short Stories',
      price: 10.00,
      fileSizeMB: 2.5,
      author: 'Jamie Lee',
    ),
  );

  cart.printReceipt();

  print('\nItems priced at \$15.00 or less:');
  for (final item in cart.filterByMaxPrice(15.00)) {
    print(item.getDetails());
  }

  print(
    '\nTotal with a custom 5% tax: '
    '\$${cart.calculateTotalWithTax(taxRate: 0.05).toStringAsFixed(2)}',
  );
}
