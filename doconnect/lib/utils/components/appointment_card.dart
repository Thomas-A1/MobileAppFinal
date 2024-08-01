import 'package:doconnect/data/repositories/authentication_repository.dart';
import 'package:doconnect/data/repositories/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({
    Key? key,
    required this.doctorId,
    required this.doctorName,
    required this.color, required date, required day, required time,
  }) : super(key: key);

  final String doctorId;
  final String doctorName;
  final Color color;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late Future<List<Map<String, dynamic>>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _fetchAppointments();
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _appointments,
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
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.green, // Green border color
              width: 2, // Border width
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  // Doctor's profile and name
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Dr ${widget.doctorName}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 16, 16, 16)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Doctor', // Replace with actual category
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Display appointments
                  ...appointments.map((appointment) => ScheduleCard(
                        appointment: appointment,
                      )),
                  const SizedBox(height: 25),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 221, 109, 101),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(102, 212, 126, 1),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return RatingDialog(
                                  initialRating: 1.0,
                                  title: const Text(
                                    'Rate the Doctor',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  message: const Text(
                                    'Please help us to rate this Doctor',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  image: SizedBox(
                                    width: 100, // Set your desired width
                                    height: 100, // Set your desired height
                                    child: Image.asset('assets/images/logo.png'),
                                  ),
                                  submitButtonText: 'Submit',
                                  commentHint: 'Your Reviews',
                                  onSubmitted: (response) async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    final token = prefs.getString('token') ?? '';
                                    // Handle rating submission here
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Completed',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Schedule Widget
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.appointment}) : super(key: key);

  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 156, 155, 155),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            '${appointment['day'] ?? 'Day'}, ${appointment['date'] ?? 'Date'}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              appointment['time'] ?? 'Time',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}