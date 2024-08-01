import 'package:doconnect/data/repositories/doctors/doctor_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/utils/loaders/loaders.dart';
import 'package:image_picker/image_picker.dart';

class DoctorController extends GetxController {
  static DoctorController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final doctorRepository = Get.put(DoctorRepository());


  Rx<UserModel> doctor = UserModel.empty().obs;
  RxList<UserModel> favoriteDoctors = <UserModel>[].obs;
  RxBool isFav = false.obs;



  @override
  void onInit() {
    super.onInit();
    fetchdoctorRecords();
  }

  // Fetch Doctor Records
  Future<void> fetchdoctorRecords() async {
    try {
      final user = await doctorRepository.fetchDoctorDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }
  }


  // Fetch Specific Doctor Details
Future<void> fetchSpecificDoctorDetails(String doctorId) async {
  try {
    final details = await doctorRepository.fetchDoctorDetailsById(doctorId);
    doctor.value = details; 
    // Determine if the doctor is favorited
    isFav.value = await doctorRepository.isFavorite(doctorId);
  } catch (e) {
    doctor.value = UserModel.empty(); 
  }
}



void setDoctor(UserModel newDoctor) {
  doctor.value = newDoctor;
}


void toggleFavorite() async {
  try {
    final doctorId = doctor.value.id; // Access the ID from UserModel
    isFav.value = !isFav.value;
    if (isFav.value) {
      await doctorRepository.addFavorite(doctorId);
    } else {
      await doctorRepository.removeFavorite(doctorId);
    }
  } catch (e) {
    // Handle any errors
  }
}


  

  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // First Update Rx and then check if user data is already stored. If not store new data
      await fetchdoctorRecords();

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
            userType: 'doctor',
          );

          // Save user data
          await doctorRepository.saveDoctorRecord(user);
        }
      }
    } catch (e) {
      Loaders.warningSnackBar(
          title: 'Data not saved',
          message: 'Something went wrong trying to save');
    }
  }

  // Upload User Profile Picture
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
        final imageUrl = await doctorRepository.uploadImage(
            'Doctors/images/Profile/', image);

        // Update user image into record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await doctorRepository.UpdateField(json);

        // Update the observable user
        user.update((user) {
          user?.profilePicture = imageUrl;
        });

        user.value.profilePicture = imageUrl;
        Loaders.successSnackBar(
            title: "Congrats", message: "Profile updated successfully");
      }
    } catch (e) {
      Loaders.errorSnackBar(title: "Oh no...", message: e.toString());
    }
  }

  // Update Expertise
  Future<void> updateExpertise(String? expertise) async {
    if (expertise == null || expertise.isEmpty) return;

    try {
      // Update local model
      user.update((user) {
        user?.expertise = expertise;
      });

      // Update Firestore
      Map<String, dynamic> json = {'expertise': expertise};
      await doctorRepository.UpdateField(json);

      Loaders.successSnackBar(
          title: "Updated", message: "Expertise updated successfully");
    } catch (e) {
      Loaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }


  Future<void> fetchFavoriteDoctors() async {
    try {
      final userId = user.value.id; // Get the current user's ID
      final doctors = await doctorRepository.fetchFavoriteDoctors(userId);
      favoriteDoctors.value = doctors;
    } catch (e) {
      print('Error fetching favorite doctors: $e');
    }
  }
}
