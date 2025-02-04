// import 'package:cloud_firestore/cloud_firestore.dart';

// class Announcement {
//   final String id;
//   final String title;
//   final String body;
//   final Timestamp timestamp;
//   final bool isSent;  // Status pengumuman terkirim
//   final String createdBy; // Pembuat pengumuman

//   Announcement({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.timestamp,
//     required this.isSent,
//     required this.createdBy,
//   });

//   factory Announcement.fromSnapshot(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Announcement(
//       id: doc.id,
//       title: data['title'] ?? '',
//       body: data['body'] ?? '',
//       timestamp: data['timestamp'] ?? Timestamp.now(),
//       isSent: data['isSent'] ?? false, // Default false if not provided
//       createdBy: data['createdBy'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'body': body,
//       'timestamp': timestamp,
//       'isSent': isSent,
//       'createdBy': createdBy,
//     };
//   }
// }
