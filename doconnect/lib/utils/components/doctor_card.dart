import 'package:doconnect/authentication/screens/doctor_details.dart';
import 'package:doconnect/widgets/user_image.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 207, 222, 208),
          child: Row(
            children: [
              Transform(
                transform: Matrix4.translationValues(13.0, 0.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (doctor['doctor_profile'] != null &&
                            doctor['doctor_profile'].isNotEmpty)
                        ? NetworkImage(doctor[
                            'doctor_profile']) // Use NetworkImage if URL is available
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Dr ${doctor['doctor_name'] ?? 'Unknown'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${doctor['category'] ?? 'No Category'}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.star_border,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          Spacer(flex: 1),
                          Text('4.5'),
                          Spacer(flex: 1),
                          Text('Reviews'),
                          Spacer(flex: 1),
                          Text('(20)'),
                          Spacer(flex: 7),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          final doctorId = doctor['id'] as String?;

          // Debugging: Print the doctor map to check its contents
          print("Doctor Map: $doctor");
          print("Doctor ID: $doctorId");

          if (doctorId != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DoctorDetails(
                  doctorId: doctorId,
                  doctor_name : doctor['doctor_name'],
                  
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Doctor ID is not available')),
            );
          }
        },
      ),
    );
  }
}
