import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/data/repositories/doctors/doctor_repository.dart';
import 'package:doconnect/utils/components/doctor_card.dart';
import 'package:flutter/material.dart';

class DoctorsListPage extends StatefulWidget {
  final String category;

  DoctorsListPage({required this.category});

  @override
  _DoctorsListPageState createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  List<UserModel> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorsByCategory(widget.category);
  }

  Future<void> fetchDoctorsByCategory(String category) async {
    final doctorRepo = DoctorRepository.instance;

    try {
      List<UserModel> fetchedDoctors;
      switch (category) {
        case 'Cardiology':
          fetchedDoctors = await doctorRepo.fetchCardiologyDoctors();
          break;
        case 'Respirations':
          fetchedDoctors = await doctorRepo.fetchRespiratoryDoctors();
          break;
        case 'Dermatology':
          fetchedDoctors = await doctorRepo.fetchDermatologyDoctors();
          break;
        case 'Gynecology':
          fetchedDoctors = await doctorRepo.fetchGynecologyDoctors();
          break;
        case 'Dental':
          fetchedDoctors = await doctorRepo.fetchDentalDoctors();
          break;
        default:
          fetchedDoctors = await doctorRepo.fetchGeneralDoctors();
      }
      setState(() {
        doctors = fetchedDoctors;
      });
    } catch (e) {
      // Handle errors here
      print('Error fetching doctors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Doctors'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return DoctorCard(
            doctor: {
              'id': doctor.id,
              'doctor_profile': doctor.profilePicture, // Use actual profile picture URL
              'doctor_name': doctor.firstname, // Assuming `firstname` is the doctor's name
              'category': doctor.expertise,
            },
            isFav: false, // Replace with actual favorite check if needed
          );
        },
      ),
    );
  }
}