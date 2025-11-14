class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email không được để trống';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Mật khẩu không được để trống';
    if (value.length < 6) return 'Mật khẩu phải ít nhất 6 ký tự';
    return null;
  }

  // Thêm validate fullname, student code sau
}