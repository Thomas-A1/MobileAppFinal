import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/data/repositories/user/user_repository.dart';
import 'package:doconnect/utils/loaders/loaders.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecords();
  }

  // Fetch User Records
  Future<void> fetchUserRecords() async {
    try {
      final userData = await userRepository.fetchUserDetails();
      user.value = userData; // Update user observable
    } catch (e) {
      print('Error fetching user data: $e');
      user.value = UserModel.empty(); // Set to empty if fetch fails
    }
  }
  
  Future<void> SaveUserRecord(UserCredential? userCredentials) async {
    try {
      // First Update Rx and then check if user data is already stored. If not store new data
      await fetchUserRecords();

      // If no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // Map data
          final user = UserModel(
            id: userCredentials.user!.uid,
            firstname: nameParts[0],
            lastname:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            username: username,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );

          // Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      Loaders.warningSnackBar(
          title: 'Data not saved',
          message: 'Something went wrong trying to save');
    }
  }

  // Upload User Profile

Future<void> uploadUserProfilePicture() async {
  try {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 512,
      maxWidth: 512,
    );

    if (image != null) {
      final imageUrl = await userRepository.uploadImage('Users/images/Profile/', image);

      // Update user Image into Record
      Map<String, dynamic> json = {'ProfilePicture': imageUrl};
      await userRepository.UpdateField(json);

        // Update the observable user
        user.update((user) {
          user?.profilePicture = imageUrl;
        });

      user.value.profilePicture = imageUrl;
      Loaders.successSnackBar(
        title: "Congrats", 
        message: "Profile Updated successfully"
      );
    }
  } catch (e) {
    Loaders.errorSnackBar(title: "ohwww...", message: e.toString());
  }
}
}