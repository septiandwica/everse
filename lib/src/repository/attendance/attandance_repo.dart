import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AttendanceRepository extends GetxController {
  static AttendanceRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fungsi untuk menandai kehadiran pengguna pada event tertentu
  Future<bool> markAttendance(String eventId, String userId) async {
    try {
      // Referensi ke koleksi kehadiran di Firestore
      final attendanceDoc = _db
          .collection("Events")
          .doc(eventId)
          .collection("Attendance")
          .doc(userId);

      // Mengecek apakah pengguna sudah menandai kehadiran
      final docSnapshot = await attendanceDoc.get();

      if (docSnapshot.exists) {
        // Jika sudah hadir, tampilkan notifikasi
        Get.snackbar(
          "Already Marked",
          "You have already marked your attendance for this event.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return false; // Kehadiran tidak ditandai ulang
      }

      // Menandai kehadiran pengguna
      await attendanceDoc.set({
        'userId': userId,
        'eventId': eventId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Memberikan notifikasi berhasil
      Get.snackbar(
        "Success",
        "Your attendance has been successfully marked!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      return true;
    } catch (e) {
      // Menangani error dan menampilkan pesan ke pengguna
      Get.snackbar(
        "Error",
        "Failed to mark attendance. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Error marking attendance: $e");
      return false; // Kehadiran gagal ditandai
    }
  }


  /// Fungsi untuk mengambil daftar kehadiran dari event tertentu
  Future<List<Map<String, dynamic>>> getAttendanceList(String eventId) async {
    try {
      // Mendapatkan semua dokumen dari koleksi Attendance di Firestore
      final snapshot = await _db
          .collection("Events")
          .doc(eventId)
          .collection("Attendance")
          .get();

      // Konversi data menjadi List<Map<String, dynamic>>
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error retrieving attendance list: $e");
      throw Exception("Failed to retrieve attendance data.");
    }
  }

  /// Fungsi untuk mengecek status kehadiran pengguna untuk event tertentu
  Future<bool> checkAttendance(String eventId) async {
    try {
      // Mendapatkan ID pengguna yang sedang login
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final userId = user.uid;

      // Referensi dokumen kehadiran
      final attendanceDoc = _db
          .collection("Events")
          .doc(eventId)
          .collection("Attendance")
          .doc(userId);

      // Mengecek apakah dokumen sudah ada
      final docSnapshot = await attendanceDoc.get();
      return docSnapshot.exists;
    } catch (e) {
      print("Error checking attendance: $e");
      throw Exception("Failed to check attendance status.");
    }
  }
}
