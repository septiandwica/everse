import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compuvers/src/features/authentication/models/user_model.dart';
import 'package:compuvers/src/features/dashboard/controller/attendance_controller.dart';
import 'package:flutter/material.dart';

class AttendanceListPage extends StatelessWidget {
  final String eventId;
  final AttendanceListController controller = AttendanceListController();

  AttendanceListPage({required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance List'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getAttendanceStream(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading attendance list'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No attendance data found'));
          }

          final attendanceDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: attendanceDocs.length,
            itemBuilder: (context, index) {
              final doc = attendanceDocs[index];
              final userId = doc['userId'];
              final timestamp = doc['timestamp'] != null
                  ? (doc['timestamp'] as Timestamp).toDate()
                  : null;

              return FutureBuilder<DocumentSnapshot>(
                future: controller.getUserById(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Loading user info...'),
                    );
                  }
                  if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(
                      leading: const Icon(Icons.error),
                      title: Text(userId),
                      subtitle: const Text('Error fetching user details'),
                    );
                  }

                  final userDoc = userSnapshot.data!;
                  final userModel = UserModel.fromSnapshot(userDoc);

                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(userModel.fullName),
                    subtitle: timestamp != null
                        ? Text("Checked in: ${timestamp.toLocal()}")
                        : const Text("Timestamp not available"),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
