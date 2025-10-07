// Lokasi: lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/book.dart'; // Menggunakan model Book yang sudah terpusat

class Review {
  final String username;
  final double rating;
  final String comment;
  final String date;

  Review({
    required this.username,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class DetailScreen extends StatelessWidget {
  final Book book;

  const DetailScreen({super.key, required this.book});

  // Data dummy untuk review buku
  List<Review> _getReviews() {
    return [
      Review(
        username: 'Ahmad',
        rating: 4.5,
        comment:
            'Buku yang sangat informatif dan mudah dipahami. Sangat direkomendasikan untuk pemula.',
        date: '12 Mei 2023',
      ),
      Review(
        username: 'Budi',
        rating: 5.0,
        comment:
            'Penjelasan yang detail dan contoh kode yang lengkap. Saya belajar banyak dari buku ini.',
        date: '23 Juni 2023',
      ),
    ];
  }

  Widget _buildDetailRow(
      String label, String value, IconData icon, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: textColor.withOpacity(0.7), size: 20),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _getReviews();

    // Warna pastel untuk tema aplikasi
    final Color pastelPrimary = const Color(0xFF7AADDE);
    final Color pastelSecondary = const Color(0xFFEEE59D);
    final Color pastelBackground = const Color(0xFFEAEBED);
    final Color textColor = const Color(0xFF2C3E50);

    return Scaffold(
      backgroundColor: pastelBackground,
      appBar: AppBar(
        title: const Text(
          'Detail Buku',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: pastelPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Row(
        children: [
          // Ruang kosong di kiri
          Expanded(flex: 2, child: Container()),
          // Konten utama
          Expanded(
            flex: 6,
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
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan detail buku
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: pastelPrimary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: pastelPrimary.withOpacity(0.5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              image: DecorationImage(
                                // PERBAIKAN: Menggunakan imageUrl yang benar
                                image: NetworkImage(book.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            book.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'oleh ${book.author}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: pastelSecondary, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  book.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Deskripsi dan Detail
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ... Sisa kode tidak perlu diubah ...
                          Text(
                            'Informasi Detail',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  pastelBackground.withOpacity(0.5),
                                  Colors.white
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: pastelPrimary.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildDetailRow('Kategori', book.category,
                                    Icons.category, textColor),
                                const SizedBox(height: 12),
                                _buildDetailRow('Halaman',
                                    '${book.pages} halaman', Icons.menu_book, textColor),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                    'ISBN', book.isbn, Icons.qr_code, textColor),
                                const SizedBox(height: 12),
                                _buildDetailRow('Bahasa', book.language,
                                    Icons.language, textColor),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                    'Tanggal Terbit',
                                    '${book.publishedDate.day}/${book.publishedDate.month}/${book.publishedDate.year}',
                                    Icons.calendar_today,
                                    textColor),
                                const SizedBox(height: 12),
                                _buildDetailRow(
                                    'Status',
                                    book.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                                    book.isAvailable
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    book.isAvailable ? Colors.green : Colors.red),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Aksi untuk membaca buku
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: pastelPrimary,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              icon: const Icon(Icons.book_outlined,
                                  color: Colors.white),
                              label: const Text(
                                'Baca Sekarang',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Ruang kosong di kanan
          Expanded(flex: 2, child: Container()),
        ],
      ),
    );
  }
}