import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/data/repositories/authentication_repository.dart';
import 'package:doconnect/exceptions/firebase_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DoctorRepository extends GetxController {
  static DoctorRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to save doctor data to Firestore
  Future<void> saveDoctorRecord(UserModel user) async {
    try {
      await _db.collection("doctors").doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

    // Function to fetch doctor details based on userID
  Future<UserModel> fetchDoctorDetails() async {
    try {
      final documentSnapshot = await _db
          .collection('doctors')
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

   // Update any field in specific Users Collection
  Future<void> UpdateField(Map<String, dynamic> json) async {
    try{
      await _db.collection("doctors").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

    // Function to update user data in Firestore
  Future<void> updateUserDetails(UserModel updateuser) async{
    try {
      await _db.collection("doctors").doc(updateuser.id).update(updateuser.toJson());
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

    // Upload Images to Firebase Storage
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }



  Future<List<UserModel>> fetchDentalDoctors() async {
    return await _fetchDoctorsByExpertise('Dental');
  }

  // Fetch all doctors with Cardiology expertise
  Future<List<UserModel>> fetchCardiologyDoctors() async {
    return await _fetchDoctorsByExpertise('Cardiology');
  }

  // Fetch all doctors with Respiratory expertise
  Future<List<UserModel>> fetchRespiratoryDoctors() async {
    return await _fetchDoctorsByExpertise('Respiratory');
  }

  // Fetch all doctors with Dermatology expertise
  Future<List<UserModel>> fetchDermatologyDoctors() async {
    return await _fetchDoctorsByExpertise('Dermatology');
  }

  // Fetch all doctors with Gynecology expertise
  Future<List<UserModel>> fetchGynecologyDoctors() async {
    return await _fetchDoctorsByExpertise('Gynecology');
  }

  // Fetch all doctors with General expertise
  Future<List<UserModel>> fetchGeneralDoctors() async {
    return await _fetchDoctorsByExpertise('General');
  }

  // Private method to fetch doctors by expertise
  Future<List<UserModel>> _fetchDoctorsByExpertise(String expertise) async {
    try {
      final querySnapshot = await _db
          .collection('doctors')
          .where('expertise', isEqualTo: expertise)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching doctors by expertise $expertise: $e');
      return [];
    }
  }

  Future<void> addFavorite(String doctorId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null) {
        throw 'User not authenticated';
      }

      final userDocRef = _db.collection('Users').doc(userId);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw 'User not found';
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final favorites = List<String>.from(userData['favorites'] ?? []);

      if (!favorites.contains(doctorId)) {
        favorites.add(doctorId);
        await userDocRef.update({'favorites': favorites});
      }
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Remove a doctor from the user's favorites
  Future<void> removeFavorite(String doctorId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null) {
        throw 'User not authenticated';
      }

      final userDocRef = _db.collection('Users').doc(userId);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw 'User not found';
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final favorites = List<String>.from(userData['favorites'] ?? []);

      if (favorites.contains(doctorId)) {
        favorites.remove(doctorId);
        await userDocRef.update({'favorites': favorites});
      }
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  // Check if a doctor is in the user's favorites
  Future<bool> isFavorite(String doctorId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;

      if (userId == null) {
        throw 'User not authenticated';
      }

      final userDocRef = _db.collection('Users').doc(userId);
      final userDoc = await userDocRef.get();

      if (!userDoc.exists) {
        throw 'User not found';
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final favorites = List<String>.from(userData['favorites'] ?? []);

      return favorites.contains(doctorId);
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Fetch details of a doctor by ID
  Future<UserModel> fetchDoctorDetailsById(String doctorId) async {
    try {
      final documentSnapshot = await _db.collection('doctors').doc(doctorId).get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        throw 'Doctor not found';
      }
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}