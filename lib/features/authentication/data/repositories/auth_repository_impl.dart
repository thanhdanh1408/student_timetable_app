// lib/features/authentication/data/repositories/auth_repository_impl.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constans/api_constants.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio = DioClient.instance.dio;

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return UserEntity.fromJson(response.data['user']);
  }

  @override
  Future<UserEntity> register({
    required String fullname,
    required String email,
    required String password,
    String? phone,
  }) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: {
        'fullname': fullname,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
    return UserEntity.fromJson(response.data['user']);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return UserEntity.fromJson(response.data['user']);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiConstants.logout);
  }
}
