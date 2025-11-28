// lib/features/authentication/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, size: 80, color: Colors.indigo),
                  ),
                  const SizedBox(height: 40),

                  // Tiêu đề
                  const Text(
                    "Chào mừng trở lại!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Đăng nhập để quản lý thời khóa biểu",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 48),

                  // Error message
                  if (auth.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        auth.error!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                      ),
                    ),
                  if (auth.error != null) const SizedBox(height: 16),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailCtrl,
                          hint: "Email sinh viên",
                          icon: Icons.email_outlined,
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Vui lòng nhập email";
                            if (!v.contains('@')) return "Email không hợp lệ";
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _passCtrl,
                          hint: "Mật khẩu",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (v) => v == null || v.length < 6 ? "Mật khẩu ít nhất 6 ký tự" : null,
                        ),
                        const SizedBox(height: 32),

                        // Nút Đăng nhập
                        CustomButton(
                          text: "Đăng nhập",
                          isLoading: auth.isLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              auth.login(_emailCtrl.text.trim(), _passCtrl.text);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Chuyển sang đăng ký
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Chưa có tài khoản? ", style: TextStyle(color: Colors.grey[700])),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: const Text(
                          "Đăng ký ngay",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}