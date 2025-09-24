import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Mendengarkan perubahan status autentikasi
    _authService.userStream.listen((user) {
      _user = user;
      notifyListeners();
    });
    
    // Cek apakah user sudah login
    _initializeUser();
  }
  
  Future<void> _initializeUser() async {
    _user = _authService.currentUser;
    notifyListeners();
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      
      if (result.success) {
        _user = result.user;
        notifyListeners();
        return true;
      } else {
        _error = result.errorMessage;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithEmailAndPassword(String email, String password, String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.registerWithEmailAndPassword(email, password, name);
      _isLoading = false;
      
      if (result.success) {
        _user = result.user;
        notifyListeners();
        return true;
      } else {
        _error = result.errorMessage;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signInWithGoogle();
      if (result.success) {
        _user = result.user;
      }
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signInAnonymously();
      if (result.success) {
        _user = result.user;
      }
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> getCurrentUserEmail() async {
    return await _authService.getCurrentUserEmail();
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}