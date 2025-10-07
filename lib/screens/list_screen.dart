// Lokasi: lib/screens/list_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'detail_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../services/book_service.dart';

class ListScreen extends StatefulWidget {
  final String email;
  final User? user;

  const ListScreen({super.key, required this.email, this.user});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // Service untuk mengelola data buku
  final BookService _bookService = BookService();

  // Data buku dari service
  List<Book> _allBooks = [];
  StreamSubscription<List<Book>>? _booksSubscription;

  // Daftar buku yang ditampilkan (bisa berubah saat pencarian)
  List<Book> _displayedBooks = [];
  // Controller untuk search bar
  final TextEditingController _searchController = TextEditingController();
  // Filter rating
  int _ratingFilter = 0; // 0 = semua, 1-5 = rating bintang
  // Sorting
  String _sortBy = 'none'; // none, title, rating

  // State untuk pagination
  int _currentPage = 1;
  int _totalPages = 1;
  List<Book> _paginatedBooks = [];

  // Warna pastel untuk tema aplikasi
  final Color _pastelPrimary = const Color(0xFF7AADDE);
  final Color _pastelSecondary = const Color(0xFFEEE59D);
  final Color _pastelAccent = const Color(0xFFFFAA90);
  final Color _pastelBackground = const Color(0xFFEAEBED);
  final Color _pastelSidebar = const Color(0xFFCCE3FC);
  final Color _textColor = const Color(0xFF2C3E50);

  // Variabel untuk pagination
  final int _booksPerPage = 6;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _booksSubscription = _bookService.getAllBooks().listen((books) {
      if (mounted) {
        setState(() {
          _allBooks = books;
          _filterAndSortBooks();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _booksSubscription?.cancel();
    super.dispose();
  }
  
  void _onSearchChanged() {
      _filterAndSortBooks();
  }

  // Metode terpusat untuk filter dan sort
  void _filterAndSortBooks() {
    final String query = _searchController.text.toLowerCase();
    List<Book> filtered = List.from(_allBooks);

    if (query.isNotEmpty) {
      filtered = filtered.where((book) =>
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query)).toList();
    }

    if (_ratingFilter > 0) {
      filtered = filtered.where((book) =>
          book.rating >= _ratingFilter && book.rating < _ratingFilter + 1).toList();
    }

    if (_sortBy != 'none') {
      filtered.sort((a, b) {
        if (_sortBy == 'title') {
          return a.title.compareTo(b.title);
        } else if (_sortBy == 'rating') {
          return b.rating.compareTo(a.rating);
        }
        return 0;
      });
    }

    setState(() {
      _displayedBooks = filtered;
      _currentPage = 1;
      _updatePagination();
    });
  }

  void _updatePagination() {
    _totalPages = (_displayedBooks.length / _booksPerPage).ceil();
    if (_totalPages == 0) _totalPages = 1;

    final int startIndex = (_currentPage - 1) * _booksPerPage;
    int endIndex = startIndex + _booksPerPage;
    if (endIndex > _displayedBooks.length) {
      endIndex = _displayedBooks.length;
    }
    
    _paginatedBooks = (startIndex < endIndex) 
      ? _displayedBooks.sublist(startIndex, endIndex) 
      : [];
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: _currentPage > 1 ? _textColor : Colors.grey),
          onPressed: _currentPage > 1 ? () => setState(() { _currentPage--; _updatePagination(); }) : null,
        ),
        Text(
          'Halaman $_currentPage dari $_totalPages',
          style: TextStyle(color: _textColor, fontSize: 14),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios,
              color: _currentPage < _totalPages ? _textColor : Colors.grey),
          onPressed: _currentPage < _totalPages ? () => setState(() { _currentPage++; _updatePagination(); }) : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pastelBackground,
      appBar: AppBar(
        backgroundColor: _pastelPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.book, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Perpustakaan Digital', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                if (widget.user != null)
                  Text('Selamat datang, ${widget.user!.displayName} (${widget.user!.role})', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(email: widget.email))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 6,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _pastelSidebar,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterTitle('Pencarian:', Icons.search),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari judul atau penulis...',
                              prefixIcon: Icon(Icons.search, color: _pastelPrimary),
                              suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: _pastelPrimary),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : null,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _buildFilterTitle('Filter Rating:', Icons.filter_list),
                          const SizedBox(height: 12),
                          GFDropdown(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            borderRadius: BorderRadius.circular(12),
                            border: BorderSide(color: _pastelPrimary.withOpacity(0.3), width: 1),
                            dropdownButtonColor: Colors.white,
                            value: _ratingFilter,
                            onChanged: (newValue) => setState(() { _ratingFilter = newValue as int; _filterAndSortBooks(); }),
                            items: [
                              DropdownMenuItem(value: 0, child: Text('Semua Rating', style: TextStyle(color: _textColor))),
                              for (int i = 1; i <= 5; i++)
                                DropdownMenuItem(value: i, child: GFRating(value: i.toDouble(), size: 16, color: _pastelAccent, borderColor: _pastelAccent, allowHalfRating: false, onChanged: (value) {})),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _buildFilterTitle('Urutkan Berdasarkan:', Icons.sort),
                          const SizedBox(height: 12),
                          GFDropdown(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            borderRadius: BorderRadius.circular(12),
                            border: BorderSide(color: _pastelPrimary.withOpacity(0.3), width: 1),
                            dropdownButtonColor: Colors.white,
                            value: _sortBy,
                            onChanged: (newValue) => setState(() { _sortBy = newValue as String; _filterAndSortBooks(); }),
                            items: [
                              DropdownMenuItem(value: 'none', child: Text('Default', style: TextStyle(color: _textColor))),
                              DropdownMenuItem(value: 'title', child: Text('Judul (A-Z)', style: TextStyle(color: _textColor))),
                              DropdownMenuItem(value: 'rating', child: Text('Rating (Tertinggi)', style: TextStyle(color: _textColor))),
                            ],
                          ),
                          const Spacer(),
                          _buildPaginationControls(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _paginatedBooks.isEmpty
                        ? const Center(child: Text('Tidak ada buku yang ditemukan'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: _paginatedBooks.length,
                            itemBuilder: (context, index) {
                              final book = _paginatedBooks[index];
                              return GFCard(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.zero,
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                imageOverlay: NetworkImage(book.imageUrl),
                                title: GFListTile(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(book: book))),
                                  title: Text(book.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  subTitle: Text(book.author, style: TextStyle(color: _textColor.withOpacity(0.7), fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  icon: GFRating(value: book.rating, onChanged: (v) {}, size: 18, color: _pastelAccent, borderColor: _pastelAccent.withOpacity(0.5)),
                                ),
                                buttonBar: GFButtonBar(
                                  children: <Widget>[
                                    GFButton(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(book: book))),
                                      text: 'Lihat Detail',
                                      color: _pastelPrimary,
                                      shape: GFButtonShape.pills,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildFilterTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _pastelPrimary, size: 18),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: _textColor, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}