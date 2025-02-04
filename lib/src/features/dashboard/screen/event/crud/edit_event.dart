import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/controller/event_controller.dart';
import 'package:compuvers/src/features/dashboard/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditEventPage extends StatefulWidget {
  final String? eventId;

  const EditEventPage({Key? key, this.eventId}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? _eventType;
  String? _eventName;
  String? _eventDescription;
  String? _imageUrl;
  String? _eventDate;
  String? _location;
  List<Map<String, dynamic>> _candidates = []; // Daftar kandidat
  bool isLoading = false;

  final List<String> _eventTypes = [
    'Conference',
    'Workshop',
    'Seminar',
    'Webinar',
    'Competition',
    'Election', // Tambahkan tipe event untuk pemilihan
  ];

  final controller = Get.put(EventController());

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) {
      _loadEventData(widget.eventId!);
    }
  }

  void _loadEventData(String eventId) async {
    try {
      EventModel event = await controller.getEventData(eventId);
      setState(() {
        _eventType = event.eventType;
        _eventName = event.eventName;
        _eventDescription = event.eventDescription;
        _eventDate = event.eventDate;
        _location = event.location;
        _imageUrl = event.imageUrl;
        _candidates = event.candidates; // Memuat kandidat yang ada
      });

      if (!_eventTypes.contains(_eventType)) {
        _eventType = _eventTypes[0];
      }

      controller.eventName.text = _eventName!;
      controller.eventDescription.text = _eventDescription!;
      controller.eventDate.text = _eventDate!;
      controller.location.text = _location!;
      controller.imageUrl.text = _imageUrl!;
    } catch (e) {
      print('Error loading event: $e');
    }
  }

  void _addCandidate() {
    setState(() {
      _candidates.add({
        "name": "",
        "votes": 0,
      });
    });
  }

  void _updateCandidateName(int index, String name) {
    setState(() {
      _candidates[index]["name"] = name;
    });
  }

  void _removeCandidate(int index) {
    setState(() {
      _candidates.removeAt(index);
    });
  }

  // Function to delete event with confirmation
  void _deleteEvent() async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      // Proceed with deleting the event
      setState(() {
        isLoading = true;
      });

      try {
        await controller.deleteEvent(widget.eventId!);
        setState(() {
          isLoading = false;
        });

        Navigator.pop(context); // Navigate back after deletion
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar(
          'Error',
          'Failed to delete event. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.eventId == null ? cAddEvent : 'Update Event',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: cTypeEvent,
                  border: OutlineInputBorder(),
                ),
                value: _eventType ?? _eventTypes[0],
                onChanged: (String? newValue) {
                  setState(() {
                    _eventType = newValue;
                  });
                },
                items: _eventTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an event type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: controller.eventName,
                decoration: const InputDecoration(
                  labelText: cEventName,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: controller.eventDescription,
                decoration: const InputDecoration(
                  labelText: cEventDesc,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event description';
                  }
                  return null;
                },
                maxLines: null, // Allows the text field to expand vertically
                minLines: 1, // Optional: Set a minimum height (in lines) for the text field
                keyboardType: TextInputType.multiline, // Supports multiline input
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: controller.eventDate,
                decoration: const InputDecoration(
                  labelText: 'Event Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: controller.location,
                decoration: const InputDecoration(
                  labelText: 'Event Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              TextFormField(
                controller: controller.imageUrl,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Tambahkan bagian untuk mengelola kandidat pada pemilihan
              if (_eventType == 'Election') ...[
                Text('Candidates', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16.0),
                for (int i = 0; i < _candidates.length; i++) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _candidates[i]["name"],
                          decoration: InputDecoration(
                            labelText: 'Candidate ${i + 1} Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _updateCandidateName(i, value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => _removeCandidate(i),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
                ElevatedButton(
                  onPressed: _addCandidate,
                  child: Text('Add Candidate'),
                ),
              ],
              const SizedBox(height: 32.0),

              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        if (widget.eventId == null) {
                          controller.addEvent(
                            controller.eventDate.text,
                            controller.eventDescription.text,
                            controller.eventName.text,
                            _eventType!,
                            controller.location.text,
                            controller.imageUrl.text,
                            candidates: _candidates, // Mengirimkan daftar kandidat
                          );
                        } else {
                          EventModel updatedEvent = EventModel(
                            eventDate: controller.eventDate.text,
                            eventDescription: controller.eventDescription.text,
                            eventName: controller.eventName.text,
                            eventType: _eventType!,
                            location: controller.location.text,
                            imageUrl: controller.imageUrl.text,
                            candidates: _candidates, // Mengupdate kandidat
                          );
                          await controller.updateEvent(widget.eventId!, updatedEvent);
                        }

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.eventId == null ? 'Create Event' : 'Update Event'),
                  ),
                  const SizedBox(height: 16.0),
                  if (widget.eventId != null)
                    ElevatedButton(
                      onPressed: _deleteEvent,
                      child: Text(
                        'Delete Event',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
