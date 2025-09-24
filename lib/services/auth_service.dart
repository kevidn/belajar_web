import 'dart:async';
import '../models/user.dart';

class AuthResult {
  final User? user;
  final String? errorMessage;
  final bool success;

  AuthResult({
    this.user,
    this.errorMessage,
    this.success = false,
  });

  factory AuthResult.success(User user) {
    return AuthResult(
      user: user,
      success: true,
    );
  }

  factory AuthResult.error(String message) {
    return AuthResult(
      errorMessage: message,
      success: false,
    );
  }
}

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Data statis untuk user
  final Map<String, String> _users = {
    'admin@perpus.com': 'admin123',
    'user@perpus.com': 'user123',
  };

  // Data statis untuk user profile
  final Map<String, User> _userProfiles = {
    'admin@perpus.com': User(
      id: 'admin-id',
      email: 'admin@perpus.com',
      name: 'Admin Perpus',
      role: 'admin',
      password: 'admin123',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    'user@perpus.com': User(
      id: 'user-id',
      email: 'user@perpus.com',
      name: 'User Biasa',
      role: 'user',
      password: 'user123',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
  };

  // Controller untuk stream user
  final StreamController<User?> _userController = StreamController<User?>.broadcast();
  
  // User saat ini
  User? _currentUser;

  // Stream untuk mendengarkan perubahan status autentikasi
  Stream<User?> get userStream => _userController.stream;

  // Mendapatkan user saat ini
  User? get currentUser => _currentUser;

  // Mendapatkan ID user saat ini
  String? get currentUserId => _currentUser?.id;

  // Cek apakah user sudah sign in
  bool get isSignedIn => _currentUser != null;

  // Sign in dengan email dan password
  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Simulasi delay jaringan
      await Future.delayed(const Duration(seconds: 1));
      
      // Cek apakah email ada di database
      if (!_users.containsKey(email)) {
        return AuthResult.error('Email tidak terdaftar');
      }
      
      // Cek apakah password benar
      if (_users[email] != password) {
        return AuthResult.error('Password salah');
      }
      
      // Set current user
      _currentUser = _userProfiles[email];
      
      // Broadcast perubahan user
      _userController.add(_currentUser);
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // Register dengan email dan password
  Future<AuthResult> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      // Simulasi delay jaringan
      await Future.delayed(const Duration(seconds: 1));
      
      // Cek apakah email sudah terdaftar
      if (_users.containsKey(email)) {
        return AuthResult.error('Email sudah terdaftar');
      }
      
      // Buat user baru
      final String userId = 'user-${DateTime.now().millisecondsSinceEpoch}';
      final User newUser = User(
        id: userId,
        email: email,
        name: name,
        role: 'user',
        password: password,
        createdAt: DateTime.now(),
      );
      
      // Simpan user baru
      _users[email] = password;
      _userProfiles[email] = newUser;
      
      // Set current user
      _currentUser = newUser;
      
      // Broadcast perubahan user
      _userController.add(_currentUser);
      
      return AuthResult.success(newUser);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // Sign in dengan Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Simulasi delay jaringan
      await Future.delayed(const Duration(seconds: 1));
      
      // Buat user baru dengan Google
      final String email = 'google_user@gmail.com';
      final String userId = 'google-user-id';
      final User googleUser = User(
        id: userId,
        email: email,
        name: 'Google User',
        role: 'user',
        password: 'google-auth',
        createdAt: DateTime.now(),
      );
      
      // Simpan user Google jika belum ada
      if (!_userProfiles.containsKey(email)) {
        _userProfiles[email] = googleUser;
        _users[email] = 'google-auth';
      }
      
      // Set current user
      _currentUser = _userProfiles[email];
      
      // Broadcast perubahan user
      _userController.add(_currentUser);
      
      return AuthResult.success(_currentUser!);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // Sign in secara anonim
  Future<AuthResult> signInAnonymously() async {
    try {
      // Simulasi delay jaringan
      await Future.delayed(const Duration(seconds: 1));
      
      // Buat user anonim
      final String userId = 'anon-${DateTime.now().millisecondsSinceEpoch}';
      final User anonUser = User(
        id: userId,
        email: 'anonymous@user.com',
        name: 'Tamu',
        role: 'guest',
        password: 'anonymous',
        createdAt: DateTime.now(),
      );
      
      // Set current user
      _currentUser = anonUser;
      
      // Broadcast perubahan user
      _userController.add(_currentUser);
      
      return AuthResult.success(anonUser);
    } catch (e) {
      return AuthResult.error(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Reset current user
    _currentUser = null;
    
    // Broadcast perubahan user
    _userController.add(null);
  }

  // Mendapatkan email user saat ini
  Future<String?> getCurrentUserEmail() async {
    return _currentUser?.email;
  }
  
  // Verifikasi kredensial user
  Future<bool> verifyCredentials(String email, String password) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Cek apakah email ada di database
    if (!_users.containsKey(email)) {
      return false;
    }
    
    // Cek apakah password benar
    return _users[email] == password;
  }

  // Dispose resources
  void dispose() {
    _userController.close();
  }
}