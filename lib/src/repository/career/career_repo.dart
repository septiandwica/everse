import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/features/dashboard/models/career_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CareerRepository extends GetxController {
  static CareerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Add a new Career (Job listing) to Firestore
  createCareer(CareerModel career) async {
    await _db.collection("Careers").add(career.toJson()).whenComplete(() {
      Get.snackbar(
        "Success",
        "Job listing has been created",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }).catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try Again",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("ERROR - $error");
    });
  }

  // Update an existing career listing
  updateCareer(String careerId, CareerModel career) async {
    await _db.collection("Careers").doc(careerId).update(career.toJson()).whenComplete(() {
      Get.snackbar(
        "Success",
        "Job listing has been updated",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
      );
    }).catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try Again",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("ERROR - $error");
    });
  }

  // Get career details by ID
  Future<CareerModel> getCareerDetails(String careerId) async {
    final snapshot = await _db.collection("Careers").doc(careerId).get();
    if (snapshot.exists) {
      return CareerModel.fromSnapshot(snapshot);
    } else {
      throw Exception("Career not found");
    }
  }

  // Get all career listings
  Future<List<CareerModel>> allCareers() async {
    final snapshot = await _db.collection("Careers").get();
    final careerData = snapshot.docs.map((e) => CareerModel.fromSnapshot(e)).toList();
    return careerData;
  }

  // Delete a career listing by ID
  deleteCareer(String careerId) async {
    try {
      await _db.collection("Careers").doc(careerId).delete().whenComplete(() {
        Get.snackbar(
          "Success",
          "Job listing has been deleted",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }).catchError((error) {
        Get.snackbar(
          "Error",
          "Something went wrong. Try Again",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
        print("ERROR - $error");
      });
    } catch (e) {
      print('Error deleting career: $e');
      Get.snackbar(
        "Error",
        "Failed to delete job listing",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

}
