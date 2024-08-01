// import 'package:doconnect/utils/Navigation/navigation_controller.dart';
// import 'package:doconnect/utils/Navigation/navigation_menu.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:doconnect/bindings/general_bindings.dart';
// import 'package:doconnect/data/repositories/authentication_repository.dart';
// import 'package:doconnect/firebase_options.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

// Future<void> main() async {
//   // Adding Widgets binding
//   final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

//   // Adding Local Storage
//   await GetStorage.init();

//   // Awaiting Splashscreen until other items are loaded
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//   // Initializing Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
//       .then((FirebaseApp value) {
//     Get.put(AuthenticationRepository());
//     Get.put(NavigationMenu());
//   });

//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   void initState() {
//     super.initState();
//     initialization();
//   }

//   void initialization() async {
//     await Future.delayed(const Duration(seconds: 4));
//     FlutterNativeSplash.remove();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialBinding: GeneralBindings(),
//       home: const Scaffold(
//         backgroundColor: Colors.blue,
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       ),
//       // Uncomment to show onboarding screen
//       // home: onBoardingScreen(),
//     );
//   }
// }

import 'package:doconnect/Google-SignIn/controllers/user_controller.dart';
import 'package:doconnect/Models/auth_model.dart';
import 'package:doconnect/authentication/screens/login/login.dart';
import 'package:doconnect/authentication/screens/onboarding/onboarding.dart';
import 'package:doconnect/data/repositories/doctors/doctor_controller.dart';
import 'package:doconnect/utils/Navigation/doctor_navigation.dart';
import 'package:doconnect/utils/Navigation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:myapp/authentication/screens/onboarding/onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:doconnect/bindings/general_bindings.dart';
import 'package:doconnect/data/repositories/authentication_repository.dart';
// import 'package:doconnect/data/repositories/pharmacies/pharmacy_repository.dart';
import 'package:doconnect/firebase_options.dart';
// import 'package:doconnect/LandingPage/Location_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';



Future<void> main() async {
  // Adding Widgets binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Adding Local Storage
  await GetStorage.init();

  // Awaiting Splashscreen until other items are loaded
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initializing Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) {
    Get.put(AuthenticationRepository());
    Get.put(AuthModel());
    Get.put(NavigationController());
    Get.put(DoctorNavigationController());
    Get.put(UserController());
    Get.put(DoctorController());
    // Get.put(PharmacyRepository());
    // Get.put(LocationController());
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(

          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 7, 7, 241),
              )),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          floatingLabelStyle:
              TextStyle(color: Color.fromARGB(255, 7, 7, 241)),
          prefixIconColor: Colors.black38,
        ),
      ),
      home: const SplashScreen(), // Set your NavigationMenu here
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialRoute();
  }

Future<void> _checkInitialRoute() async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final user = AuthenticationRepository.instance.authUser;
    if (user != null) {
      // Assuming that you have a way to determine if the user is a doctor or not
      bool isDoctor = await AuthenticationRepository.instance.isDoctor(user.uid);

      // Redirect based on user role
      if (isDoctor) {
        Get.offAll(() => const DoctorNavigationMenu()); // Redirect to doctor menu
      } else {
        Get.offAll(() => const NavigationMenu()); // Redirect to user menu
      }
    } else {
      // If no user is authenticated, redirect to a login page or similar
      Get.offAll(() => const onBoardingScreen()); // Adjust this based on your app's flow
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while redirecting
      ),
    );
  }
}