import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/sizes.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:compuvers/src/features/dashboard/controller/profile_controller.dart';
import 'package:compuvers/src/features/authentication/screen/welcome/welcome_screen.dart';
import 'package:compuvers/src/features/dashboard/screen/profile/update_profile.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text(cProfile, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: FutureBuilder<UserModel?>(
            future: controller.getUserData(), // Fetch user data (nullable UserModel)
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error.toString()}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                UserModel userData = snapshot.data!;  // Safe to unwrap since we check for null
                return Column(
                  children: [
                    // Profile Picture (placeholder or from Firebase Storage)
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage(cProfilePict)),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Full Name and Email
                    Text(userData.fullName, style: Theme.of(context).textTheme.headlineMedium),
                    Text(userData.email, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 20.0),

                    // Edit Profile Button
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => Get.to(() => const UpdateProfile()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimaryColor,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(cEditProfile, style: TextStyle(color: cWhiteColor)),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const Divider(),

                    // Logout Button
                    ListTile(
                      onTap: () async {
                        await AuthenticationRepository.instance.logout();
                        Get.offAll(() => const WelcomeScreen());
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: cAccentColor.withOpacity(0.1),
                        ),
                        child: const Icon(Icons.logout_outlined),
                      ),
                      title: Text(cLogout, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.red,
                      )),
                    )
                  ],
                );
              } else {
                return const Center(child: Text('No data found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}


