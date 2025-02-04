import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/sizes.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/controller/profile_controller.dart';
import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    RxBool obscurePassword = true.obs;
    RxBool obscureNewPassword = true.obs;
    RxBool obscureConfirmPassword = true.obs;
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(cEditProfile, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;

                  final email = TextEditingController(text: userData.email);
                  final fullName = TextEditingController(text: userData.fullName);
                  final newPassword = TextEditingController();
                  final confirmPassword = TextEditingController();

                  return Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(image: AssetImage(cProfilePict)),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // Full Name Field - Disabled
                            TextFormField(
                              controller: fullName,
                              enabled: false, // Disable the full name input
                              decoration: const InputDecoration(
                                label: Text(cFullName),
                                prefixIcon: Icon(Icons.person),
                                hintText: 'Name cannot be edited',
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Email Field - Disabled
                            TextFormField(
                              controller: email,
                              enabled: false, // Disable the email input
                              decoration: const InputDecoration(
                                label: Text(cEmail),
                                prefixIcon: Icon(Icons.email),
                                hintText: 'Email cannot be edited',
                              ),
                            ),
                            const SizedBox(height: 20),
                            // New Password Field
                            Obx(() {
                              return TextFormField(
                                controller: newPassword,
                                obscureText: obscureNewPassword.value,
                                decoration: InputDecoration(
                                  label: const Text('New Password'),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureNewPassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      obscureNewPassword.value = !obscureNewPassword.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a new password';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              );
                            }),
                            const SizedBox(height: 20),
                            // Confirm New Password Field
                            Obx(() {
                              return TextFormField(
                                controller: confirmPassword,
                                obscureText: obscureConfirmPassword.value,
                                decoration: InputDecoration(
                                  label: const Text('Confirm New Password'),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureConfirmPassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      obscureConfirmPassword.value = !obscureConfirmPassword.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value != newPassword.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              );
                            }),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (userData.id == null) {
                                      Get.snackbar(
                                        "Error",
                                        "User ID is missing",
                                        snackPosition: SnackPosition.TOP,
                                      );
                                      return;
                                    }

                                    final updatedUserData = UserModel(
                                      id: userData.id,
                                      email: email.text.trim(),
                                      fullName: fullName.text.trim(),
                                      password: newPassword.text.trim(),
                                      createdAt: Timestamp.now(),// Use new password here
                                    );

                                    await controller.updateRecord(updatedUserData, newPassword.text.trim());
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cPrimaryColor,
                                  side: BorderSide.none,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  cEditProfile,
                                  style: TextStyle(color: cWhiteColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Something went wrong"));
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
