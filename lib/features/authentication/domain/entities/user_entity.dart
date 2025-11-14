class UserEntity {
  final int? userId;
  final String fullname;
  final String email;
  final String? phone;

  UserEntity({
    this.userId,
    required this.fullname,
    required this.email,
    this.phone,
  });
}