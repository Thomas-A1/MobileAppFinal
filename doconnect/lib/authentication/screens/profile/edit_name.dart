import 'package:doconnect/authentication/controllers/update_name_controller.dart';
import 'package:doconnect/validators/FormValidation.dart';
import 'package:doconnect/widgets/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditName extends StatelessWidget {
  const EditName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        title: Text(
          'Change Name',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Use your actual name for ease of verification. This name will appear in most of the pages",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(
              height: 32,
            ),

            // TextFields and Button
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstname,
                    validator: (value) =>
                        FormValidation.validateEmptyText('First Name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: "Firstname", prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.lastname,
                    validator: (value) =>
                        FormValidation.validateEmptyText('Last Name', value),
                    expands: false,
                    decoration: const InputDecoration(
                        labelText: "Lastname", prefixIcon: Icon(Icons.person)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateUserName();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
