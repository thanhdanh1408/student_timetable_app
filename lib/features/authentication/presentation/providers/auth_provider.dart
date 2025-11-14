import 'package:flutter/material.dart';
import 'package:student_timetable_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:student_timetable_app/features/authentication/domain/entities/user_entity.dart';
import 'package:student_timetable_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:student_timetable_app/features/authentication/domain/usecases/register_usecase.dart';
import 'package:go_router/go_router.dart';

class AuthProvider with ChangeNotifier {
  final LoginUsecase loginUsecase = LoginUsecase(AuthRepositoryImpl());
  final RegisterUsecase registerUsecase = RegisterUsecase(AuthRepositoryImpl());

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await loginUsecase(email, password);
      // Navigate to home sau đăng nhập thành công
      GoRouter.of(context).go('/home');  // Giả sử có route /home
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm vào class AuthProvider
Future<void> register(String fullname, String studentCode, String email, String password, BuildContext context) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    _user = await registerUsecase(fullname, studentCode, email, password);
    GoRouter.of(context).go('/home');  // Navigate to home
  } catch (e) {
    _errorMessage = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

// Thêm method clearError
void clearError() {
  _errorMessage = null;
  notifyListeners();
}
}