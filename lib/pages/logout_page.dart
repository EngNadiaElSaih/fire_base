import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutPage extends StatelessWidget {
  static const String id = 'LogoutPage';

  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context
                .read<AuthCubit>()
                .logout(); // استدعاء تسجيل الخروج من AuthCubit
            Navigator.of(context).pushReplacementNamed(
                '/LoginPage'); // توجيه المستخدم إلى صفحة تسجيل الدخول بعد الخروج
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
