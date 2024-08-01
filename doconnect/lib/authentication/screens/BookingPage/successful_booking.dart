import 'package:doconnect/LandingPage/landing_page.dart';
import 'package:doconnect/utils/Navigation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Lottie.asset('assets/images/animations/success.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Successfully Booked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            //back to home page
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () =>
                      Get.to(() => NavigationMenu()), // Use GetX navigation here
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Border radius
                    ),
                  ),
                  child: const Text(
                    'Back to Home Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
