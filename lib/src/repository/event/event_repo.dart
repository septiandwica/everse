import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/features/dashboard/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventRepository extends GetxController {
  static EventRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // Menambahkan Event baru ke Firestore
  createEvent(EventModel event) async {
    await _db.collection("Events").add(event.toJson()).whenComplete(() {
      Get.snackbar(
        "Success",
        "Event has been created",
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

  // Fungsi untuk memperbarui event
  updateEvent(String eventId, EventModel event) async {
    await _db.collection("Events").doc(eventId).update(event.toJson()).whenComplete(() {
      Get.snackbar(
        "Success",
        "Event has been updated",
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

  // Mengambil Detail Event berdasarkan ID
  Future<EventModel> getEventDetails(String eventId) async {
    final snapshot = await _db.collection("Events").doc(eventId).get();
    if (snapshot.exists) {
      return EventModel.fromSnapshot(snapshot);
    } else {
      throw Exception("Event not found");
    }
  }

  // Fungsi untuk mendapatkan event terdekat berdasarkan waktu
  Future<List<EventModel>> getUpcomingEvents() async {
    final now = DateTime.now();  // Mendapatkan waktu saat ini
    final snapshot = await _db
        .collection("Events")
        .where("eventDate", isGreaterThan: now.toIso8601String()) // Filter event berdasarkan tanggal
        .orderBy("eventDate", descending: false) // Urutkan berdasarkan eventDate terdekat
        .get();

    final events = snapshot.docs
        .map((doc) => EventModel.fromSnapshot(doc))
        .toList();
    return events;
  }

  // Mengambil Daftar Semua Event
  Future<List<EventModel>> allEvents() async {
    final snapshot = await _db.collection("Events").get();
    final eventData = snapshot.docs.map((e) => EventModel.fromSnapshot(e)).toList();
    return eventData;
  }

  // Fungsi untuk menghapus event berdasarkan ID
  deleteEvent(String eventId) async {
    try {
      await _db.collection("Events").doc(eventId).delete().whenComplete(() {
        Get.snackbar(
          "Success",
          "Event has been deleted",
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
      print('Error deleting event: $e');
      Get.snackbar(
        "Error",
        "Failed to delete event",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Update votes for a candidate
  Future<void> updateVotes(String eventId, String candidateName, int newVotes, String userId) async {
    try {
      // Ambil data event
      final eventDoc = await _db.collection("Events").doc(eventId).get();
      if (!eventDoc.exists) throw Exception("Event not found");

      final event = EventModel.fromSnapshot(eventDoc);

      if (event.voters.contains(userId)) {
        Get.snackbar(
          "Vote Denied",
          "You have already voted in this election.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }

      final updatedCandidates = event.candidates.map((candidate) {
        if (candidate["name"] == candidateName) {
          return {...candidate, "votes": newVotes};
        }
        return candidate;
      }).toList();

      final updatedVoters = [...event.voters, userId];

      await _db.collection("Events").doc(eventId).update({
        "Candidates": updatedCandidates,
        "Voters": updatedVoters,
      });

      Get.snackbar(
        "Vote Casted",
        "Your vote has been recorded successfully.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to cast vote. Please try again.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Error updating votes: $e");
    }
  }
  // Fungsi untuk memperbarui poin tim
  Future<void> updateTeamPoints(String eventId, String teamName, int newPoints) async {
    try {
      final eventDoc = await _db.collection("Events").doc(eventId).get();
      if (!eventDoc.exists) throw Exception("Event not found");

      final event = EventModel.fromSnapshot(eventDoc);

      // Mengupdate poin tim dalam daftar tim
      final updatedTeams = event.teams.map((team) {
        if (team['teamName'] == teamName) {
          return {...team, 'points': newPoints}; // Update points
        }
        return team;
      }).toList();

      // Update Firestore
      await _db.collection("Events").doc(eventId).update({
        "Teams": updatedTeams,
      });

      Get.snackbar(
        "Success",
        "Team points updated",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update team points",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Error updating team points: $e");
    }
  }

  // Fungsi untuk menambahkan tim baru ke event
  Future<void> addTeam(String eventId, String teamName) async {
    try {
      final eventDoc = await _db.collection("Events").doc(eventId).get();
      if (!eventDoc.exists) throw Exception("Event not found");

      final event = EventModel.fromSnapshot(eventDoc);

      // Menambahkan tim baru ke dalam daftar tim
      final updatedTeams = [
        ...event.teams,
        {"teamName": teamName, "points": 0} // Tim baru dengan poin 0
      ];

      // Update Firestore
      await _db.collection("Events").doc(eventId).update({
        "Teams": updatedTeams,
      });

      Get.snackbar(
        "Success",
        "Team has been added",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add team",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print("Error adding team: $e");
    }
  }
}
