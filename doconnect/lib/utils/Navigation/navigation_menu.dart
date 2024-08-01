import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doconnect/LandingPage/landing_page.dart';
import 'package:doconnect/authentication/screens/AppointmentPage/appointment_page.dart';
import 'package:doconnect/authentication/screens/FavoritePage/favorite_page.dart';
import 'package:doconnect/authentication/screens/profile/user_profile.dart';

// class NavigationMenu extends StatefulWidget {
//   const NavigationMenu({Key? key}) : super(key: key);

//   @override
//   _NavigationMenuState createState() => _NavigationMenuState();
// }

// class _NavigationMenuState extends State<NavigationMenu> {
//   final PageController _pageController = PageController();
//   final RxInt _currentIndex = 0.obs;

//   final List<Widget> _pages = [
//     const LandingPage(),
//     FavoritePage(),
//     const AppointmentPage(),
//     ProfileScreen(),
//   ];

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         children: _pages,
//         onPageChanged: (index) {
//           _currentIndex.value = index;
//         },
//       ),
//       bottomNavigationBar: Obx(
//         () => BottomNavigationBar(
//           currentIndex: _currentIndex.value,
//           onTap: (index) {
//             _currentIndex.value = index;
//             _pageController.animateToPage(
//               index,
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//             );
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
//               label: 'Home',
//             ),
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.solidHeart),
//               label: 'Favorite',
//             ),
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
//               label: 'Appointments',
//             ),
//             BottomNavigationBarItem(
//               icon: FaIcon(FontAwesomeIcons.solidUser),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.houseChimneyMedical), label: "Home"),
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.solidHeart), label: "Favorites"),
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.solidCalendarCheck), label: "Appointments"),
            NavigationDestination(icon: FaIcon(FontAwesomeIcons.solidUser), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex= 0.obs;
  
  final screens = [
    const LandingPage(),
    FavoritePage(),
    const AppointmentPage(),
    ProfileScreen(),
  ];
}