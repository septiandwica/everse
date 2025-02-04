import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementRepository {
  final FirebaseFirestore firestore;

  AnnouncementRepository(this.firestore);

  // Fungsi untuk menambah pengumuman
  Future<void> addAnnouncement(String title, String body) async {
    await firestore.collection('announcements').add({
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
      'isSent': false,  // Pengumuman baru belum terkirim
      'createdBy': '', // Biasanya dikosongkan atau ditambahkan sesuai user yang membuat
    });
  }

  // Fungsi untuk mengambil pengumuman
  Stream<QuerySnapshot> getAnnouncements() {
    return firestore.collection('announcements').orderBy('timestamp', descending: true).snapshots();
  }
}
