// lib/services/book_service.dart

import 'dart:async';
import '../models/book.dart';
import 'auth_service.dart'; // Diperlukan untuk mendapatkan ID user

class BookService {
  // Singleton pattern
  static final BookService _instance = BookService._internal();
  factory BookService() => _instance;
  BookService._internal();

  // Data dummy untuk buku (PANGGIL LANGSUNG FUNGSINYA)
  final List<Book> _books = getDummyBooks();
  
  // StreamController untuk mengemulasi real-time updates
  final _booksStreamController = StreamController<List<Book>>.broadcast();
  
  final AuthService _authService = AuthService();

  // Mendapatkan semua buku secara real-time
  Stream<List<Book>> getAllBooks() {
    // Kirim data terbaru ke stream
    _booksStreamController.add(_books);
    return _booksStreamController.stream;
  }

  // Mendapatkan buku-buku milik user yang sedang login
  Stream<List<Book>> getUserBooks() {
    final userId = _authService.currentUser?.id;
    if (userId == null) {
      return Stream.value([]); // Kembalikan stream kosong jika user tidak login
    }
    
    final userBooks = _books.where((book) => book.ownerId == userId).toList();
    return Stream.value(userBooks);
  }

  // Menambah buku baru
  Future<void> addBook(Book book) async {
    // Generate ID sederhana
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newBook = book.copyWith(id: id);
    
    _books.add(newBook);
    _booksStreamController.add(_books);
    
    // Simulasi delay jaringan
    return Future.delayed(const Duration(milliseconds: 500));
  }

  // Mengupdate buku yang sudah ada
  Future<void> updateBook(Book book) async {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
      _booksStreamController.add(_books);
    }
    
    // Simulasi delay jaringan
    return Future.delayed(const Duration(milliseconds: 500));
  }

  // Menghapus buku
  Future<void> deleteBook(String id) async {
    _books.removeWhere((book) => book.id == id);
    _booksStreamController.add(_books);
    
    // Simulasi delay jaringan
    return Future.delayed(const Duration(milliseconds: 500));
  }

  // --- Fungsi Tambahan ---

  // Mencari buku
  Stream<List<Book>> searchBooks(String query) {
    if (query.isEmpty) return getAllBooks();
    
    final results = _books.where((book) => 
      book.title.toLowerCase().contains(query.toLowerCase()) ||
      book.author.toLowerCase().contains(query.toLowerCase())
    ).toList();
    
    return Stream.value(results);
  }
  
  // Mendapatkan semua kategori
  List<String> getAllCategories() {
    // Ekstrak kategori unik dari data buku
    final categories = _books.map((book) => book.category).toSet().toList();
    categories.sort();
    return ['Semua', ...categories];
  }
  
  // Mendapatkan buku berdasarkan kategori
  Stream<List<Book>> getBooksByCategory(String category) {
    if (category == 'Semua') {
      return getAllBooks();
    }
    
    final filteredBooks = _books.where((book) => book.category == category).toList();
    return Stream.value(filteredBooks);
  }
  
  // Mengurutkan buku berdasarkan opsi yang dipilih
  List<Book> sortBooks(List<Book> books, String sortOption) {
    switch (sortOption) {
      case 'Judul A-Z':
        books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Rating Tertinggi':
        books.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Terbaru':
        books.sort((a, b) => b.publishedDate.compareTo(a.publishedDate));
        break;
      default:
        // Default sorting (tidak ada perubahan)
        break;
    }
    return books;
  }
  
  // Dispose resources
  void dispose() {
    _booksStreamController.close();
  }
}