import 'dart:convert';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/controller/career_controller.dart';
import 'package:compuvers/src/features/dashboard/models/career_model.dart';
import 'package:compuvers/src/features/dashboard/screen/career/crud/edit_career.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerDetailPage extends StatelessWidget {
  final CareerModel career;

  const CareerDetailPage({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final controller = Get.put(CareerController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cCareerDetail,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Obx(() {
            final user = authRepo.firebaseUser.value;
            if (user != null && user.email == 'septiandwica@gmail.com') {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.to(() => EditCareerPage(careerId: career.id));
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      body: career.id != null
          ? FutureBuilder<CareerModel>(
        future: controller.getCareerData(career.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            final careerData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Job Image (could be a company logo or placeholder)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      careerData.imageUrl.isNotEmpty
                          ? careerData.imageUrl
                          : cCareerBanner,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Job Type
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      careerData.jobType.isNotEmpty ? careerData.jobType : 'No Type',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Job Title
                  Text(
                    careerData.jobTitle.isNotEmpty ? careerData.jobTitle : 'No Title',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10.0),

                  // Application Deadline and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                          const SizedBox(width: 8.0),
                          Text(
                            careerData.applicationDeadline.isNotEmpty
                                ? careerData.applicationDeadline
                                : "No Deadline",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 16),
                          const SizedBox(width: 8.0),
                          Text(
                            careerData.location.isNotEmpty
                                ? careerData.location
                                : "No Location",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Job Description
                  Text(
                    careerData.jobDescription.isNotEmpty
                        ? careerData.jobDescription
                        : 'No Description',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Related URL Button
                  if (careerData.relatedUrl != null && careerData.relatedUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(careerData.relatedUrl!);
                          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                            Get.snackbar(
                              'Error',
                              'Could not launch URL',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              colorText: Colors.red,
                            );
                          }
                        },
                        child: Text('Visit Related Site'),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No career details available"));
          }
        },
      )
          : const Center(child: Text("Invalid career ID")),
    );
  }
}
