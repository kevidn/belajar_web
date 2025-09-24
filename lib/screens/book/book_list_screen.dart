import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/auth_provider.dart';
import '../../services/book_service.dart';
import 'book_form_screen.dart';
import 'book_card.dart';

class BookListScreen extends StatefulWidget {
  static const routeName = '/books';

  const BookListScreen({super.key});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  List<String> _categories = ['Semua'];
  bool _showOnlyMyBooks = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = _bookService.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(_bookService),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Cari Buku',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Kategori',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: _selectedCategory,
                            items: _categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (authProvider.user != null)
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Buku Saya'),
                              value: _showOnlyMyBooks,
                              onChanged: (value) {
                                setState(() {
                                  _showOnlyMyBooks = value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBookList(),
          ),
        ],
      ),
      floatingActionButton: authProvider.user != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  BookFormScreen.routeName,
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBookList() {
    Stream<List<Book>> booksStream;
    
    if (_showOnlyMyBooks) {
      booksStream = _bookService.getUserBooks();
    } else if (_selectedCategory != 'Semua') {
      booksStream = _bookService.getBooksByCategory(_selectedCategory);
    } else if (_searchQuery.isNotEmpty) {
      booksStream = _bookService.searchBooks(_searchQuery);
    } else {
      booksStream = _bookService.getAllBooks();
    }
    
    return StreamBuilder<List<Book>>(
      stream: booksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final books = snapshot.data ?? [];
        
        if (books.isEmpty) {
          return const Center(child: Text('Tidak ada buku yang ditemukan'));
        }
        
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(
              book: book,
              onEdit: () => _editBook(book),
              onDelete: () => _deleteBook(book.id),
            );
          },
        );
      },
    );
  }

  void _editBook(Book book) {
    Navigator.of(context).pushNamed(
      BookFormScreen.routeName,
      arguments: book,
    );
  }

  void _deleteBook(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Buku'),
        content: const Text('Apakah Anda yakin ingin menghapus buku ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              _bookService.deleteBook(id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Buku berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('HAPUS'),
          ),
        ],
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final BookService _bookService;

  BookSearchDelegate(this._bookService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<List<Book>>(
      stream: _bookService.searchBooks(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final books = snapshot.data ?? [];
        
        if (books.isEmpty) {
          return const Center(child: Text('Tidak ada buku yang ditemukan'));
        }
        
        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return ListTile(
              leading: book.imageUrl != null && book.imageUrl!.isNotEmpty
                  ? Image.network(
                      book.imageUrl!,
                      width: 40,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 40,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.book, size: 20),
                        );
                      },
                    )
                  : Container(
                      width: 40,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Icon(Icons.book, size: 20),
                    ),
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () {
                close(context, book);
              },
            );
          },
        );
      },
    );
  }
}