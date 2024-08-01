import 'package:doconnect/Models/auth_model.dart';
import 'package:doconnect/Models/user_model.dart';
import 'package:doconnect/authentication/screens/BookingPage/bookingpage.dart';
import 'package:doconnect/data/repositories/doctors/doctor_controller.dart';
import 'package:doconnect/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorDetails extends StatelessWidget {
  const DoctorDetails(
      {Key? key, required this.doctorId, required this.doctor_name})
      : super(key: key);
  final String doctorId;
  final String doctor_name;

  @override
  Widget build(BuildContext context) {
    final DoctorController doctorController = Get.find<DoctorController>();

    // Fetch the specific doctor's details
    doctorController.fetchSpecificDoctorDetails(doctorId);

    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('Doctor Details'),
        leadingIcon: Icons.arrow_back,
        actions: [
          Obx(() {
            return IconButton(
              onPressed: () async {
                // Toggle favorite status
                doctorController.toggleFavorite();

                // Update UI
                Get.snackbar(
                  'Favorite Updated',
                  doctorController.isFav.value
                      ? 'Doctor added to favorites'
                      : 'Doctor removed from favorites',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: FaIcon(
                doctorController.isFav.value
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline,
                color: Colors.red,
              ),
            );
          }),
        ],
        showBackArrow: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final doctor = doctorController.doctor.value;

          if (doctor.id.isEmpty) {
            // Show loading or error message if doctor data is not available
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: <Widget>[
              AboutDoctor(
                doctor: doctor,
              ),
              DetailBody(
                doctor: doctor,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Set your desired button color here
                ),
                onPressed: () {
                  Get.to(
                    () => BookingPage(),
                    arguments: {
                      "doctor_id": doctor.id,
                      "doctor_name": doctor_name
                    },
                  );
                },
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({Key? key, required this.doctor}) : super(key: key);

  final UserModel doctor;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundImage: doctor.profilePicture.isNotEmpty
                ? NetworkImage(doctor
                    .profilePicture) // Use NetworkImage if URL is available
                : const AssetImage('assets/images/profile.png')
                    as ImageProvider, // Use local asset image if URL is not available
          ),
          SizedBox(height: screenHeight * 0.05),
          Text(
            "Dr ${doctor.firstname} ${doctor.lastname}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: screenWidth * 0.75,
            child: const Text(
              'International Medical University, Malaysia, Ashesi (Royal College of Physicians, Ghana)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: screenWidth * 0.75,
            child: const Text(
              'Korle-Bu General Hospital',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key, required this.doctor}) : super(key: key);

  final UserModel doctor;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 25,
          ),
          DoctorInfo(
            exp: doctor
                .expertise, // Ensure that this property exists in UserModel
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          const Text(
            'About Doctor',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Dr. ${doctor.firstname} ${doctor.lastname} is an experienced ${doctor.userType} Specialist at Sarawak, graduated since 2008, and completed his/her training at Sungai Buloh General Hospital.',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({Key? key, required this.exp}) : super(key: key);

  final String exp; // Changed from int to String

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 15),
        InfoCard(
          label: 'Experiences',
          value: '$exp', // Directly use exp as String
        ),
        const SizedBox(width: 15),
        const InfoCard(
          label: 'Rating',
          value: '4.6',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.greenAccent,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
