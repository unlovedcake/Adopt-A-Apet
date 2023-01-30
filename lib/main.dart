import 'package:adopt_a_pet/pages/Home/home-screen.dart';
import 'package:adopt_a_pet/pages/SignIn-SignUp/signin-screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splash_view/source/presentation/pages/splash_view.dart';
import 'package:splash_view/source/presentation/widgets/done.dart';

import 'All-Constants/color_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //
      //   primarySwatch: Colors.blue,
      // ),
      home: SplashView(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Colors.white, AppColors.logoColor]),
          //loadingIndicator: const RefreshProgressIndicator(),
          logo: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset('asset/images/app-logo.png'),
          ),
          done: Done(
            const SignInScreen(),
            animationDuration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
          )),
    );
  }
}
