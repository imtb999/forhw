// LW3: Library Book Management System

class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book({
    required this.title,
    required this.author,
    required this.price,
    this.isBorrowed = false,
  });
}

class Library {
  final List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) => !book.isBorrowed).toList();
  }

  double getTotalValue() {
    return _books.fold<double>(0.0, (total, book) => total + book.price);
  }
}

void runLibraryDemo() {
  final library = Library();

  library.addBook(
    Book(title: 'The Hobbit', author: 'J. R. R. Tolkien', price: 15.50),
  );
  library.addBook(
    Book(
      title: '1984',
      author: 'George Orwell',
      price: 12.00,
      isBorrowed: true,
    ),
  );
  library.addBook(
    Book(title: 'Pride and Prejudice', author: 'Jane Austen', price: 10.00),
  );
  library.addBook(
    Book(
      title: 'The Little Prince',
      author: 'Antoine de Saint-Exupery',
      price: 8.50,
    ),
  );

  print('Available books:');
  for (final book in library.getAvailableBooks()) {
    print(
      '${book.title} by ${book.author} - '
      '\$${book.price.toStringAsFixed(2)}',
    );
  }

  print(
    '\nTotal collection value: '
    '\$${library.getTotalValue().toStringAsFixed(2)}',
  );
}

// Homework 3: Digital E-Commerce Media Store

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

void runMediaStoreDemo() {
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

void main() {
  print('=== LW3: Library Book Management System ===');
  runLibraryDemo();
  print('\n=== Homework 3: Digital E-Commerce Media Store ===');
  runMediaStoreDemo();
}
