import 'package:flutter/material.dart';
import 'package:doconnect/utils/components/doctor_card.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, String>> favoriteDoctors = [
    {
      'name': 'Dr. Jane Doe',
      'specialty': 'Cardiologist',
      'profilePicture': 'assets/images/doctor1.png'
    },
    {
      'name': 'Dr. John Smith',
      'specialty': 'Neurologist',
      'profilePicture': 'assets/images/doctor2.png'
    },
    // Add more dummy data here
  ];

  FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Favorite Doctors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = favoriteDoctors[index];
                  return DoctorCard(
                    doctor: doctor,
                    isFav: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
