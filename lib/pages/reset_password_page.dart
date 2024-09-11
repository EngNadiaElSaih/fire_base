import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_elevated_button.dart';
import 'package:flutter_application_1/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart'; // استيراد Firebase Authentication

class ResetPasswordPage extends StatefulWidget {
  static const String id = 'resetPassword';
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController =
      TextEditingController(); // للتحكم في إدخال البريد الإلكتروني
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // إنشاء مثيل لـ FirebaseAuth

  // وظيفة لإرسال رابط إعادة تعيين كلمة المرور
  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('A password reset link has been sent to your email'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextFormField(
                controller:
                    _emailController, // ربط الحقل بـ TextEditingController
                hintText: 'Demo@gmail.com',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomElevatedButton(
                onPressed: _resetPassword, // استدعاء الوظيفة عند الضغط على الزر
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
