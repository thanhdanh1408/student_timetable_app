import 'package:student_timetable_app/core/services/api_service.dart';
import 'package:student_timetable_app/core/services/local_storage_service.dart';
import 'package:student_timetable_app/features/authentication/data/models/user_model.dart';
import 'package:student_timetable_app/features/authentication/domain/entities/user_entity.dart';
import 'package:student_timetable_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService = ApiService();  // Mock
  final LocalStorageService localStorage = LocalStorageService();

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await apiService.mockLogin(email, password);  // Mock
    await localStorage.saveToken(response['token'] as String);
    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }

  @override
  Future<UserEntity> register(String fullname, String studentCode, String email, String password) async {
    final response = await apiService.mockRegister(fullname, studentCode, email, password);  // Sử dụng mockRegister mới
    await localStorage.saveToken(response['token'] as String);
    return UserModel.fromJson(response['user'] as Map<String, dynamic>);
  }
}