import 'package:doconnect/Google-SignIn/controllers/user_controller.dart';
import 'package:doconnect/data/repositories/user/user_repository.dart';
import 'package:doconnect/helpers/network_manager.dart';
import 'package:doconnect/utils/Navigation/navigation_menu.dart';
import 'package:doconnect/utils/loaders/loaders.dart';
import 'package:doconnect/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instane => Get.find();

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  // Fetch User Record
  Future<void> initializeNames() async {
    firstname.text = userController.user.value.firstname;
    lastname.text = userController.user.value.lastname;
  }
  
  Future<void> updateUserName() async {
    try {
      FullScreenLoader.openLoadingDialog("Updating user information...", "assets/images/animations/docer.json");

      // Checking internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateUserNameFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Update user's first and Lastname in the firebase firestore
      Map<String, dynamic> name = {'firstname': firstname.text.trim(), 'lastname': lastname.text.trim()};
      // Update user's first and last name
      await userRepository.UpdateField(name); 

      // Update the Rx user value
      userController.user.value.firstname = firstname.text.trim();
      userController.user.value.lastname = lastname.text.trim();

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success SnackBar
      Loaders.successSnackBar(title: "Congratulations", message: "Your name has been updated successfully");

      // Move to previous screen
      Get.offAll(() => const NavigationMenu());
    } catch(e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: "Ooops...", message: e.toString());
    }
  }
}