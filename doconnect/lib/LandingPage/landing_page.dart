import 'package:doconnect/authentication/screens/DoctorsExpertisePage/doctorsExpertise.dart';
import 'package:doconnect/data/repositories/authentication_repository.dart';
import 'package:doconnect/data/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:doconnect/Google-SignIn/controllers/user_controller.dart';
import 'package:doconnect/utils/components/appointment_card.dart';
import 'package:doconnect/utils/components/doctor_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<dynamic> favList = []; // Placeholder for favorite doctors list
  List<Map<String, dynamic>> medCat = [
    {"icon": FontAwesomeIcons.userDoctor, "category": "General"},
    {"icon": FontAwesomeIcons.heartPulse, "category": "Cardiology"},
    {"icon": FontAwesomeIcons.lungs, "category": "Respiratory"},
    {"icon": FontAwesomeIcons.hand, "category": "Dermatology"},
    {"icon": FontAwesomeIcons.personPregnant, "category": "Gynecology"},
    {"icon": FontAwesomeIcons.teeth, "category": "Dental"},
  ];

  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPage();

  }

  void _refreshPage() {
    setState(() {
      _appointmentsFuture = _fetchAppointments();
    });
    _fetchUserDetails(); // Fetch user details
  }

    void _fetchUserDetails() {
    final userController = UserController.instance;
    userController.fetchUserRecords(); // Ensure this method is implemented in UserController
  }

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    if (userId == null) {
      throw 'User not authenticated';
    }
    return UserRepository().getAppointments(userId);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final controller = UserController.instance; // Ensure proper initialization

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Obx(() {
                      final firstname = controller.user.value.firstname;
                      return Text(
                        'Welcome, ${firstname ?? 'User'}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    Obx(() {
                      final profilePicture =
                          controller.user.value.profilePicture;
                      return SizedBox(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: profilePicture.isNotEmpty
                              ? NetworkImage(profilePicture) // Use NetworkImage if URL is available
                              : AssetImage('assets/images/profile.png')
                                  as ImageProvider,
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: mediaQueryData.size.width * 0.05),
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: mediaQueryData.size.height * 0.05,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(medCat.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          // Use GetX navigation to go to DoctorsListPage
                          Get.to(() => DoctorsListPage(
                            category: medCat[index]['category'],
                          ));
                        },
                        child: Card(
                          margin: const EdgeInsets.only(right: 20),
                          color: Color.fromARGB(255, 135, 189, 163),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FaIcon(
                                  medCat[index]['icon'],
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  medCat[index]['category'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'Appointment Today',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _appointmentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No appointments found'));
                    }

                    final appointments = snapshot.data!;
                    return Column(
                      children: appointments.map((appointment) {
                        return AppointmentCard(
                          doctorId: appointment['doctorId'] ?? '',
                          doctorName: appointment['doctorName'] ?? '',
                          date: appointment['date'] ?? '',
                          day: appointment['day'] ?? '',
                          time: appointment['time'] ?? '',
                          color: Color.fromARGB(255, 216, 244, 229),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 25),
                const Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: List.generate(5, (index) {
                    return DoctorCard(
                      doctor: {
                        'doctor_profile': '', // Placeholder profile image
                        'doctor_name': 'Dr. Smith',
                        'category': 'Cardiology',
                      },
                      isFav: favList.contains(index),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshPage,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
