import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/course/course_bloc.dart';
import 'package:flutter_application_1/blocs/lecture/lecture_bloc.dart';
import 'package:flutter_application_1/cubit/auth_cubit.dart';
import 'package:flutter_application_1/firebase_options.dart';

import 'package:flutter_application_1/pages/course_details_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/onboarding_page.dart';
import 'package:flutter_application_1/pages/reset_password_page.dart';
import 'package:flutter_application_1/pages/signup_page.dart';
import 'package:flutter_application_1/pages/splash_page.dart';
import 'package:flutter_application_1/services/pref.service.dart';
import 'package:flutter_application_1/utils/color_utilis.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تحميل ملف .env أولاً
  try {
    await dotenv.load(fileName: ".env");
    print("Dotenv file loaded successfully");
  } catch (e) {
    print("Failed to load .env file: $e");
  }

  await PreferencesService.init();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (ctx) => AuthCubit()),
      BlocProvider(create: (ctx) => CourseBloc()),
      BlocProvider(create: (ctx) => LectureBloc()),
    ],
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
        final dynamic data = settings.arguments;
        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => LoginPage());
          case SignUpPage.id: // هنا تتوقع أن يكون id مكتوب بالشكل الصحيح
            return MaterialPageRoute(builder: (context) => SignUpPage());

          case ResetPasswordPage.id:
            return MaterialPageRoute(builder: (context) => ResetPasswordPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(builder: (context) => OnBoardingPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => HomePage());
          case CourseDetailsPage.id:
            return MaterialPageRoute(
                builder: (context) => CourseDetailsPage(
                      course: data,
                    ));

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
