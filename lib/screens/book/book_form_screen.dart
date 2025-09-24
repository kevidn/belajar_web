import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/auth_provider.dart';
import '../../services/book_service.dart';

class BookFormScreen extends StatefulWidget {
  static const routeName = '/book-form';

  const BookFormScreen({super.key});

  @override
  _BookFormScreenState createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _publishedDateController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedCategory = 'Novel';
  bool _isAvailable = true;
  bool _isLoading = false;
  bool _isEditing = false;
  String? _bookId;

  final List<String> _categories = [
    'Novel',
    'Pendidikan',
    'Biografi',
    'Sejarah',
    'Teknologi',
    'Bisnis',
    'Anak-anak',
    'Lainnya',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final book = ModalRoute.of(context)?.settings.arguments as Book?;
    if (book != null && !_isEditing) {
      _isEditing = true;
      _bookId = book.id;
      _titleController.text = book.title;
      _authorController.text = book.author;
      _descriptionController.text = book.description;
      _coverUrlController.text = book.imageUrl ?? '';
      _publishedDateController.text = book.publishedDate?.toIso8601String().split('T')[0] ?? '';
      _priceController.text = book.price.toString();
      _selectedCategory = book.category;
      _isAvailable = book.isAvailable;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    _publishedDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }


  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user == null) {
        throw Exception("User tidak ditemukan, silakan login ulang.");
      }
      final userId = authProvider.user!.id;
      final bookService = BookService();

      DateTime? publishedDate;
      try {
        publishedDate = DateTime.parse(_publishedDateController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Format tanggal salah. Gunakan format YYYY-MM-DD.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // === BAGIAN YANG DIPERBAIKI ADA DI SINI ===
      final book = Book(
        id: _bookId ?? '', // ID akan diabaikan saat membuat buku baru
        title: _titleController.text,
        author: _authorController.text,
        description: _descriptionController.text,
        // Menggunakan imageUrl, bukan coverUrl
        imageUrl: _coverUrlController.text.isEmpty
            ? 'https://via.placeholder.com/150' // URL placeholder jika kosong
            : _coverUrlController.text,
        publishedDate: publishedDate,
        price: double.tryParse(_priceController.text) ?? 0.0,
        category: _selectedCategory,
        isAvailable: _isAvailable,
        ownerId: userId,
        // Properti lain yang ada di model diisi dengan nilai default
        // karena tidak ada di form, ini penting agar toMap() tidak error.
        rating: 0.0,
        pages: 0,
        isbn: '',
        language: 'Indonesia',
        tags: [_selectedCategory],
      );
      // === AKHIR DARI BAGIAN YANG DIPERBAIKI ===


      if (_isEditing) {
        if (_bookId == null) throw Exception("ID Buku tidak valid untuk diedit.");
        await bookService.updateBook(book.copyWith(id: _bookId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await bookService.addBook(book);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan buku: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Buku' : 'Tambah Buku'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Buku',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul buku tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _authorController,
                        decoration: const InputDecoration(
                          labelText: 'Penulis',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penulis tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _coverUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL Cover (opsional)',
                          border: OutlineInputBorder(),
                          hintText: 'https://example.com/cover.jpg',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _publishedDateController,
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Terbit',
                          border: OutlineInputBorder(),
                          hintText: 'Januari 2023',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal terbit tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Harga (Rp)',
                          border: OutlineInputBorder(),
                          prefixText: 'Rp ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga tidak boleh kosong';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Harga harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategori tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Tersedia'),
                        value: _isAvailable,
                        onChanged: (value) {
                          setState(() {
                            _isAvailable = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saveBook,
                          child: Text(
                            _isEditing ? 'PERBARUI BUKU' : 'TAMBAH BUKU',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}