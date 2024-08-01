import 'package:doconnect/data/repositories/doctors/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/authentication/screens/signup/verify_email.dart';
import 'package:doconnect/data/repositories/authentication_repository.dart';
import 'package:doconnect/data/repositories/user/user_repository.dart';
import 'package:doconnect/helpers/network_manager.dart';
import 'package:doconnect/utils/loaders/loaders.dart';
import 'package:doconnect/utils/popups/full_screen_loader.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final userType = 'user'.obs;

  // Variables
  final hidePassword = true.obs; // Observable for hiding/showing Password
  final privacypolicy = false.obs;
  final email = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // SignUp
  void signUp() async {
    try {
      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove Loader
        // FullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacypolicy.value) {
        Loaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create your account, you must read and accept our Privacy Policy Terms of Use',
        );
        return;
      }

      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'We are processing your information...', 'assets/images/animations/docer.json');

      // Register user in the firebase Authentication and firebase
      final userCredential =
          await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Save Authenticated user data in the Firebase Firestore
      final newuser = UserModel(
        id: userCredential.user!.uid,
        firstname: firstname.text.trim(),
        lastname: lastname.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
        userType: userType.value,
      );

      print('User Type during signup: ${userType.value}');

      // Save User Record based on User Type
      if (userType.value == 'user') {
        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserRecord(newuser);
      }
      else if (userType.value == 'doctor') {
        final doctorRepository = Get.put(DoctorRepository());
        await doctorRepository.saveDoctorRecord(newuser);
      }


      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show success Message
      Loaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your account has been created! Verify your email to continue',
      );

      // Move to verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      //Show some Generioc Error to the user
      Loaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    
  }
}
