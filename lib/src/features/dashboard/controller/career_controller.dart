import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compuvers/src/features/dashboard/models/career_model.dart';
import 'package:compuvers/src/repository/career/career_repo.dart';

class CareerController extends GetxController {
  static CareerController get instance => Get.find();

  // TextEditingControllers for form fields
  final jobTitle = TextEditingController();
  final jobDescription = TextEditingController();
  final jobType = TextEditingController();
  final applicationDeadline = TextEditingController();  // Controller for application deadline
  final location = TextEditingController();   // Controller for location
  final imageUrl = TextEditingController();   // Controller for job listing image
  final relatedUrl = TextEditingController();

  final _careerRepo = Get.put(CareerRepository());

  // Function to create a new job listing
  Future<void> createCareer(CareerModel career) async {
    await _careerRepo.createCareer(career);
  }

  // Function to update an existing job listing
  Future<void> updateCareer(String careerId, CareerModel career) async {
    await _careerRepo.updateCareer(careerId, career);
  }

  // Function to add a new career (job listing) based on form data
  void addCareer(
      String applicationDeadline,
      String imageUrl,
      String jobDescription,
      String jobTitle,
      String jobType,
      String location,
      String relatedUrl,
      ) {
    final newCareer = CareerModel(
      applicationDeadline: applicationDeadline,
      imageUrl: imageUrl,
      jobDescription: jobDescription,
      jobTitle: jobTitle,
      jobType: jobType,
      location: location,
      relatedUrl: relatedUrl,
    );

    createCareer(newCareer);
  }

  // Function to get career details by ID
  Future<CareerModel> getCareerData(String careerId) async {
    try {
      final career = await _careerRepo.getCareerDetails(careerId);
      return career;
    } catch (e) {
      print('Error fetching career: $e');
      throw Exception('Career not found');
    }
  }

  // Function to get all career listings
  Future<List<CareerModel>> getAllCareers() async {
    return await _careerRepo.allCareers();
  }

  // Function to delete a career listing by ID
  Future<void> deleteCareer(String careerId) async {
    await _careerRepo.deleteCareer(careerId);
  }


}
