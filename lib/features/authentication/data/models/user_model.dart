import 'package:student_timetable_app/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    int? userId,
    required String fullname,
    required String email,
    String? phone,
  }) : super(userId: userId, fullname: fullname, email: email, phone: phone);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      fullname: json['fullname'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullname,
      'email': email,
      'phone': phone,
    };
  }
}