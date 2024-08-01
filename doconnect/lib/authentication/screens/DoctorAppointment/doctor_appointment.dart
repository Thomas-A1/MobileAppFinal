import 'package:doconnect/data/repositories/authentication_repository.dart';
import 'package:doconnect/data/repositories/doctors/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorId = AuthenticationRepository.instance.authUser?.uid;

    if (doctorId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Appointments')),
        body: Center(child: const Text('User not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DoctorRepository.instance.fetchAppointmentsForDoctor(doctorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found'));
          } else {
            final appointments = snapshot.data!;

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text('Patient: ${appointment['userName']}'),
                  subtitle: Text('Date: ${appointment['date']}, Time: ${appointment['time']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
