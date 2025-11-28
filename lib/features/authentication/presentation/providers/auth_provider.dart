// lib/features/authentication/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Mock User object (thay thế Firebase User)
class MockUser {
  final String uid;
  final String email;
  final String? displayName;

  MockUser({
    required this.uid,
    required this.email,
    this.displayName,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
    };
  }

  factory MockUser.fromMap(Map<dynamic, dynamic> map) {
    return MockUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String?,
    );
  }
}

class AuthProvider with ChangeNotifier {
  MockUser? _user;
  bool _isLoading = false;
  String? _error;

  MockUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _initAuthState();
  }

  /// Khởi tạo auth state từ Hive (persistent storage)
  void _initAuthState() {
    try {
      final userBox = Hive.box('auth_user');
      if (userBox.containsKey('current_user')) {
        final userData = userBox.get('current_user') as Map<dynamic, dynamic>;
        _user = MockUser.fromMap(userData);
      }
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock validation: các tài khoản demo
      final mockAccounts = {
        'student1@example.com': 'password123',
        'student2@example.com': 'password123',
        'demo@test.com': 'demo123',
      };

      if (!mockAccounts.containsKey(email.trim())) {
        throw Exception('Email không tồn tại. Hãy đăng ký tài khoản mới.');
      }

      if (mockAccounts[email.trim()] != password) {
        throw Exception('Mật khẩu không chính xác.');
      }

      // Tạo mock user
      _user = MockUser(
        uid: email.hashCode.toString(),
        email: email.trim(),
        displayName: 'Sinh viên ${email.split('@')[0]}',
      );

      // Lưu vào Hive
      await Hive.box('auth_user').put('current_user', _user!.toMap());
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullname,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Validate
      if (email.trim().isEmpty || !email.contains('@')) {
        throw Exception('Email không hợp lệ');
      }
      if (password.length < 6) {
        throw Exception('Mật khẩu phải có ít nhất 6 ký tự');
      }
      if (fullname.trim().isEmpty) {
        throw Exception('Vui lòng nhập tên');
      }

      // Tạo mock user mới
      _user = MockUser(
        uid: email.hashCode.toString(),
        email: email.trim(),
        displayName: fullname.trim(),
      );

      // Lưu vào Hive
      await Hive.box('auth_user').put('current_user', _user!.toMap());
      _error = null;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Xóa user từ Hive
      await Hive.box('auth_user').delete('current_user');
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}