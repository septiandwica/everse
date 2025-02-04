import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compuvers/src/features/dashboard/controller/event_controller.dart';
import 'package:compuvers/src/constants/text_strings.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String? _eventType;
  String? _eventName;
  String? _eventDescription;
  String? _imageUrl;
  String? _eventDate; // New field for event date
  String? _location; // New field for location
  final List<Map<String, dynamic>> _candidates = [];
  final TextEditingController _candidateNameController = TextEditingController();

  final List<String> _eventTypes = [
    'Conference',
    'Workshop',
    'Seminar',
    'Webinar',
    'Competition',
    'Mentoring',
    'Election'
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EventController());
    return Scaffold(
      appBar: AppBar(
        title: Text(cAddEvent, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: cTypeEvent,
                  border: OutlineInputBorder(),
                ),
                value: _eventType,
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

              // Event Name TextField
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
                onSaved: (value) {
                  _eventName = value;
                },
              ),
              const SizedBox(height: 16.0),

              // Event Description TextField
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
                onSaved: (value) {
                  _eventDescription = value;
                },
                maxLines: null, // Allows the text field to expand vertically
                minLines: 8, // Optional: Set a minimum height (in lines) for the text field
                keyboardType: TextInputType.multiline, // Supports multiline input
              ),
              const SizedBox(height: 16.0),

              // Event Date TextField
              TextFormField(
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
                onSaved: (value) {
                  _eventDate = value;
                },
              ),
              const SizedBox(height: 16.0),

              // Location TextField
              TextFormField(
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
                onSaved: (value) {
                  _location = value;
                },
              ),
              const SizedBox(height: 16.0),

              // Image URL TextField
              TextFormField(
                controller: controller.imageUrl,
                decoration: const InputDecoration(
                  labelText: cImageUrl,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _imageUrl = value;
                },
              ),
              const SizedBox(height: 32.0),

              // Candidate Section (only for Election events)
              if (_eventType == 'Election') ...[
                const Text(
                  "Candidates",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _candidateNameController,
                  decoration: const InputDecoration(
                    labelText: 'Candidate Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (_candidateNameController.text.isNotEmpty) {
                      setState(() {
                        _candidates.add({"name": _candidateNameController.text, "votes": 0});
                      });
                      _candidateNameController.clear();
                    }
                  },
                  child: const Text("Add Candidate"),
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = _candidates[index];
                    return ListTile(
                      title: Text(candidate["name"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _candidates.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
              ],

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Call the addEvent function from the controller
                    controller.addEvent(
                      _eventDate!,
                      _eventDescription!,
                      _eventName!,
                      _eventType!,
                      _location!,
                      _imageUrl!,
                      candidates: _candidates, // Include candidates if it's an election
                    );

                    // Reset form fields after submission
                    controller.eventType.clear();
                    controller.eventName.clear();
                    controller.eventDescription.clear();
                    controller.imageUrl.clear();
                    setState(() {
                      _eventType = null;
                      _candidates.clear();
                    });

                    // Navigate back after submission
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
