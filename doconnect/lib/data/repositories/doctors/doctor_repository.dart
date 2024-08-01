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



  Future<void> updateDoctorAppointment(
    String doctorId, 
    String doctorName, 
    String date, 
    String day, 
    String time, 
    String userId
  ) async {
    try {
      final appointmentData = {
        'date': date,
        'day': day,
        'time': time,
        'userId': userId,
        'userName': await _getUserName(userId),
      };

      await _db.collection('doctors').doc(doctorId)
        .collection('appointments') // Appointments sub-collection
        .add(appointmentData);
    } catch (e) {
      throw 'Error updating doctor appointment: $e';
    }
  }

  Future<String> _getUserName(String userId) async {
    try {
      final userDoc = await _db.collection('Users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>;
      return userData['firstname'] ?? 'Unknown';
    } catch (e) {
      throw 'Error fetching user name: $e';
    }
  }

  // Fetch all appointments for a specific doctor
  Future<List<Map<String, dynamic>>> fetchAppointmentsForDoctor(String doctorId) async {
    try {
      final querySnapshot = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('appointments')
          .get();

      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

    Future<List<UserModel>> fetchAllDoctors() async {
    try {
      final querySnapshot = await _db.collection('doctors').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw MFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }




  Future<List<UserModel>> fetchFavoriteDoctors(String userId) async {
    try {
      // Fetch the user's document from Firestore
      final userDoc = await _db.collection('Users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // Extract the favorite doctors' IDs from the user's document
      final favorites = userDoc.data()?['favorites'] as Map<String, dynamic>?;

      if (favorites == null) {
        return []; // No favorites
      }

      // Fetch the doctors' details based on the IDs
      final doctorIds = favorites.keys.toList();
      final doctorQueries = doctorIds.map((id) =>
          _db.collection('Doctors').doc(id).get()).toList();

      final doctorDocs = await Future.wait(doctorQueries);

      // Convert the fetched documents to UserModel
      final favoriteDoctors = doctorDocs.map((doc) {
        if (doc.exists) {
          return UserModel.fromSnapshot(doc);
        } else {
          return UserModel.empty();
        }
      }).toList();

      return favoriteDoctors;
    } catch (e) {
      print('Error fetching favorite doctors: $e');
      return [];
    }
  }
}
