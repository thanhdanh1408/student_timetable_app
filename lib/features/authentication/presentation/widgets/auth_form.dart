import 'package:flutter/material.dart';
import 'package:student_timetable_app/core/utils/validators.dart';
import 'package:student_timetable_app/shared/widgets/custom_button.dart';
import 'package:student_timetable_app/shared/widgets/custom_textfield.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final String buttonText;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            hintText: 'Email',
            controller: emailController,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hintText: 'Mật khẩu',
            controller: passwordController,
            validator: Validators.validatePassword,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          CustomButton(text: buttonText, onPressed: onSubmit),
        ],
      ),
    );
  }
}