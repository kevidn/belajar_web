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
  factory Book.fromMap(Map<String, dynamic> map) {
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
      id: map['id'] ?? '',
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
      'id': id, // Tambahkan id ke toMap
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