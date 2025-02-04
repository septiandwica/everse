// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:compuvers/src/features/dashboard/controller/announce_controller.dart';
// import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
//
// class AnnouncementPage extends StatelessWidget {
//   // Corrected: Providing both dependencies
//   final AnnouncementController announcementController = Get.put(
//     AnnouncementController(
//       Get.find<FlutterLocalNotificationsPlugin>(), // First argument
//       Get.find<AuthenticationRepository>(), // Second argument
//     ),
//   );
//
//   final AuthenticationRepository authRepo = Get.find(); // Mendapatkan instansi AuthRepo
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Announcements'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _getAnnouncementsStream(), // Stream untuk mendapatkan pengumuman
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.hasError) {
//             return const Center(child: Text('Error loading announcements'));
//           }
//
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No announcements available'));
//           }
//
//           var announcements = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: announcements.length,
//             itemBuilder: (context, index) {
//               var announcement = announcements[index];
//
//               // Aman mengakses field dari pengumuman
//               var title = announcement['title'] ?? 'No Title';
//               var body = announcement['body'] ?? 'No Body'; // Nilai default jika tidak ditemukan
//               bool isSent = announcement['isSent'] ?? false; // Cek apakah pengumuman sudah terkirim
//
//               return ListTile(
//                 title: Text(title),
//                 subtitle: Text(body),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Tombol Edit, hanya akan tampil jika user adalah 'septiandwica@gmail.com'
//                     Obx(() {
//                       final user = authRepo.firebaseUser.value;
//                       if (user != null && user.email == 'septiandwica@gmail.com') {
//                         return IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () => _showAnnouncementDialog(context, announcement: announcement),
//                         );
//                       }
//                       return const SizedBox.shrink(); // Tidak menampilkan tombol jika user bukan 'septiandwica@gmail.com'
//                     }),
//
//                     // Tombol Send, hanya akan tampil jika user adalah 'septiandwica@gmail.com'
//                     Obx(() {
//                       final user = authRepo.firebaseUser.value;
//                       if (user != null && user.email == 'septiandwica@gmail.com') {
//                         return IconButton(
//                           icon: const Icon(Icons.send),
//                           onPressed: () {
//                             // Kirimkan notifikasi untuk pengumuman ini
//                             announcementController.sendNotification(title, body);
//                           },
//                         );
//                       }
//                       return const SizedBox.shrink();
//                     }),
//
//                     // Tombol Hapus, hanya akan tampil jika user adalah 'septiandwica@gmail.com'
//                     Obx(() {
//                       final user = authRepo.firebaseUser.value;
//                       if (user != null && user.email == 'septiandwica@gmail.com') {
//                         return IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () {
//                             // Hapus pengumuman ini dari Firestore
//                             announcementController.deleteAnnouncement(announcement.id);
//                           },
//                         );
//                       }
//                       return const SizedBox.shrink(); // Tidak menampilkan tombol jika user bukan 'septiandwica@gmail.com'
//                     }),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       // Floating action button untuk membuat pengumuman baru
//       floatingActionButton: Obx(() {
//         final user = authRepo.firebaseUser.value;
//         if (user != null && user.email == 'septiandwica@gmail.com') {
//           return FloatingActionButton(
//             onPressed: () => _showAnnouncementDialog(context),
//             child: const Icon(Icons.add),
//           );
//         }
//         return const SizedBox.shrink(); // Tidak menampilkan tombol jika user bukan 'septiandwica@gmail.com'
//       }),
//     );
//   }
//
//   // Mendapatkan stream pengumuman berdasarkan status pengiriman
//   Stream<QuerySnapshot> _getAnnouncementsStream() {
//     final user = authRepo.firebaseUser.value;
//     if (user != null && user.email == 'septiandwica@gmail.com') {
//       // Admin melihat semua pengumuman (termasuk yang belum terkirim)
//       return FirebaseFirestore.instance.collection('announcements').snapshots();
//     } else {
//       // User biasa hanya melihat pengumuman yang sudah terkirim
//       return FirebaseFirestore.instance
//           .collection('announcements')
//           .where('isSent', isEqualTo: true) // Filter pengumuman yang sudah terkirim
//           .snapshots();
//     }
//   }
//
//   // Menampilkan dialog untuk membuat atau mengedit pengumuman
//   void _showAnnouncementDialog(BuildContext context, {DocumentSnapshot? announcement}) {
//     final titleController = TextEditingController(text: announcement?['title'] ?? '');
//     final bodyController = TextEditingController(text: announcement?['body'] ?? '');
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(announcement == null ? 'Create Announcement' : 'Edit Announcement'),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: 'Title'),
//               ),
//               TextField(
//                 controller: bodyController,
//                 decoration: const InputDecoration(labelText: 'Body'),
//                 maxLines: 4,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (announcement == null) {
//                   // Membuat pengumuman baru
//                   announcementController.createAnnouncement(
//                     titleController.text,
//                     bodyController.text,
//                   );
//                 } else {
//                   // Mengupdate pengumuman yang ada
//                   announcementController.updateAnnouncement(
//                     announcement.id,
//                     titleController.text,
//                     bodyController.text,
//                   );
//                 }
//                 Get.back(); // Menutup dialog
//               },
//               child: const Text('Save'),
//             ),
//             TextButton(
//               onPressed: () => Get.back(), // Menutup dialog
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
