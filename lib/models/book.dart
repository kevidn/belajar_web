// Lokasi: lib/models/book.dart
import 'package:flutter/foundation.dart'; // Diperlukan untuk @required

// Base class untuk implementasi inheritance
abstract class Publication {
  final String id;
  final String title;
  final String author;
  final DateTime publishedDate;
  final String language;

  // Constructor untuk base class
  Publication({
    required this.id,
    required this.title,
    required this.author,
    required this.publishedDate,
    this.language = 'Indonesia',
  });

  // Method abstract untuk polymorphism
  String getDisplayInfo();

  // Method umum untuk semua publikasi
  String getFormattedDate() {
    return '${publishedDate.day}/${publishedDate.month}/${publishedDate.year}';
  }
}

// Class Book yang mewarisi Publication (inheritance)
class Book extends Publication {
  // Private fields untuk encapsulation
  final String _description;
  final String _category;
  final double _rating;
  final String _imageUrl;
  final int _pages;
  final String _isbn;
  final bool _isAvailable;
  final List<String> _tags;
  final String _ownerId;
  final double _price;

  // Constructor utama disederhanakan
  Book({
    required String id,
    required String title,
    required String author,
    String description = '',
    String category = 'Lainnya',
    double rating = 0.0,
    String imageUrl = '',
    DateTime? publishedDate,
    int pages = 0,
    String isbn = '',
    bool isAvailable = true,
    String language = 'Indonesia',
    List<String> tags = const [],
    String ownerId = '',
    double price = 0.0,
  })  : _description = description,
        _category = category,
        _rating = rating,
        _imageUrl = imageUrl,
        _pages = pages,
        _isbn = isbn,
        _isAvailable = isAvailable,
        _tags = tags,
        _ownerId = ownerId,
        _price = price,
        super(
          id: id,
          title: title,
          author: author,
          publishedDate: publishedDate ?? DateTime.now(),
          language: language,
        );

  // Getters untuk encapsulation
  String get description => _description;
  String get category => _category;
  double get rating => _rating;
  String get imageUrl => _imageUrl;
  int get pages => _pages;
  String get isbn => _isbn;
  bool get isAvailable => _isAvailable;
  List<String> get tags => List.unmodifiable(_tags); // Immutable list
  String get ownerId => _ownerId;
  double get price => _price;

  // Implementasi method abstract dari Publication (polymorphism)
  @override
  String getDisplayInfo() {
    return '$title oleh $author ($pages halaman)';
  }

  // Method khusus untuk Book
  String getBookDetails() {
    return 'Buku $title, kategori $_category, rating: $_rating/5.0';
  }

