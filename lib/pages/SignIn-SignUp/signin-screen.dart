import 'package:adopt_a_pet/All-Constants/global_variable.dart';
import 'package:adopt_a_pet/pages/SignIn-SignUp/sigin-google-controller.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../All-Constants/color_constants.dart';
import '../../All-Constants/size_constants.dart';
import '../../model/user-model.dart';
import '../../router/Navigate-Route.dart';
import '../../widgets/Loading-Indicator.dart';
import '../../widgets/Toast-Message.dart';
import '../../widgets/animation-item-builder.dart';
import '../../widgets/rectangular_button.dart';
import '../../widgets/rectangular_input_field.dart';
import '../Home/home-screen.dart';
import 'components/header-signin.dart';
import 'components/password-input-field.dart';
import 'components/social.dart';

part 'signin-controller-extension.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  int itemsCount = 0;
  List<Widget> icon = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userModel;
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  errorMessage(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  void initState() {
    icon = [
      Center(
        child: Text(
          'Adopt A Pet',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(
                color: AppColors.logoColor,
                letterSpacing: 5,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const HeaderSignIn('SIGN IN'),
      InputFieldsNameEmail(
        sufixIcon: null,
        controller: emailController,
        textInputType: TextInputType.emailAddress,
        hintText: 'Email',
        icon: const Icon(
          Icons.email_rounded,
          color: Colors.green,
        ),
        obscureText: false,
        onChanged: (val) {},
        validator: (value) {
          if (value!.isEmpty) {
            return ("Email  is required");
          }
        },
      ),
      PasswordInputField(
        passwordController: passwordController,
      ),
      const SizedBox(
        height: Sizes.appPadding / 2,
      ),
      RectangularButton(
          text: 'Sign In',
          press: () {
            if (emailController.text.trim().isEmpty) {
              displayErrorMessage("Email is required.");
            } else if (!emailController.text.contains('@')) {
              displayErrorMessage("Invalid email format.");
            } else if (passwordController.text.trim().isEmpty) {
              displayErrorMessage("Password is required.");
            } else {
              startShowLoadingView();
              signIn();
            }
          }),
      const SizedBox(
        height: Sizes.dimen_40 / 2,
      ),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(12),
          backgroundColor: Colors.white,
        ),
        onPressed: () async {
          await signInWithFacebook();
          // FirebaseService service = FirebaseService();
          // try {
          //   await service.signInWithFacebook();
          //   gotoHomeScreen();
          // } catch (e) {
          //   if (e is FirebaseAuthException) {
          //     displayErrorMessage(e.message!);
          //   }
          // }
        },
        icon: Image.asset('asset/images/facebook.png'),
        label: const Text("Logins with Facebook"),
      ),
      const SizedBox(
        height: Sizes.appPadding / 2,
      ),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.all(12),
          backgroundColor: Colors.white,
        ),
        onPressed: () async {
          signInwithGoogle();
          // FirebaseService service = FirebaseService();
          // try {
          //   await service.signInwithGoogle();
          //   gotoHomeScreen();
          // } catch (e) {
          //   if (e is FirebaseAuthException) {
          //     displayErrorMessage(e.message!);
          //   }
          // }
        },
        icon: Image.asset('asset/images/google.png'),
        label: const Text(
          "Login with Google     ",
        ),
      ),
      const SizedBox(
        height: Sizes.dimen_40 / 2,
      ),
      const Social(
        login: true,
      ),
    ];

    itemsCount = icon.length;

    Future.delayed(Duration(milliseconds: 1000) * 5, () {
      if (!mounted) {
        return;
      }
      setState(() {
        if (icon.length > itemsCount) {
          itemsCount += 7;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LiveList(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          showItemInterval: Duration(milliseconds: 200),
          showItemDuration: Duration(milliseconds: 750),
          // showItemInterval: Duration(milliseconds: 150),
          // showItemDuration: Duration(milliseconds: 250),
          visibleFraction: 0.001,
          itemCount: itemsCount,
          itemBuilder: animationItemBuilder((index) => icon[index])),
    );
  }
}
