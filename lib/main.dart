import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/cubit/auth_cubit.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/onboarding_page.dart';
import 'package:flutter_application_1/pages/reset_password_page.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'package:flutter_application_1/pages/splash_page.dart';
import 'package:flutter_application_1/services/pref.service.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (ctx) => AuthCubit())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _CustomScrollBehaviour(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorUtility.gbScaffold,
        fontFamily: ' PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final Map? data = settings.arguments as Map?;
        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => LoginPage());
          case SignUpPage.id:
            return MaterialPageRoute(builder: (context) => SignUpPage());
          case ResetPasswordPage.id:
            return MaterialPageRoute(builder: (context) => ResetPasswordPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(builder: (context) => OnBoardingPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => HomePage());

          default:
            return MaterialPageRoute(builder: (context) => SplashPage());
        }
      },
      initialRoute: SplashPage.id,
    );
  }
}

class _CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