  // Membuat objek dari Map (untuk data dummy atau penyimpanan lokal)
  factory Book.fromMap(Map<String, dynamic> map, String id) {
    // Parsing tanggal yang lebih aman
    DateTime parsedDate;
    final dateData = map['publishedDate'];
    if (dateData is DateTime) {
      parsedDate = dateData;
    } else if (dateData is String) {
      parsedDate = DateTime.tryParse(dateData) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return Book(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Lainnya',
      rating: (map['rating'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      publishedDate: parsedDate,
      pages: map['pages'] ?? 0,
      isbn: map['isbn'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      language: map['language'] ?? 'Indonesia',
      tags: List<String>.from(map['tags'] ?? []),
      ownerId: map['ownerId'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  // Mengubah objek menjadi Map (untuk penyimpanan lokal)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': _description,
      'category': _category,
      'rating': _rating,
      'imageUrl': _imageUrl,
      'publishedDate': publishedDate.toIso8601String(),
      'pages': _pages,
      'isbn': _isbn,
      'isAvailable': _isAvailable,
      'language': language,
      'tags': _tags,
      'ownerId': _ownerId,
      'price': _price,
    };
  }

  // Method copyWith untuk kemudahan update objek
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? category,
    double? rating,
    String? imageUrl,
    DateTime? publishedDate,
    int? pages,
    String? isbn,
    bool? isAvailable,
    String? language,
    List<String>? tags,
    String? ownerId,
    double? price,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? _description,
      category: category ?? _category,
      rating: rating ?? _rating,
      imageUrl: imageUrl ?? _imageUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      pages: pages ?? _pages,
      isbn: isbn ?? _isbn,
      isAvailable: isAvailable ?? _isAvailable,
      language: language ?? this.language,
      tags: tags ?? _tags,
      ownerId: ownerId ?? _ownerId,
      price: price ?? _price,
    );
  }
} // <-- PENUTUP CLASS BOOK SEHARUSNYA DI SINI

// Class turunan lain dari Publication untuk menunjukkan polymorphism
class Magazine extends Publication {
  final String _publisher;
  final String _issueNumber;
  final List<String> _topics;

  Magazine({
    required String id,
    required String title,
    required String author,
    required DateTime publishedDate,
    String language = 'Indonesia',
    String publisher = '',
    String issueNumber = '',
    List<String> topics = const [],
  })  : _publisher = publisher,
        _issueNumber = issueNumber,
        _topics = topics,
        super(
          id: id,
          title: title,
          author: author,
          publishedDate: publishedDate,
          language: language,
        );

  // Getters untuk encapsulation
  String get publisher => _publisher;
  String get issueNumber => _issueNumber;
  List<String> get topics => List.unmodifiable(_topics);

  // Implementasi method abstract dari Publication (polymorphism)
  @override
  String getDisplayInfo() {
    return 'Majalah $title edisi $_issueNumber oleh $_publisher';
  }

  // Method khusus untuk Magazine
  String getMagazineDetails() {
    return 'Majalah $title, edisi $_issueNumber, penerbit $_publisher';
  }
}

// Data dummy untuk buku
List<Book> getDummyBooks() {
  return [
    Book(
      id: '1',
      title: 'Flutter untuk Pemula',
      author: 'Budi Santoso',
      description:
          'Panduan lengkap belajar Flutter dari dasar hingga mahir. Cocok untuk pemula yang ingin memulai karir sebagai Flutter developer.',
      category: 'Teknologi',
      rating: 4.5,
      imageUrl: 'https://picsum.photos/id/24/200/300',
      publishedDate: DateTime(2022, 5, 15),
      pages: 350,
      isbn: '978-602-8123-45-6',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Flutter', 'Mobile', 'Programming'],
      ownerId: 'user1',
      price: 150000,
    ),
    Book(
      id: '2',
      title: 'Algoritma dan Struktur Data',
      author: 'Dewi Lestari',
      description:
          'Buku ini membahas konsep dasar algoritma dan struktur data yang penting untuk dipahami oleh programmer.',
      category: 'Pendidikan',
      rating: 4.2,
      imageUrl: 'https://picsum.photos/id/42/200/300',
      publishedDate: DateTime(2021, 8, 10),
      pages: 280,
      isbn: '978-602-5678-90-1',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Algoritma', 'Struktur Data', 'Programming'],
      ownerId: 'user2',
      price: 120000,
    ),
    Book(
      id: '3',
      title: 'Sejarah Indonesia Modern',
      author: 'Ahmad Dahlan',
      description:
          'Mengupas sejarah Indonesia dari masa kemerdekaan hingga era reformasi dengan detail dan fakta-fakta menarik.',
      category: 'Sejarah',
      rating: 4.7,
      imageUrl: 'https://picsum.photos/id/76/200/300',
      publishedDate: DateTime(2020, 3, 22),
      pages: 420,
      isbn: '978-602-7890-12-3',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Sejarah', 'Indonesia', 'Politik'],
      ownerId: 'user1',
      price: 180000,
    ),
    Book(
      id: '4',
      title: 'Bisnis Digital',
      author: 'Siti Nurhaliza',
      description:
          'Panduan praktis memulai dan mengembangkan bisnis di era digital dengan strategi pemasaran modern.',
      category: 'Bisnis',
      rating: 4.0,
      imageUrl: 'https://picsum.photos/id/180/200/300',
      publishedDate: DateTime(2023, 1, 5),
      pages: 250,
      isbn: '978-602-3456-78-9',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Bisnis', 'Digital Marketing', 'Startup'],
      ownerId: 'user3',
      price: 135000,
    ),
    Book(
      id: '5',
      title: 'Petualangan Anak Laut',
      author: 'Rini Wulandari',
      description:
          'Kisah petualangan seorang anak nelayan yang menemukan harta karun di dasar laut.',
      category: 'Anak-anak',
      rating: 4.8,
      imageUrl: 'https://picsum.photos/id/106/200/300',
      publishedDate: DateTime(2022, 11, 30),
      pages: 120,
      isbn: '978-602-9012-34-5',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Anak-anak', 'Petualangan', 'Laut'],
      ownerId: 'user2',
      price: 85000,
    ),
    // Buku tambahan
    Book(
      id: '6',
      title: 'Resep Masakan Nusantara',
      author: 'Farah Diba',
      description:
          'Kumpulan resep masakan tradisional dari berbagai daerah di Indonesia dengan bahan-bahan yang mudah didapat.',
      category: 'Kuliner',
      rating: 4.9,
      imageUrl: 'https://picsum.photos/id/292/200/300',
      publishedDate: DateTime(2023, 4, 18),
      pages: 210,
      isbn: '978-602-1234-56-7',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Kuliner', 'Resep', 'Tradisional'],
      ownerId: 'user1',
      price: 125000,
    ),
    Book(
      id: '7',
      title: 'Dasar-Dasar Fotografi',
      author: 'Gunawan Wibisono',
      description:
          'Panduan lengkap untuk memahami teknik fotografi dari dasar hingga tingkat lanjut dengan contoh-contoh praktis.',
      category: 'Seni',
      rating: 4.3,
      imageUrl: 'https://picsum.photos/id/250/200/300',
      publishedDate: DateTime(2021, 10, 5),
      pages: 180,
      isbn: '978-602-7654-32-1',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Fotografi', 'Seni', 'Visual'],
      ownerId: 'user3',
      price: 140000,
    ),
    Book(
      id: '8',
      title: 'Psikologi Kepribadian',
      author: 'Dr. Ratna Sari',
      description:
          'Membahas berbagai teori psikologi kepribadian dan aplikasinya dalam kehidupan sehari-hari.',
      category: 'Psikologi',
      rating: 4.6,
      imageUrl: 'https://picsum.photos/id/342/200/300',
      publishedDate: DateTime(2022, 7, 12),
      pages: 320,
      isbn: '978-602-8765-43-2',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Psikologi', 'Kepribadian', 'Pengembangan Diri'],
      ownerId: 'user2',
      price: 165000,
    ),
    Book(
      id: '9',
      title: 'Kriptografi Modern',
      author: 'Prof. Bambang Suprapto',
      description:
          'Penjelasan mendalam tentang teknik-teknik kriptografi modern dan implementasinya dalam keamanan informasi.',
      category: 'Teknologi',
      rating: 4.4,
      imageUrl: 'https://picsum.photos/id/48/200/300',
      publishedDate: DateTime(2023, 2, 28),
      pages: 380,
      isbn: '978-602-9876-54-3',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Kriptografi', 'Keamanan', 'Teknologi'],
      ownerId: 'user1',
      price: 190000,
    ),
    Book(
      id: '10',
      title: 'Yoga untuk Pemula',
      author: 'Maya Wijaya',
      description:
          'Panduan praktis untuk memulai latihan yoga dengan gerakan-gerakan dasar yang mudah diikuti.',
      category: 'Kesehatan',
      rating: 4.7,
      imageUrl: 'https://picsum.photos/id/177/200/300',
      publishedDate: DateTime(2022, 9, 8),
      pages: 150,
      isbn: '978-602-5432-10-9',
      isAvailable: true,
      language: 'Indonesia',
      tags: ['Yoga', 'Kesehatan', 'Olahraga'],
      ownerId: 'user3',
      price: 110000,
    ),
  ];
}

// Method to get all available books
List<Book> getAvailableBooks() {
  return getDummyBooks().where((book) => book.isAvailable).toList();
}

// Method to get books by category
List<Book> getBooksByCategory(String category) {
  return getDummyBooks()
      .where((book) => book.category.toLowerCase() == category.toLowerCase())
      .toList();
}

// Method to get books by author
List<Book> getBooksByAuthor(String author) {
  return getDummyBooks()
      .where((book) => book.author.toLowerCase().contains(author.toLowerCase()))
      .toList();
}

// Method to search books by title
List<Book> searchBooksByTitle(String query) {
  return getDummyBooks()
      .where((book) => book.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

// Method to get books by price range
List<Book> getBooksByPriceRange(double minPrice, double maxPrice) {
  return getDummyBooks()
      .where((book) => book.price >= minPrice && book.price <= maxPrice)
      .toList();
}

// Method to get books by rating threshold
List<Book> getBooksByMinRating(double minRating) {
  return getDummyBooks()
      .where((book) => book.rating >= minRating)
      .toList();
}