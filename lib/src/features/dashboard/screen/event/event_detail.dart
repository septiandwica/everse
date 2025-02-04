import 'dart:convert';
import 'package:compuvers/src/constants/image_strings.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/authentication/screen/welcome/welcome_screen.dart';
import 'package:compuvers/src/features/dashboard/controller/attendance_controller.dart';
import 'package:compuvers/src/features/dashboard/controller/event_controller.dart';
import 'package:compuvers/src/features/dashboard/models/event_model.dart';
import 'package:compuvers/src/features/dashboard/screen/attandance/attendancelist.dart';
import 'package:compuvers/src/features/dashboard/screen/event/certificate/generate_certificate.dart';
import 'package:compuvers/src/features/dashboard/screen/event/competition/competitionform.dart';
import 'package:compuvers/src/features/dashboard/screen/event/crud/edit_event.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final controller = Get.put(EventController());
    final attendanceController = AttendanceListController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cEventDetail,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Obx(() {
            final user = authRepo.firebaseUser.value;
            if (user != null && user.email == 'septiandwica@gmail.com') {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.to(() => EditEventPage(eventId: event.id));
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      body: event.id != null
          ? FutureBuilder<EventModel>(
        future: controller.getEventData(event.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            final eventData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      eventData.imageUrl.isNotEmpty
                          ? eventData.imageUrl
                          : cEventBanner,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Event Type
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      eventData.eventType.isNotEmpty ? eventData.eventType : 'No Type',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Event Name
                  Text(
                    eventData.eventName.isNotEmpty ? eventData.eventName : 'No Title',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 10.0),

                  // Event Date and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                          const SizedBox(width: 8.0),
                          Text(
                            eventData.eventDate.isNotEmpty
                                ? eventData.eventDate
                                : "No Date",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 16),
                          const SizedBox(width: 8.0),
                          Text(
                            eventData.location.isNotEmpty
                                ? eventData.location
                                : "No Location",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Event Description
                  Text(
                    eventData.eventDescription.isNotEmpty
                        ? eventData.eventDescription
                        : 'No Description',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Additional Features for Election Events
                  if (eventData.eventType == 'Election') ...[
                    const Text(
                      "Candidates",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),

                    // Pie Chart for Voting Statistics
                    const Text(
                      "Voting Statistics",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),

                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sections: eventData.candidates.map((candidate) {
                            final totalVotes = eventData.candidates.fold<int>(0, (sum, c) => sum + ((c["votes"] ?? 0) as int));
                            final candidateVotes = ((candidate["votes"] ?? 0) as int);
                            final percentage = totalVotes > 0 ? (candidateVotes / totalVotes) * 100 : 0;
                            return PieChartSectionData(
                              value: candidateVotes.toDouble(),
                              title: "${percentage.toStringAsFixed(1)}%",
                              color: Colors.primaries[eventData.candidates.indexOf(candidate) % Colors.primaries.length],
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: eventData.candidates.length,
                      itemBuilder: (context, index) {
                        final candidate = eventData.candidates[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(candidate["name"]),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                final currentVotes = ((candidate["votes"] ?? 0) as int);
                                final updatedVotes = currentVotes + 1;

                                // Update votes using controller
                                await controller.updateCandidateVotes(
                                    event.id!, candidate["name"], updatedVotes);

                                Get.snackbar(
                                  "Vote Casted",
                                  "You voted for ${candidate["name"]}",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.green.withOpacity(0.1),
                                  colorText: Colors.green,
                                );
                              },
                              child: const Text("Vote"),
                            ),
                            subtitle: Text("Votes: ${candidate["votes"] ?? 0}"), // Display current votes
                          ),
                        );
                      },
                    ),
                  ],
                  if (eventData.eventType == 'Competition') ...[
                    // Join Competition Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the form page
                        Get.to(() => CompetitionFormPage(eventId: event.id!));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Join Competition'),
                    ),
                    const SizedBox(height: 10.0),

                    // View Teams and Leaderboard Button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the team list and leaderboard page
                        // Get.to(() => TeamListPage(eventId: event.id!));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('View Teams & Leaderboard'),
                    ),
                    const SizedBox(height: 10.0),

                    // RSVP for Guests Button
                    ElevatedButton(
                      onPressed: () {
                        final userId = authRepo.firebaseUser.value?.uid;
                        if (userId != null && event.id != null) {
                          final qrData = {
                            'userId': userId,
                            'eventId': event.id,
                            'timestamp': DateTime.now().toIso8601String(),
                          };

                          // Show QR Code
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('RSVP QR Code'),
                                content: SizedBox(
                                  width: 320,
                                  height: 320,
                                  child: QrImageView(
                                    data: jsonEncode(qrData),
                                    version: QrVersions.auto,
                                    size: 320,
                                    gapless: false,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Error: Cannot generate QR code.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('RSVP for Guests'),
                    ),
                  ],

                  // RSVP Button
                  // RSVP and Get Certificate Button
                  if (eventData.eventType != 'Election' && eventData.eventType != 'Competition') ...[
                    FutureBuilder<bool>(
                      future: attendanceController
                          .getAttendanceStream(event.id!)
                          .first
                          .then((snapshot) => snapshot.docs.any((doc) =>
                      doc.id == authRepo.firebaseUser.value?.uid)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data == true) {
                          return ElevatedButton(
                            onPressed: () async {
                              final userId = authRepo.firebaseUser.value?.uid; // UID pengguna login
                              if (userId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("User not logged in")),
                                );
                                return;
                              }

                              final userName = await controller.getUserFullName(userId); // Ambil fullname pengguna
                              if (userName == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to fetch user data")),
                                );
                                return;
                              }

                              final eventName = eventData.eventName; // Nama acara
                              final eventDate = eventData.eventDate; // Tanggal acara

                              await generateCertificate(userName, eventName, eventDate);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Certificate generated successfully! Saved on Downloads/Certificate_EventName")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('Get Certificate'),
                          );

                        } else {
                          return ElevatedButton(
                            onPressed: () async {
                              final userId = authRepo.firebaseUser.value?.uid;
                              if (userId != null && event.id != null) {
                                final qrData = {
                                  'userId': userId,
                                  'eventId': event.id,
                                  'timestamp': DateTime.now().toIso8601String(),
                                };

                                // Show QR Code
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Your Attendance QR Code'),
                                      content: SizedBox(
                                        width: 320,
                                        height: 320,
                                        child: QrImageView(
                                          data: jsonEncode(qrData),
                                          version: QrVersions.auto,
                                          size: 320,
                                          gapless: false,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Error: Cannot generate QR code.")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('RSVP'),
                          );
                        }
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  Obx(() {
                    final user = authRepo.firebaseUser.value;
                    if (user != null && user.email == 'septiandwica@gmail.com') {
                      return ElevatedButton(
                        onPressed: () {
                          // Navigate to the Attendance List Page
                          Get.to(() => AttendanceListPage(eventId: event.id!));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('View Attendance List'),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No event details available"));
          }
        },
      )
          : const Center(child: Text("Invalid event ID")),
    );
  }
}
