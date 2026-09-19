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

void main() {
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
