import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:flutter/material.dart';

class AttendanceListController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Fetch attendance data for a specific event
  Stream<QuerySnapshot> getAttendanceStream(String eventId) {
    return _firebaseFirestore
        .collection("Events")
        .doc(eventId)
        .collection("Attendance")
        .snapshots();
  }

  // Fetch user details by user ID
  Future<DocumentSnapshot> getUserById(String userId) {
    return _firebaseFirestore.collection('Users').doc(userId).get();
  }
}
