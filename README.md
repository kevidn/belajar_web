# Proyek Aplikasi Perpus

## Latar Belakang

Aplikasi "Perpus" adalah sebuah sistem manajemen perpustakaan digital yang dirancang untuk memberikan kemudahan akses dan pengelolaan koleksi buku. Latar belakang pengembangan aplikasi ini adalah kebutuhan untuk modernisasi sistem perpustakaan konvensional menjadi platform digital yang lebih efisien, interaktif, dan mudah diakses oleh pengguna dari berbagai perangkat.

## Tujuan

Tujuan utama dari aplikasi "Perpus" adalah:

1.  **Digitalisasi Koleksi Buku:** Mengubah koleksi buku fisik menjadi format digital yang mudah diakses.
2.  **Memudahkan Pengelolaan:** Memberikan kemudahan bagi admin untuk mengelola data buku, anggota, dan peminjaman.
3.  **Meningkatkan Pengalaman Pengguna:** Menyediakan antarmuka yang ramah pengguna untuk mencari, meminjam, dan membaca buku.
4.  **Fleksibilitas Akses:** Memungkinkan pengguna untuk mengakses perpustakaan kapan saja dan di mana saja melalui perangkat web.

## Penjelasan Aplikasi, Fitur, dan Manfaat

"Perpus" adalah aplikasi perpustakaan berbasis web yang memungkinkan pengguna untuk menjelajahi koleksi buku digital. Berikut adalah fitur-fitur utama dan manfaatnya:

### Fitur

*   **Autentikasi Pengguna:** Pengguna dapat mendaftar dan masuk ke aplikasi menggunakan email dan password, atau melalui akun Google.
*   **Pencarian dan Filter:** Pengguna dapat dengan mudah mencari buku berdasarkan judul, penulis, atau kategori, serta memfilter hasil pencarian.
*   **Tampilan Detail Buku:** Setiap buku memiliki halaman detail yang menampilkan informasi lengkap seperti sinopsis, rating, dan ulasan.
*   **Manajemen Profil:** Pengguna dapat melihat dan mengelola informasi profil mereka.
*   **Antarmuka Responsif:** Aplikasi ini dirancang agar dapat diakses dengan nyaman dari berbagai ukuran layar, baik desktop maupun mobile.

### Manfaat

*   **Aksesibilitas:** Pengguna dapat mengakses ribuan buku tanpa harus datang ke perpustakaan fisik.
*   **Efisiensi:** Proses peminjaman dan pengembalian buku menjadi lebih cepat dan efisien.
*   **Keterlibatan:** Fitur-fitur interaktif seperti rating dan ulasan mendorong keterlibatan pengguna.

## Implementasi Konsep OOP pada Struktur Model Data

Aplikasi "Perpus" menerapkan beberapa konsep Object-Oriented Programming (OOP) dalam struktur model datanya untuk memastikan kode yang terorganisir, mudah dikelola, dan skalabel.

### 1. Encapsulation (Enkapsulasi)

Konsep enkapsulasi diterapkan pada model data seperti `Book` dan `User`. Setiap kelas membungkus data (atribut) dan metode (fungsi) yang beroperasi pada data tersebut. Contohnya, kelas `Book` memiliki atribut seperti `title`, `author`, dan `description`, serta metode untuk mengelola data tersebut.

### 2. Abstraction (Abstraksi)

Abstraksi digunakan untuk menyembunyikan detail implementasi yang kompleks dan hanya menampilkan fungsionalitas yang relevan. Misalnya, saat pengguna meminjam buku, mereka hanya perlu menekan tombol "Pinjam" tanpa perlu tahu bagaimana proses peminjaman tersebut ditangani di backend.

### 3. Inheritance (Pewarisan)

Meskipun dalam versi saat ini tidak ada contoh pewarisan yang kompleks, konsep ini dapat diterapkan di masa depan. Misalnya, kita bisa membuat kelas `DigitalBook` dan `PhysicalBook` yang mewarisi sifat dari kelas `Book` dasar, namun memiliki atribut dan metode tambahan yang spesifik.

### 4. Polymorphism (Polimorfisme)

Polimorfisme memungkinkan objek dari kelas yang berbeda untuk merespons metode yang sama dengan cara yang berbeda. Contohnya, metode `display()` bisa diimplementasikan secara berbeda pada kelas `DigitalBook` dan `PhysicalBook` untuk menampilkan detail buku sesuai dengan formatnya.

Dengan menerapkan konsep-konsep OOP ini, struktur kode aplikasi "Perpus" menjadi lebih modular, fleksibel, dan mudah untuk dikembangkan lebih lanjut.
