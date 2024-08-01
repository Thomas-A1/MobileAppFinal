import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doconnect/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:doconnect/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:doconnect/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:doconnect/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:doconnect/authentication/screens/onboarding/widgets/onboarding_skip.dart';


class onBoardingScreen extends StatelessWidget {
  const onBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create new instance of OnBoarding Controller
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(children: [
        /// Horizontal Scrollable Button
        PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: const [
            OnBoardingPage(
              image: "assets/images/onboarding_images/track_doctor.png",
              title: "Locate Specialized doctors Near You",
              subTitle:
                  "Find specialized doctors that are capable of assisting you with your health issues!",
            ),
            OnBoardingPage(
              image: "assets/images/onboarding_images/diagnosis.png",
              title: "Get Accurate Diagnosis and Medication",
              subTitle:
                  "Get to know what is really wrong with you from our specialized doctors and get the right medication.",
            ),
            OnBoardingPage(
              image: "assets/images/onboarding_images/appointments.png",
              title: "Personalized Meetings with Doctors",
              subTitle:
                  "Book meetings with specialized doctors to get personalized health care services",
            ),
            OnBoardingPage(
              image: "assets/images/onboarding_images/healthy-patient.gif",
              title: "Stay Healthy and Safe",
              subTitle:
                  "Always stay healthy and safe by following the instructions of our specialized doctors.",
            ),
          ],
        ),

        /// Skip Button
        const OnBoardingSkip(),

        /// Dot Navigation SmoothPageIndicator
        const OnBoardingDotNavigation(),

        /// Circular Button
        const OnBoardingNextButton(),
      ]),
    );
  }
}


