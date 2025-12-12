// lib/features/authentication/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.black),
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    "Tạo tài khoản mới",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Bắt đầu quản lý thời khóa biểu ngay hôm nay!",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
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

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _fullnameCtrl,
                          hint: "Họ và tên",
                          icon: Icons.person_outline,
                          validator: (v) => v!.trim().isEmpty ? "Vui lòng nhập họ tên" : null,
                        ),
                        const SizedBox(height: 20),

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
                        const SizedBox(height: 20),

                        CustomTextField(
                          controller: _confirmPassCtrl,
                          hint: "Nhập lại mật khẩu",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (v) => v != _passCtrl.text ? "Mật khẩu không khớp" : null,
                        ),
                        const SizedBox(height: 32),

                        CustomButton(
                          text: "Đăng ký ngay",
                          isLoading: auth.isLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              auth.register(
                                fullname: _fullnameCtrl.text.trim(),
                                email: _emailCtrl.text.trim(),
                                password: _passCtrl.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Đã có tài khoản? ", style: TextStyle(color: Colors.grey[700])),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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