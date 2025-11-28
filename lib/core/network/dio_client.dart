// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;
  DioClient._internal();

  late final Dio dio;

  void init() {
    String baseUrl;
    if (kIsWeb) {
      // Web: dùng localhost
      baseUrl = "http://localhost/student_timetable_api/";
    } else {
      // Android emulator: dùng 10.0.2.2
      baseUrl = "http://10.0.2.2/student_timetable_api/";
      // Device thật: dùng IP máy bạn (192.168.1.x)
      // baseUrl = "http://192.168.1.100/student_timetable_api/";
    }

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      error: true,
    ));
  }
}