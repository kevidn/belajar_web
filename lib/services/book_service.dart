import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/book.dart';

class BookService {
  final _booksController = StreamController<List<Book>>.broadcast();
  List<Book> _books = [];

  BookService() {
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/dummy_books.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _books = jsonList.map((json) => Book.fromMap(json)).toList();
      _booksController.add(_books);
    } catch (e) {
      print('Error loading books: $e');
      _booksController.addError('Failed to load books');
    }
  }

  Stream<List<Book>> getAllBooks() => _booksController.stream;

  void addBook(Book book) {
    _books.add(book);
    _booksController.add(List.from(_books));
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      _booksController.add(List.from(_books));
    }
  }

  void deleteBook(String id) {
    _books.removeWhere((book) => book.id == id);
    _booksController.add(List.from(_books));
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;
    return _books.where((book) => 
        book.title.toLowerCase().contains(query.toLowerCase()) || 
        book.author.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Book> filterByCategory(String category) {
    if (category.toLowerCase() == 'all') return _books;
    return _books.where((book) => book.category.toLowerCase() == category.toLowerCase()).toList();
  }

  List<Book> sortBooks(String sortBy) {
    List<Book> sortedBooks = List.from(_books);
    if (sortBy == 'title') {
      sortedBooks.sort((a, b) => a.title.compareTo(b.title));
    } else if (sortBy == 'rating') {
      sortedBooks.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return sortedBooks;
  }

  void dispose() {
    _booksController.close();
  }
}