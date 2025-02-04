import 'package:compuvers/src/constants/colors.dart';
import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/controller/event_controller.dart';
import 'package:compuvers/src/features/dashboard/models/event_model.dart';
import 'package:compuvers/src/features/dashboard/screen/attandance/scannerpage.dart';
import 'package:compuvers/src/features/dashboard/screen/event/crud/add_event.dart';
import 'package:compuvers/src/repository/authentication/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'event_detail.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthenticationRepository.instance;
    final controller = Get.put(EventController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cEventPage,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Obx(() {
            final user = authRepo.firebaseUser.value;
            if (user != null && user.email == 'septiandwica@gmail.com') {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Get.to(() => AddEventPage());
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAll(() => QRCodeScannerPage());
                    },
                    child:const Icon(Icons.qr_code_scanner),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),

      body: Column(
        children: [
          // 1. Button Bar for Event Types with Horizontal Scroll
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _eventTypeButton('All'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Conference'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Workshop'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Seminar'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Webinar'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Competition'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Mentoring'),
                  const SizedBox(width: 10),
                  _eventTypeButton('Election'),
                ],
              ),
            ),
          ),

          // 2. FutureBuilder for Events List
          Expanded(
            child: FutureBuilder<List<EventModel>>(
              future: controller.getAllEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    // Filter events based on selected type
                    List<EventModel> filteredEvents = selectedType == 'All'
                        ? snapshot.data!
                        : snapshot.data!
                        .where((event) => event.eventType == selectedType)
                        .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredEvents.length,
                      itemBuilder: (c, index) {
                        final event = filteredEvents[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    event.imageUrl,
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 16.0),

                                // 2. Event Type
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    event.eventType.isNotEmpty ? event.eventType : "No Type",  // Fallback to "No Type" if empty
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),

                                // 3. Event Name
                                Text(
                                  event.eventName.isNotEmpty ? event.eventName : "No Name",  // Fallback to "No Name" if empty
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8.0),

                                // 5. Event Date and 6. Event Location in a Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Align text to left and right
                                  children: [
                                    // Event Date
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          event.eventDate.isNotEmpty ? event.eventDate : "No Date",
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Event Location
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Colors.grey, size: 16),  // Optional Icon
                                        const SizedBox(width: 8.0),  // Space between icon and text
                                        Text(
                                          event.location.isNotEmpty ? event.location : "No Location",  // Fallback if location is empty
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8.0),

                                // 4. Event Description
                                Text(
                                  event.eventDescription.isNotEmpty
                                      ? event.eventDescription.split(' ').take(10).join(' ') + (event.eventDescription.split(' ').length > 10 ? '...' : '')
                                      : "No Description",  // Fallback if description is empty
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8.0),

                                // Link to Event Details
                                InkWell(
                                  onTap: () async {
                                    await Get.to(() => EventDetailPage(event: event));
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "More",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        size: 20.0,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text("No events available"));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method for Event Type Buttons
  Widget _eventTypeButton(String type) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedType = type;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedType == type ? Colors.blue : Colors.white54,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: selectedType == type ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
