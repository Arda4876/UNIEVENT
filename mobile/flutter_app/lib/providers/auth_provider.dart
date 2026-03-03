import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  Future<void> loginWithStudentEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Email must be a student email
      if (!email.contains('@student.') && !email.endsWith('.edu.tr')) {
        throw Exception('Lütfen geçerli bir öğrenci e-postası girin');
      }

      // Simulated login
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: email.split('@')[0],
        fullName: 'Öğrenci Adı', // örnek isim
        userType: 'student',
      );
      _isLoggedIn = true;
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!email.contains('@')) {
        throw Exception('Geçerli bir e-posta adresi girin');
      }
      if (password.length < 6) {
        throw Exception('Şifre en az 6 karakter olmalı');
      }

      // Simulated login
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        username: email.split('@')[0],
        fullName: 'Kullanıcı Adı', // örnek isim
        userType: 'regular',
      );
      _isLoggedIn = true;
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
