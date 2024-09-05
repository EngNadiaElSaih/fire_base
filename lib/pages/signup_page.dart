import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/auth_cubit.dart';
import 'package:flutter_application_1/widgets/auth/auth_template.widget.dart';
import 'package:flutter_application_1/widgets/custom_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'SignUpPage';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onSignUp: () async {
        if (passwordController.text == confirmPasswordController.text) {
          await context.read<AuthCubit>().signUp(
              context: context,
              emailController: emailController,
              nameController: nameController,
              passwordController: passwordController);
        } else {
          // يمكنك إضافة تنبيه بأن كلمات المرور غير متطابقة
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
        }
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // إضافة تباعد حول المحتوى
          child: Column(
            children: [
              CustomTextFormField(
                controller: nameController,
                hintText: 'Nadia El_saih',
                labelText: 'Full Name',
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: emailController,
                hintText: 'Demo@gmail.com',
                labelText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: passwordController,
                hintText: '***********',
                labelText: 'Password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: confirmPasswordController,
                hintText: '***********',
                labelText: 'Confirm Password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(height: 20), // إضافة تباعد قبل زر التسجيل
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    await context.read<AuthCubit>().signUp(
                        context: context,
                        emailController: emailController,
                        nameController: nameController,
                        passwordController: passwordController);
                  } else {
                    // عرض رسالة خطأ إذا كانت كلمات المرور غير متطابقة
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
