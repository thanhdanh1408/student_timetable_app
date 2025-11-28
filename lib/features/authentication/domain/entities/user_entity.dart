// lib/features/authentication/domain/entities/user_entity.dart
import 'package:hive/hive.dart';

part 'user_entity.g.dart'; // ĐÚNG TÊN FILE

@HiveType(typeId: 0)
class UserEntity extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final String fullname;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phone;

  UserEntity({
    required this.userId,
    required this.fullname,
    required this.email,
    this.phone,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      userId: json['user_id'],
      fullname: json['fullname'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}