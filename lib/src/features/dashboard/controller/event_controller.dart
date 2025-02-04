import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compuvers/src/features/dashboard/models/event_model.dart';
import 'package:compuvers/src/repository/event/event_repo.dart';

class EventController extends GetxController {
  static EventController get instance => Get.find();

  // TextEditingControllers untuk form fields
  final eventType = TextEditingController();
  final eventName = TextEditingController();
  final eventDescription = TextEditingController();
  final imageUrl = TextEditingController();
  final eventDate = TextEditingController();  // Controller for event date
  final location = TextEditingController();   // Controller for location

  final _eventRepo = Get.put(EventRepository());


  var isLoading = true.obs; // untuk status loading
  var upcomingEvent = Rx<EventModel?>(null); // untuk menyimpan event terdekat

  // Fungsi untuk membuat event baru
  Future<void> createEvent(EventModel event) async {
    await _eventRepo.createEvent(event);
  }

  // Fungsi untuk memperbarui event yang sudah ada
  Future<void> updateEvent(String eventId, EventModel event) async {
    await _eventRepo.updateEvent(eventId, event);
  }

  // Fungsi untuk menambah event berdasarkan data form
  void addEvent(
      String eventDate,
      String eventDescription,
      String eventName,
      String eventType,
      String location,
      String imageUrl, {
        List<Map<String, dynamic>> candidates = const [],
      }) {
    final newEvent = EventModel(
      eventDate: eventDate,
      eventDescription: eventDescription,
      eventName: eventName,
      eventType: eventType,
      location: location,
      imageUrl: imageUrl,
      candidates: candidates, // Tambahkan kandidat
    );

    createEvent(newEvent);
  }

  // Fungsi untuk mendapatkan data event berdasarkan ID
  Future<EventModel> getEventData(String eventId) async {
    try {
      final event = await _eventRepo.getEventDetails(eventId);
      return event;
    } catch (e) {
      print('Error fetching event: $e');
      throw Exception('Event not found');
    }
  }

  // Fungsi untuk mendapatkan semua event
  Future<List<EventModel>> getAllEvents() async {
    return await _eventRepo.allEvents();
  }

  // Fungsi untuk menghapus event berdasarkan ID
  Future<void> deleteEvent(String eventId) async {
    await _eventRepo.deleteEvent(eventId);
  }




  // Fungsi untuk mendapatkan event terdekat berdasarkan waktu
  Future<EventModel?> getUpcomingEvent() async {
    try {
      final events = await _eventRepo.allEvents();

      // Memfilter event yang terjadi setelah waktu sekarang
      final upcomingEvents = events.where((event) {
        final eventDate = DateTime.parse(event.eventDate);
        return eventDate.isAfter(DateTime.now());
      }).toList();

      // Mengurutkan berdasarkan waktu terdekat
      upcomingEvents.sort((a, b) {
        final dateA = DateTime.parse(a.eventDate);
        final dateB = DateTime.parse(b.eventDate);
        return dateA.compareTo(dateB);
      });

      // Mengembalikan event terdekat pertama
      return upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
    } catch (e) {
      print("Error fetching upcoming events: $e");
      return null;
    }
  }


  // Fungsi untuk memperbarui suara kandidat
  Future<void> updateCandidateVotes(String eventId, String candidateName, int newVotes) async {
    final userId = AuthenticationRepository.instance.firebaseUser.value?.uid;
    if (userId != null) {
      await _eventRepo.updateVotes(eventId, candidateName, newVotes, userId);
    } else {
      Get.snackbar(
        "Error",
        "You must be signed in to vote.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<String?> getUserFullName(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (doc.exists) {
        return doc.data()?['fullName']; // Ambil field 'fullname'
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print("Error fetching user fullname: $e");
      return null;
    }
  }

  // Fungsi untuk memperbarui poin tim
  Future<void> updateTeamPoints(String eventId, String teamName, int newPoints) async {
    try {
      await _eventRepo.updateTeamPoints(eventId, teamName, newPoints);
    } catch (e) {
      print("Error updating team points: $e");
    }
  }

  // Fungsi untuk menambah tim ke event
  Future<void> addTeamToEvent(String eventId, String teamName) async {
    try {
      await _eventRepo.addTeam(eventId, teamName);
    } catch (e) {
      print("Error adding team: $e");
    }
  }
}
