class ApiService {
  // Mock users (tài khoản test sẵn)
  final Map<String, Map<String, dynamic>> _mockUsers = {
    'test@example.com': {
      'password': 'password123',
      'fullname': 'Test User',
      'studentCode': '123456',
      'phone': null,
    },
  };

  Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));  // Giả lập delay
    if (_mockUsers.containsKey(email) && _mockUsers[email]!['password'] == password) {
      return {
        'token': 'mock_token_$email',
        'user': {
          'user_id': 1,
          'fullname': _mockUsers[email]!['fullname'],
          'email': email,
          'phone': _mockUsers[email]!['phone'],
        }
      };
    } else {
      throw Exception('Email hoặc mật khẩu không đúng');
    }
  }

  Future<Map<String, dynamic>> mockRegister(String fullname, String studentCode, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_mockUsers.containsKey(email)) {
      throw Exception('Email đã tồn tại');
    }
    _mockUsers[email] = {
      'password': password,
      'fullname': fullname,
      'studentCode': studentCode,
      'phone': null,
    };
    return {
      'token': 'mock_token_$email',
      'user': {
        'user_id': _mockUsers.length,
        'fullname': fullname,
        'email': email,
        'phone': null,
      }
    };
  }
}