// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:compuvers/src/repository/authentication/authentication_repo.dart'; // Import AuthRepo

// class AnnouncementController extends GetxController {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   final AuthenticationRepository authRepo;

//   AnnouncementController(this.flutterLocalNotificationsPlugin, this.authRepo);

//   // Firestore instance
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Stream to get real-time announcements
//   Stream<QuerySnapshot> getAnnouncements() {
//     final user = authRepo.firebaseUser.value;
//     if (user != null && user.email == 'septiandwica@gmail.com') {
//       // Admin melihat semua pengumuman (termasuk yang belum terkirim)
//       return _firestore.collection('announcements').orderBy('timestamp', descending: true).snapshots();
//     } else {
//       // User biasa hanya melihat pengumuman yang sudah terkirim
//       return _firestore
//           .collection('announcements')
//           .where('isSent', isEqualTo: true) // Filter pengumuman yang sudah terkirim
//           .orderBy('timestamp', descending: true)
//           .snapshots();
//     }
//   }

//   // Create a new announcement
//   Future<void> createAnnouncement(String title, String body) async {
//     try {
//       final user = authRepo.firebaseUser.value;
//       String createdBy = user?.email ?? '';  // Ambil email dari user yang login
//       // Add the announcement to Firestore
//       DocumentReference docRef = await _firestore.collection('announcements').add({
//         'title': title,
//         'body': body,
//         'timestamp': FieldValue.serverTimestamp(),
//         'isSent': false,  // Pengumuman baru defaultnya isSent=false
//         'createdBy': createdBy,
//       });

//       // After adding, send notification
//       sendNotification(title, body);

//       print("Announcement created with ID: ${docRef.id}");
//     } catch (e) {
//       print("Error creating announcement: $e");
//     }
//   }

//   // Update an existing announcement
//   Future<void> updateAnnouncement(String id, String title, String body) async {
//     try {
//       await _firestore.collection('announcements').doc(id).update({
//         'title': title,
//         'body': body,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // After updating, send a notification
//       sendNotification(title, body);
//       print("Announcement updated: $id");
//     } catch (e) {
//       print("Error updating announcement: $e");
//     }
//   }

//   // Delete an announcement
//   Future<void> deleteAnnouncement(String id) async {
//     try {
//       await _firestore.collection('announcements').doc(id).delete();
//       print("Announcement deleted: $id");
//     } catch (e) {
//       print("Error deleting announcement: $e");
//     }
//   }

//   // Send a notification
//   Future<void> sendNotification(String title, String body) async {
//     print("Sending notification with title: $title and body: $body");

//     const androidDetails = AndroidNotificationDetails(
//       'default_channel', // Channel ID
//       'Default Notifications', // Channel name
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );

//     const iOSDetails = DarwinNotificationDetails();

//     const platformDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );

//     try {
//       await flutterLocalNotificationsPlugin.show(
//         0, // Notification ID
//         title, // Notification title
//         body, // Notification body
//         platformDetails,
//         payload: 'announcements',
//       );
//       print("Notification sent successfully");
//     } catch (e) {
//       print("Failed to send notification: $e");
//     }
//   }

//   // Send notifications for each announcement (this method can be used to notify all users when fetching announcements)
//   void sendAnnouncementsAsNotifications(QuerySnapshot snapshot) {
//     for (var doc in snapshot.docs) {
//       var title = doc['title'];
//       var body = doc['body'];
//       sendNotification(title, body); // Send notification for each announcement
//     }
//   }
// }
