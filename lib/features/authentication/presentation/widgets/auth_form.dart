// lib/features/authentication/presentation/widgets/auth_form.dart
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final Future<void> Function({
    required String fullname,
    required String email,
    required String password,
    String? phone,
  }) onSubmit;
  final bool isLoading;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        fullname: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Họ tên – chỉ hiện khi đăng ký
          if (!widget.isLogin) ...[
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Họ và tên",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              validator: (v) => v!.isEmpty ? "Vui lòng nhập họ tên" : null,
            ),
            const SizedBox(height: 16),
          ],

          // Email
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            validator: (v) {
              if (v!.isEmpty) return "Vui lòng nhập email";
              if (!v.contains('@')) return "Email không hợp lệ";
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Mật khẩu
          TextFormField(
            controller: _passCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Mật khẩu",
              prefixIcon: Icon(Icons.lock_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            validator: (v) => v!.length < 6 ? "Mật khẩu ít nhất 6 ký tự" : null,
          ),
          const SizedBox(height: 16),

          // Nhập lại mật khẩu – chỉ hiện khi đăng ký
          if (!widget.isLogin)
            TextFormField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Nhập lại mật khẩu",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              validator: (v) => v != _passCtrl.text ? "Mật khẩu không khớp" : null,
            ),

          const SizedBox(height: 24),

          // Nút Submit
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      widget.isLogin ? "Đăng nhập" : "Đăng ký",
                      style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}