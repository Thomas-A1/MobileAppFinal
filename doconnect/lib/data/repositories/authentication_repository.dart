import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/utils/Navigation/doctor_navigation.dart';
import 'package:doconnect/utils/Navigation/navigation_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doconnect/LandingPage/landing_page.dart';
import 'package:doconnect/authentication/screens/login/login.dart';
import 'package:doconnect/authentication/screens/onboarding/onboarding.dart';
import 'package:doconnect/authentication/screens/signup/verify_email.dart';
import 'package:doconnect/exceptions/firebase_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Get Authenticated user data
  User? get authUser => _auth.currentUser;

  // Calling this from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Functions to show relevant Screen based on authentication
//   Future<void> screenRedirect() async {
//   final user = _auth.currentUser;
//   if (user != null) {
//     if (user.emailVerified) {
//       final doctorDoc = await _db.collection('doctors').doc(user.uid).get();

//       if (doctorDoc.exists) {
//         Get.offAll(() => DoctorNavigationMenu());
//       } else {
//         final userDoc = await _db.collection('users').doc(user.uid).get();
//         final userModel = UserModel.fromSnapshot(userDoc);

//         if (userModel.userType == 'doctor') {
//           Get.offAll(() => DoctorNavigationMenu());
//         } else {
//           Get.offAll(() => NavigationMenu());
//         }
//       }
//     } else {
//       Get.off(() => VerifyEmailScreen(email: _auth.currentUser?.email));
//     }
//   } else {
//     deviceStorage.writeIfNull('isFirstTime', true);
//     if (deviceStorage.read('isFirstTime') != true) {
//       Get.offAll(() => const LoginScreen());
//     } else {
//       Get.offAll(const onBoardingScreen());
//     }
//   }
// }

Future<void> screenRedirect() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        // Fetch user details from both collections
        final doctorDoc = await FirebaseFirestore.instance.collection('doctors').doc(user.uid).get();
        final userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

        if (doctorDoc.exists) {
          // Navigate to DoctorNavigationMenu if user is a doctor
          Get.offAll(() => DoctorNavigationMenu());
        } else if (userDoc.exists) {
          final userModel = UserModel.fromSnapshot(userDoc);
          if (userModel.userType == 'doctor') {
            Get.offAll(() => DoctorNavigationMenu());
          } else {
            Get.offAll(() => NavigationMenu());
          }
        } else {
          // Handle case where user document is not found in either collection
          Get.offAll(() => NavigationMenu());
        }
      } else {
        // Redirect to email verification screen
        Get.off(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      // Handle the case where no user is logged in
      final isFirstTime = deviceStorage.read('isFirstTime') ?? true;
      if (isFirstTime) {
        Get.offAll(() => const onBoardingScreen());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    }
  } catch (e) {
    // Handle any errors that may occur during redirection
    print('Error during screen redirect: $e');
    // Get.offAll(() => const ErrorScreen()); // Or any other error handling screen
  }
}


  /*---- Email & Password Sign-in */
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // EmailAuthentication - SignIn

  // EmailAuthentication - Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // ReAuthenticate - Reauthenticate user

  // EmailVerification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // EmailAuthentication - Forgot Password

  /*--- Federated Identity & Social Sign In */

  // GoogleAuthentication
  Future<UserCredential?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? userAccont = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await userAccont?.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Store data to firestore
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  // FacebookAuthentication

  /*--- End of Federated Identity & Social Sign In */

  //LogoutUser - Valid for any authentication
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

    Future<bool> isDoctor(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('doctors').doc(userId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Delete User - Remove User Auth and Firestore account
}
