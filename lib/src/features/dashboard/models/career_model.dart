import 'package:cloud_firestore/cloud_firestore.dart';

class CareerModel {
  final String? id;
  final String applicationDeadline; // Application Deadline (e.g., "2024-10-12")
  final String imageUrl;          // Image URL (e.g., image link for the company logo)
  final String jobDescription;    // Job Description (e.g., "Halo ini software Engineer job")
  final String jobTitle;          // Job Title (e.g., "Software Engineer")
  final String jobType;           // Job Type (e.g., "Part-time")
  final String location;          // Job Location (e.g., "Cikarang")
  final String relatedUrl;

  CareerModel({
    this.id,
    required this.applicationDeadline,
    required this.imageUrl,
    required this.jobDescription,
    required this.jobTitle,
    required this.jobType,
    required this.location,
    required this.relatedUrl,
  });

  // Factory constructor to create CareerModel from Firestore snapshot
  factory CareerModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CareerModel(
      id: document.id,
      applicationDeadline: data["ApplicationDeadline"] ?? "",  // Application Deadline (e.g., "2024-10-12")
      imageUrl: data["ImageUrl"] ?? "",  // Image URL
      jobDescription: data["JobDescription"] ?? "",  // Job Description
      jobTitle: data["JobTitle"] ?? "",  // Fetch Job Title correctly
      jobType: data["JobType"] ?? "",  // Job Type (e.g., "Part-time")
      location: data["Location"] ?? "",  // Location (e.g., "Cikarang")
      relatedUrl: data["RelatedUrl"] ?? "",
    );
  }

  // Method to convert CareerModel to Firestore-compatible map
  Map<String, dynamic> toJson() {
    return {
      "ApplicationDeadline": applicationDeadline,
      "ImageUrl": imageUrl,
      "JobDescription": jobDescription,
      "JobTitle": jobTitle,
      "JobType": jobType,
      "Location": location,
      "RelatedUrl": relatedUrl,
    };
  }
}
