import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:student_timetable_app/core/utils/helpers.dart';
import 'package:student_timetable_app/core/utils/validators.dart';
import 'package:student_timetable_app/features/authentication/presentation/providers/auth_provider.dart';
import 'package:student_timetable_app/shared/widgets/custom_button.dart';
import 'package:student_timetable_app/shared/widgets/custom_textfield.dart';
import 'package:student_timetable_app/shared/widgets/loading_indicator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _studentCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _studentCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showSnackBar(context, 'Mật khẩu không khớp');
        return;
      }
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.register(
        _fullnameController.text.trim(),
        _studentCodeController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, authProvider.errorMessage!);
        // Clear error (sẽ thêm method sau)
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book, size: 80, color: Colors.black),
                  const SizedBox(height: 16),
                  const Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tạo tài khoản mới để bắt đầu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  if (authProvider.isLoading)
                    const LoadingIndicator()
                  else
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: 'Họ và tên',
                            controller: _fullnameController,
                            validator: (value) => value!.isEmpty ? 'Họ tên không được để trống' : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'Mã sinh viên',
                            controller: _studentCodeController,
                            validator: (value) => value!.isEmpty ? 'Mã sinh viên không được để trống' : null,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'Email',
                            controller: _emailController,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'Mật khẩu',
                            controller: _passwordController,
                            validator: Validators.validatePassword,
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: 'Nhập lại mật khẩu',
                            controller: _confirmPasswordController,
                            validator: Validators.validatePassword,
                            obscureText: true,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(text: 'Đăng ký', onPressed: _register),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Đã có tài khoản? Đăng nhập'),
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