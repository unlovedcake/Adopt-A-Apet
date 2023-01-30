part of 'signin-screen.dart';

extension ExtensionSigninController on SignInScreenState {
  void displayErrorMessage(String message) {
    ToastMessage.showMessage(message, context,
        offSetBy: 0,
        position: const StyledToastPosition(align: Alignment.topCenter, offset: 200.0),
        isShapedBorder: false);
  }

  void dismissLoadingView() {
    Navigator.pop(context);
  }

  void startShowLoadingView() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return LoadingIndicator();
      },
    );
  }

  void gotoHomeScreen() {
    Navigator.of(context).push(pageRouteAnimate(const HomeScreen()));
  }

  signIn() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('table-user')
          .where('email', isEqualTo: emailController.text)
          .get();
      final List<DocumentSnapshot> document = result.docs;

      await _auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((id) async {
        if (document.isNotEmpty) {
          dismissLoadingView();
          gotoHomeScreen();
          // String? token = await FirebaseMessaging.instance.getToken();
          //
          // DocumentSnapshot documentSnapshot = document[0];
          // UserModel userData = UserModel.fromMap(documentSnapshot);
          //
          // // userLoggedIn = UserModel(
          // //     docID: userData.docID ?? "",
          // //     firstName: userData.firstName,
          // //     lastName: userData.lastName ?? "",
          // //     address: userData.address ?? "",
          // //     phoneNumber: userData.phoneNumber ?? "",
          // //     email: userData.email,
          // //     gender: userData.gender ?? "",
          // //     birthDate: userData.birthDate ?? "",
          // //     userType: userData.userType ?? "",
          // //     imageUrl: userData.imageUrl);
          //
          // await FirebaseFirestore.instance
          //     .collection("table-user")
          //     .doc(userData.docID ?? "")
          //     .update({'token': token}).then((_) {
          //   dismissLoadingView();
          //   gotoHomeScreen();
          // });
        }
      });
    } on FirebaseAuthException catch (error) {
      Navigator.of(context).pop();

      switch (error.code) {
        case "invalid-email":
          displayErrorMessage("Your email address appears to be invalid.");
          break;
        case "wrong-password":
          displayErrorMessage("Your password is wrong..");

          break;
        case "user-not-found":
          displayErrorMessage("User with this email doesn't exist");

          break;
        case "user-disabled":
          displayErrorMessage("User with this email has been disabled.");

          break;
        case "too-many-requests":
          displayErrorMessage("Too many requests.");

          break;
        case "operation-not-allowed":
          displayErrorMessage("Signing in with Email and Password is not enabled.");

          break;
        default:
          displayErrorMessage("Check Your Internet Access.");
      }
    }
  }

  Future<String?> signInwithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) async {
        print("1");
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('table-user')
            .where('email', isEqualTo: googleSignInAccount.email.toString())
            .get();
        final List<DocumentSnapshot> document = result.docs;

        if (document.isEmpty) {
          userLoggedIn = UserModel(
              docID: googleSignInAccount.id.toString(),
              firstName: googleSignInAccount.displayName.toString(),
              lastName: "",
              address: "",
              phoneNumber: "",
              email: googleSignInAccount.email.toString(),
              gender: "",
              birthDate: "",
              userType: "user",
              imageUrl: googleSignInAccount.photoUrl.toString());
          await FirebaseFirestore.instance
              .collection("table-user")
              .add(userLoggedIn?.toMap() ?? {})
              .then((uid) async {
            gotoHomeScreen();
          });
        } else {
          print("2");
          gotoHomeScreen();
        }
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential = await _auth.signInWithCredential(facebookCredential).then((val) async {
        print("FACEBOOK SIGN IN");
        final userData = await FacebookAuth.instance.getUserData();

        print(userData['email'].toString());
        print("FACEBOOK SIGN IN");
        gotoHomeScreen();
      });

      // final LoginResult result = await FacebookAuth.instance.login();
      // switch (result.status) {
      //   case LoginStatus.success:
      //     final AuthCredential facebookCredential =
      //         FacebookAuthProvider.credential(result.accessToken!.token);
      //     final userCredential = await _auth.signInWithCredential(facebookCredential);
      //     return Resource(status: Status.Success);
      //   case LoginStatus.cancelled:
      //     return Resource(status: Status.Cancelled);
      //   case LoginStatus.failed:
      //     return Resource(status: Status.Error);
      //   default:
      //     return null;
    } on FirebaseAuthException catch (e) {
      throw e;
    }

    // // Trigger the sign-in flow
    // final LoginResult loginResult = await FacebookAuth.instance
    //     .login(permissions: ['email', 'public_profile', 'user_birthday']);
    //
    // print(loginResult.accessToken!.token);
    // print("FACEBOOK");
    //
    // // Create a credential from the access token
    // final OAuthCredential facebookAuthCredential =
    //     FacebookAuthProvider.credential(loginResult.accessToken!.token);
    //
    // final userData = await FacebookAuth.instance.getUserData();
    //
    //
    // //userEmail = userData['email'];
    //
    // // Once signed in, return the UserCredential
    // return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
