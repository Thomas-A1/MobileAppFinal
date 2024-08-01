import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:doconnect/data/repositories/authentication_repository.dart';
import 'package:doconnect/helpers/network_manager.dart';
import 'package:doconnect/Google-SignIn/controllers/user_controller.dart';
import 'package:doconnect/utils/loaders/loaders.dart';
import 'package:doconnect/utils/popups/full_screen_loader.dart';

class LoginController extends GetxController {
  //Variables
  final rememberMe = false.obs;
  final hidepassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());
  // Email and Password Sign In
  Future<void> emailAndPasswordSignIn() async {
    try {
      FullScreenLoader.openLoadingDialog(
          "Signing you in...", 'assets/images/animations/docer.json');

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Save data if rememberMe is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login User using email and Password Authentication
      final userCredentials = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Ooops...', message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      print("Signing in with Google...");
      FullScreenLoader.openLoadingDialog(
        'Signing you in...',
        'assets/images/animations/Loading.json',
      );

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
          title: 'Ooops...',
          message: 'No internet connection',
        );
        return;
      }

      // Google Authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInwithGoogle();

      // Save record
      await userController.SaveUserRecord(userCredentials);

      FullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Ooops...', message: e.toString());
    }
  }
}