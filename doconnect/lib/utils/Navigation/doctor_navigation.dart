import 'package:doconnect/authentication/screens/DoctorAppointment/doctor_appointment.dart';
import 'package:doconnect/authentication/screens/DoctorChat/doctorchat.dart';
import 'package:doconnect/authentication/screens/profile/doctorprofile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DoctorNavigationMenu extends StatelessWidget {
  const DoctorNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorNavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.solidCalendar), label: "Appointments"),
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.solidMessage), label: "Chat"),
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.solidUser), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class DoctorNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const AppointmentsPage(), 
    const ChatPage(),        
    const DoctorProfileScreen(), 
  ];
}