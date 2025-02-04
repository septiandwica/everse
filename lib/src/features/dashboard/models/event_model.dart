import 'package:cloud_firestore/cloud_firestore.dart';
class EventModel {
  final String? id;
  final String eventDate;
  final String eventDescription;
  final String eventName;
  final String eventType;
  final String location;
  final String imageUrl;
  final List<Map<String, dynamic>> candidates;
  final List<String> voters;
  final List<Map<String, dynamic>> teams; // Menambahkan field teams

  EventModel({
    this.id,
    required this.eventDate,
    required this.eventDescription,
    required this.eventName,
    required this.eventType,
    required this.location,
    required this.imageUrl,
    this.candidates = const [],
    this.voters = const [],
    this.teams = const [], // Inisialisasi field teams
  });

  factory EventModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return EventModel(
      id: document.id,
      eventDate: data["EventDate"],
      eventDescription: data["EventDescription"],
      eventName: data["EventName"],
      eventType: data["EventType"],
      location: data["Location"],
      imageUrl: data["imageUrl"],
      candidates: data["Candidates"] != null
          ? List<Map<String, dynamic>>.from(data["Candidates"])
          : [],
      voters: data["Voters"] != null
          ? List<String>.from(data["Voters"])
          : [],
      teams: data["Teams"] != null
          ? List<Map<String, dynamic>>.from(data["Teams"])
          : [], // Mengambil data tim
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "EventDate": eventDate,
      "EventDescription": eventDescription,
      "EventName": eventName,
      "EventType": eventType,
      "Location": location,
      "imageUrl": imageUrl,
      "Candidates": candidates,
      "Voters": voters,
      "Teams": teams, // Menyimpan data tim
    };
  }
}
