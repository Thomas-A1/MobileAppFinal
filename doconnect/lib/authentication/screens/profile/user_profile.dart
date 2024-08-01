import 'package:doconnect/Google-SignIn/controllers/user_controller.dart';
import 'package:doconnect/authentication/screens/profile/edit_name.dart';
import 'package:flutter/material.dart';
import 'package:doconnect/widgets/customAppbar.dart';
import 'package:doconnect/widgets/profile_menu.dart';
import 'package:doconnect/widgets/section_heading.dart';
import 'package:doconnect/widgets/user_image.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Profile'),
        showBackArrow: false,
      ),
      // body
      body: Obx(() {
        final user = controller.user.value;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      CircularImage(
                        image: user.profilePicture.isNotEmpty
                            ? user.profilePicture
                            : 'assets/images/profile.png',
                        width: 80,
                        height: 80,
                        isNetworkImage: user.profilePicture.isNotEmpty,
                      ),
                      TextButton(
                        onPressed: () => controller.uploadUserProfilePicture(),
                        child: const Text('Change Profile Picture'),
                      ),
                    ],
                  ),
                ),
                // Details
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 16),

                // Heading
                const CustomSectionHeading(
                  title: 'Profile Information',
                  showActionButton: false,
                ),
                const SizedBox(height: 16),

                CustomProfileMenu(
                    onPressed: () => Get.to(() => const EditName()),
                    title: 'Name',
                    value: user.fullname),
                const SizedBox(height: 16),
                CustomProfileMenu(
                    onPressed: () {}, title: 'Username', value: user.username),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Personal Information Section
                const CustomSectionHeading(
                    title: 'Personal Information', showActionButton: false),
                const SizedBox(height: 16),

                CustomProfileMenu(
                    onPressed: () {},
                    title: 'User ID',
                    icon: Iconsax.copy,
                    value: user.id),
                CustomProfileMenu(
                    onPressed: () {}, title: 'E-mail', value: user.email),
                CustomProfileMenu(
                    onPressed: () {},
                    title: 'Contact',
                    value: user.phoneNumber),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}
