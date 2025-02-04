import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/controller/career_controller.dart';
import 'package:compuvers/src/features/dashboard/models/career_model.dart';
import 'package:compuvers/src/features/dashboard/screen/career/crud/add_career.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'career_detail.dart'; // The detail page for career

class CareerPage extends StatefulWidget {
  const CareerPage({super.key});

  @override
  _CareerPageState createState() => _CareerPageState();
}

class _CareerPageState extends State<CareerPage> {
  String selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final controller = Get.put(CareerController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cCareerPage,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Obx(() {
            final user = authRepo.firebaseUser.value;
            if (user != null && user.email == 'septiandwica@gmail.com') {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Get.to(() => AddCareerPage());
                    },
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),

      body: Column(
        children: [
          // 1. Button Bar for Career Types with Horizontal Scroll
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _careerTypeButton('All'),
                  const SizedBox(width: 10),
                  _careerTypeButton('Full-time'),
                  const SizedBox(width: 10),
                  _careerTypeButton('Part-time'),
                  const SizedBox(width: 10),
                  _careerTypeButton('Internship'),
                  const SizedBox(width: 10),
                  _careerTypeButton('Freelance'),
                  const SizedBox(width: 10),
                  _careerTypeButton('Remote'),
                  const SizedBox(width: 10),
                  _careerTypeButton('On-Site'),
                  const SizedBox(width: 10),
                  _careerTypeButton('Hybrid'),

                ],
              ),
            ),
          ),

          // 2. FutureBuilder for Career List
          Expanded(
            child: FutureBuilder<List<CareerModel>>(
              future: controller.getAllCareers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    // Filter careers based on selected type
                    List<CareerModel> filteredCareers = selectedType == 'All'
                        ? snapshot.data!
                        : snapshot.data!
                        .where((career) => career.jobType == selectedType)
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCareers.length,
                      itemBuilder: (c, index) {
                        final career = filteredCareers[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Job Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    career.imageUrl.isNotEmpty ? career.imageUrl : cCareerBanner,
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 16.0),

                                // 2. Job Type
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    career.jobType.isNotEmpty ? career.jobType : "No Type",  // Fallback to "No Type" if empty
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),

                                // 3. Job Title
                                Text(
                                  career.jobTitle.isNotEmpty ? career.jobTitle : "No Title",  // Fallback to "No Title" if empty
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8.0),

                                // 5. Job Location and Application Deadline in a Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Align text to left and right
                                  children: [
                                    // Job Location
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.grey, size: 16),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          career.location.isNotEmpty ? career.location : "No Location",  // Fallback if location is empty
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Application Deadline
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, color: Colors.grey, size: 16),  // Optional Icon
                                        const SizedBox(width: 8.0),  // Space between icon and text
                                        Text(
                                          career.applicationDeadline.isNotEmpty
                                              ? career.applicationDeadline
                                              : "No Deadline",  // Fallback if deadline is empty
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),

                                // 4. Job Description
                                Text(
                                  career.jobDescription.isNotEmpty
                                      ? career.jobDescription.split(' ').take(10).join(' ') + (career.jobDescription.split(' ').length > 10 ? '...' : '')
                                      : "No Description",  // Fallback if description is empty
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8.0),

                                // Link to Career Details
                                InkWell(
                                  onTap: () async {
                                    await Get.to(() => CareerDetailPage(career: career));
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "More",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 20.0,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text("No careers available"));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method for Career Type Buttons
  Widget _careerTypeButton(String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedType == type ? Colors.blue : Colors.white54,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: selectedType == type ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
