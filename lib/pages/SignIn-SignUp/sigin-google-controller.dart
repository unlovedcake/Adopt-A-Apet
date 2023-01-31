import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../All-Constants/global_variable.dart';
import '../../model/user-model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) async {
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
            .then((uid) async {});
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance
        .login(permissions: ['email', 'public_profile', 'user_birthday']);

    print(loginResult.accessToken!.token);
    print("FACEBOOK");

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData = await FacebookAuth.instance.getUserData();

    //userEmail = userData['email'];

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  // Future signInWithFacebook() async {
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     final AuthCredential facebookCredential =
  //         FacebookAuthProvider.credential(result.accessToken!.token);
  //     final userCredential = await _auth.signInWithCredential(facebookCredential).then((val) {
  //       print("FACEBOOK SIGN IN");
  //     });
  //
  //     // final LoginResult result = await FacebookAuth.instance.login();
  //     // switch (result.status) {
  //     //   case LoginStatus.success:
  //     //     final AuthCredential facebookCredential =
  //     //         FacebookAuthProvider.credential(result.accessToken!.token);
  //     //     final userCredential = await _auth.signInWithCredential(facebookCredential);
  //     //     return Resource(status: Status.Success);
  //     //   case LoginStatus.cancelled:
  //     //     return Resource(status: Status.Cancelled);
  //     //   case LoginStatus.failed:
  //     //     return Resource(status: Status.Error);
  //     //   default:
  //     //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     throw e;
  //   }
  // }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
