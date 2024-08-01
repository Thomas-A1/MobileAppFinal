import 'package:doconnect/data/repositories/doctors/doctor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditDoctorProfile extends StatelessWidget {
  const EditDoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DoctorController.instance;
    final List<String> expertiseOptions = [
      'General',
      'Cardiology',
      'Respiratory',
      'Dermatology',
      'Gynecology',
      'Dental'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expertise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select your field of expertise:'),
            const SizedBox(height: 16),
            Obx(() {
              return DropdownButton<String>(
                value: controller.user.value.expertise.isEmpty
                    ? null
                    : controller.user.value.expertise,
                hint: Text('Select Expertise'),
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.updateExpertise(newValue);
                  }
                },
                items: expertiseOptions.map((String expertise) {
                  return DropdownMenuItem<String>(
                    value: expertise,
                    child: Text(expertise),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 32),
            // ElevatedButton(
            //   onPressed: () {
            //     // Optionally, you could add a form to validate before submitting
            //   },
            //   child: Text('Save Changes'),
            // ),
          ],
        ),
      ),
    );
  }
}