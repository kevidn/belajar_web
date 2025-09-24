import 'package:flutter/material.dart';
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
  late List<Book> _allBooks = [];
  late Stream<List<Book>> _booksStream;

  // Daftar buku yang ditampilkan (bisa berubah saat pencarian)
  late List<Book> _displayedBooks = [];
  // Controller untuk search bar
  final TextEditingController _searchController = TextEditingController();
  // Filter rating
  int _ratingFilter = 0; // 0 = semua, 1-5 = rating bintang
  // Sorting
  String _sortBy = 'none'; // none, title, rating

  // State untuk pagination
  int _currentPage = 1;
  int _itemsPerPage = 5;
  int _totalPages = 1;
  List<Book> _paginatedBooks = [];

  // State untuk hover effect
  bool _isSearchHovered = false;
  bool _isRatingHovered = false;
  bool _isSortingHovered = false;

  // Warna pastel untuk tema aplikasi (digelapkan)
  final Color _pastelPrimary = const Color(0xFF7AADDE); // Biru pastel lebih gelap
  final Color _pastelSecondary =
      const Color(0xFFEEE59D); // Kuning pastel lebih gelap
  final Color _pastelAccent =
      const Color(0xFFFFAA90); // Oranye pastel lebih gelap
  final Color _pastelBackground =
      const Color(0xFFEAEBED); // Abu-abu sangat terang lebih gelap
  final Color _pastelSidebar =
      const Color(0xFFCCE3FC); // Biru sangat terang lebih gelap
  final Color _textColor = const Color(0xFF2C3E50); // Warna teks gelap

  // Variabel untuk pagination
  int _currentPage = 0;
  final int _booksPerPage = 6;
  List<Book> _paginatedBooks = [];

  @override
  void initState() {
    super.initState();
    // Mengambil data buku dari service
    _booksStream = _bookService.getAllBooks();
    _booksStream.listen((books) {
      setState(() {
        _allBooks = books;
        _displayedBooks = List.from(_allBooks);
        _updatePagination(); // Panggil pagination
      });
    });
    _searchController.addListener(_filterBooks);
    
    // Memastikan data buku dimuat saat pertama kali halaman dibuka
    _loadInitialBooks();
  }
  
  // Memuat data buku awal
  void _loadInitialBooks() {
    _bookService.getAllBooks().listen((books) {
      setState(() {
        _allBooks = books;
        _displayedBooks = List.from(_allBooks);
        _updatePagination(); // Panggil pagination
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter buku berdasarkan pencarian dan rating dengan animasi
  void _filterBooks() {
    // Menambahkan efek animasi saat filter berubah
    setState(() {
      final String query = _searchController.text.toLowerCase();
      
      // Menggunakan service untuk pencarian
      if (query.isEmpty) {
        _bookService.getAllBooks().listen((books) {
          setState(() {
            _displayedBooks = books.where((book) {
              final bool matchesRating = _ratingFilter == 0 ||
                  book.rating >= _ratingFilter && book.rating < _ratingFilter + 1;
              return matchesRating;
            }).toList();
            
            // Sorting menggunakan service
            if (_sortBy != 'none') {
              String sortOption = _sortBy == 'title' ? 'Judul A-Z' :
                                _sortBy == 'rating' ? 'Rating Tertinggi' : 'Judul A-Z';
              _displayedBooks = _bookService.sortBooks(_displayedBooks, sortOption);
            }
            _updatePagination(); // Panggil pagination setelah filter dan sort
          });
        });
      } else {
        _bookService.searchBooks(query).listen((books) {
          setState(() {
            _displayedBooks = books.where((book) {
              final bool matchesRating = _ratingFilter == 0 ||
                  book.rating >= _ratingFilter && book.rating < _ratingFilter + 1;
              return matchesRating;
            }).toList();
            
            // Sorting menggunakan service
            if (_sortBy != 'none') {
              String sortOption = _sortBy == 'title' ? 'Judul A-Z' :
                                _sortBy == 'rating' ? 'Rating Tertinggi' : 'Judul A-Z';
              _displayedBooks = _bookService.sortBooks(_displayedBooks, sortOption);
            }
            _updatePagination(); // Panggil pagination setelah filter dan sort
          });
        });
      }
    });
  }

  // Metode untuk pagination
  void _updatePagination() {
    final int startIndex = _currentPage * _booksPerPage;
    int endIndex = startIndex + _booksPerPage;
    if (endIndex > _displayedBooks.length) {
      endIndex = _displayedBooks.length;
    }
    setState(() {
      _paginatedBooks = _displayedBooks.sublist(startIndex, endIndex);
    });
  }

  void _nextPage() {
    if ((_currentPage + 1) * _booksPerPage < _displayedBooks.length) {
      setState(() {
        _currentPage++;
        _updatePagination();
      });
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _updatePagination();
      });
    }
  }

  // Metode untuk membangun konten utama
  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          // Ruang kosong di kiri (20% layar)
          Expanded(
            flex: 2, // 20% dari layar
            child: Container(),
          ),
          // Konten utama (60% layar)
          Expanded(
            flex: 6, // 60% dari layar
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Filter dan sorting (1/3 dari konten utama)
                  Expanded(
                    flex: 1, // 1/3 dari konten utama
                    child: Container(
                      decoration: BoxDecoration(
                        color: _pastelSidebar,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _pastelPrimary.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search bar dengan tampilan yang lebih menarik
                          Row(
                            children: [
                              Icon(Icons.search,
                                  color: _pastelPrimary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Pencarian:',
                                style: TextStyle(
                                  color: _textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            onEnter: (_) =>
                                setState(() => _isSearchHovered = true),
                            onExit: (_) =>
                                setState(() => _isSearchHovered = false),
                            cursor: SystemMouseCursors.text,
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _pastelPrimary.withOpacity(
                                          _isSearchHovered ? 0.25 : 0.15),
                                      spreadRadius: _isSearchHovered ? 2 : 1,
                                      blurRadius: _isSearchHovered ? 6 : 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: _pastelPrimary.withOpacity(
                                        _isSearchHovered ? 0.5 : 0.3),
                                    width: _isSearchHovered ? 1.5 : 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Cari judul atau penulis...',
                                    hintStyle: TextStyle(
                                        color: _textColor.withOpacity(0.5),
                                        fontStyle: FontStyle.italic),
                                    prefixIcon: Icon(Icons.search,
                                        color: _pastelPrimary),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: Icon(Icons.clear,
                                                color: _pastelPrimary),
                                            onPressed: () {
                                              setState(() {
                                                _searchController.clear();
                                                _filterBooks();
                                              });
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                  ),
                                  style: TextStyle(
                                      color: _textColor,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                          const SizedBox(height: 28),
                          // Filter rating dengan tampilan yang lebih menarik
                          Row(
                            children: [
                              Icon(Icons.filter_list,
                                  color: _pastelPrimary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Filter Rating:',
                                style: TextStyle(
                                  color: _textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            onEnter: (_) =>
                                setState(() => _isRatingHovered = true),
                            onExit: (_) =>
                                setState(() => _isRatingHovered = false),
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _pastelPrimary.withOpacity(
                                        _isRatingHovered ? 0.25 : 0.15),
                                    spreadRadius: _isRatingHovered ? 2 : 1,
                                    blurRadius: _isRatingHovered ? 6 : 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: _pastelPrimary.withOpacity(
                                      _isRatingHovered ? 0.5 : 0.3),
                                  width: _isRatingHovered ? 1.5 : 1,
                                ),
                              ),
                              child: DropdownButton<int>(
                                value: _ratingFilter,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: _pastelPrimary),
                                iconSize: 28,
                                elevation: 8,
                                underline: const SizedBox(),
                                style: TextStyle(
                                    color: _textColor,
                                    fontWeight: FontWeight.w500),
                                onChanged: (value) {
                                  setState(() {
                                    _ratingFilter = value!;
                                    _filterBooks();
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Row(
                                      children: [
                                        Icon(Icons.all_inclusive,
                                            color:
                                                _pastelPrimary.withOpacity(0.7),
                                            size: 16),
                                        const SizedBox(width: 8),
                                        Text('Semua Rating',
                                            style:
                                                TextStyle(color: _textColor)),
                                      ],
                                    ),
                                  ),
                                  for (int i = 1; i <= 5; i++)
                                    DropdownMenuItem(
                                      value: i,
                                      child: Row(
                                        children: [
                                          Text('$i+',
                                              style: TextStyle(
                                                  color: _textColor,
                                                  fontWeight:
                                                      FontWeight.bold)),
                                          const SizedBox(width: 8),
                                          for (int j = 0; j < i; j++)
                                            Icon(Icons.star,
                                                color: _pastelAccent, size: 16),
                                          for (int j = i; j < 5; j++)
                                            Icon(Icons.star_border,
                                                color: _pastelAccent
                                                    .withOpacity(0.5),
                                                size: 16),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Sorting dengan tampilan yang lebih menarik
                          Row(
                            children: [
                              Icon(Icons.sort, color: _pastelPrimary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Urutkan Berdasarkan:',
                                style: TextStyle(
                                  color: _textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            onEnter: (_) =>
                                setState(() => _isSortingHovered = true),
                            onExit: (_) =>
                                setState(() => _isSortingHovered = false),
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _pastelPrimary.withOpacity(
                                        _isSortingHovered ? 0.25 : 0.15),
                                    spreadRadius: _isSortingHovered ? 2 : 1,
                                    blurRadius: _isSortingHovered ? 6 : 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: _pastelPrimary.withOpacity(
                                      _isSortingHovered ? 0.5 : 0.3),
                                  width: _isSortingHovered ? 1.5 : 1,
                                ),
                              ),
                              child: DropdownButton<String>(
                                value: _sortBy,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down,
                                    color: _pastelPrimary),
                                iconSize: 28,
                                elevation: 8,
                                underline: const SizedBox(),
                                style: TextStyle(
                                    color: _textColor,
                                    fontWeight: FontWeight.w500),
                                onChanged: (value) {
                                  setState(() {
                                    _sortBy = value!;
                                    _filterBooks();
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 'none',
                                    child: Row(
                                      children: [
                                        Icon(Icons.format_list_bulleted,
                                            color:
                                                _pastelPrimary.withOpacity(0.7),
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text('Default',
                                            style:
                                                TextStyle(color: _textColor)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'title',
                                    child: Row(
                                      children: [
                                        Icon(Icons.sort_by_alpha,
                                            color:
                                                _pastelPrimary.withOpacity(0.7),
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text('Judul (A-Z)',
                                            style:
                                                TextStyle(color: _textColor)),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'rating',
                                    child: Row(
                                      children: [
                                        Icon(Icons.star_rate,
                                            color:
                                                _pastelPrimary.withOpacity(0.7),
                                            size: 18),
                                        const SizedBox(width: 8),
                                        Text('Rating (Tertinggi)',
                                            style:
                                                TextStyle(color: _textColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Pengaturan ukuran card telah dihapus
                        ],
                      ),
                    ),
                  ),
                  // Daftar buku (2/3 dari konten utama)
                  Expanded(
                    flex: 2, // 2/3 dari konten utama
                    child: _displayedBooks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada buku yang ditemukan',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: _textColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Tetap 2 buku per baris
                                childAspectRatio: 0.7, // Nilai default yang baik
                                crossAxisSpacing: 16, // Jarak horizontal antar card
                                mainAxisSpacing: 16, // Jarak vertikal antar card
                              ),
                              itemCount: _displayedBooks.length,
                              itemBuilder: (context, index) {
                                final book = _displayedBooks[index];
                                return Card(
                                  elevation: 2,
                                  shadowColor: Colors.black12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigasi ke halaman detail
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailScreen(book: book),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Cover buku
                                        Expanded(
                                          flex: 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(12)),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  book.imageUrl,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                        child: Icon(Icons
                                                            .broken_image)),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: _pastelSecondary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .orange[700],
                                                          size: 14,
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        Text(
                                                          book.rating
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: _textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Informasi buku
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  book.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: _textColor,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  book.author,
                                                  style: TextStyle(
                                                    color: _textColor
                                                        .withOpacity(0.7),
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Spacer(), // Mendorong tombol ke bawah
                                                // Tombol detail dipindahkan ke bawah
                                                Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: _pastelPrimary
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Lihat Detail',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: _pastelPrimary
                                                            .withOpacity(
                                                                0.8), // Warna teks dibuat lebih gelap
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          // Ruang kosong di kanan (20% layar)
          Expanded(
            flex: 2, // 20% dari layar
            child: Container(),
          ),
        ],
      ),
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
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        // Icon dan judul aplikasi di bagian kiri (tanpa icon back di pojok kiri header)
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.book, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Perpustakaan Digital',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if (widget.user != null)
                  Text(
                    'Selamat datang, ${widget.user!.displayName} (${widget.user!.role})',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Tombol profil (10% dari pojok kanan)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(email: widget.email),
                  ),
                );
              },
            ),
          ),
          // Tombol logout (10% dari pojok kanan)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              _pastelSidebar.withOpacity(0.3),
            ],
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  // Metode untuk mengupdate pagination
  void _updatePagination() {
    setState(() {
      // Hitung total halaman
      _totalPages = (_displayedBooks.length / _itemsPerPage).ceil();
      if (_totalPages == 0) _totalPages = 1;
      
      // Pastikan halaman saat ini valid
      if (_currentPage > _totalPages) {
        _currentPage = _totalPages;
      }
      
      // Hitung indeks awal dan akhir untuk pagination
      int startIndex = (_currentPage - 1) * _itemsPerPage;
      int endIndex = startIndex + _itemsPerPage;
      
      // Pastikan endIndex tidak melebihi jumlah data
      if (endIndex > _displayedBooks.length) {
        endIndex = _displayedBooks.length;
      }
      
      // Update buku yang ditampilkan berdasarkan pagination
      _paginatedBooks = _displayedBooks.sublist(startIndex, endIndex);
    });
  }

  // Pindah ke halaman berikutnya
  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _updatePagination();
      });
    }
  }

  // Pindah ke halaman sebelumnya
  void _prevPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _updatePagination();
      });
    }
  }
}