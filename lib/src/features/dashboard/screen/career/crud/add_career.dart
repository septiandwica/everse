import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compuvers/src/features/dashboard/controller/career_controller.dart';
import 'package:compuvers/src/constants/text_strings.dart';

class AddCareerPage extends StatefulWidget {
  @override
  _AddCareerPageState createState() => _AddCareerPageState();
}

class _AddCareerPageState extends State<AddCareerPage> {
  final _formKey = GlobalKey<FormState>();
  String? _jobType;
  String? _jobTitle;
  String? _jobDescription;
  String? _imageUrl;
  String? _applicationDeadline; // New field for application deadline
  String? _location; // New field for job location
  String? _relatedUrl; // New field for related site URL

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Internship',
    'Freelance',
    'Remote',
    'On-Site',
    'Hybrid',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CareerController());
    return Scaffold(
      appBar: AppBar(
        title: Text(cAddCareer, style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(),
                ),
                value: _jobType,
                onChanged: (String? newValue) {
                  setState(() {
                    _jobType = newValue;
                  });
                },
                items: _jobTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a job type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Job Title TextField
              TextFormField(
                controller: controller.jobTitle,
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _jobTitle = value;
                },
              ),
              const SizedBox(height: 16.0),

              // Job Description TextField
              TextFormField(
                controller: controller.jobDescription,
                decoration: const InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _jobDescription = value;
                },
                maxLines: null, // Allows the text field to expand vertically
                minLines: 8, // Optional: Set a minimum height (in lines) for the text field
                keyboardType: TextInputType.multiline, // Supports multiline input
              ),
              const SizedBox(height: 16.0),

              // Application Deadline TextField
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Application Deadline (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the application deadline';
                  }
                  return null;
                },
                onSaved: (value) {
                  _applicationDeadline = value;
                },
              ),
              const SizedBox(height: 16.0),

              // Job Location TextField
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Job Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job location';
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
                  labelText: 'Company Logo / Image URL',
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
              const SizedBox(height: 16.0),

              // Related Site URL TextField (New)
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Related Site URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty && !Uri.tryParse(value)!.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
                onSaved: (value) {
                  _relatedUrl = value;
                },
              ),
              const SizedBox(height: 32.0),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Call the addCareer function from the controller
                    controller.addCareer(
                      _applicationDeadline!,
                      _imageUrl!,
                      _jobDescription!,
                      _jobTitle!,
                      _jobType!,
                      _location!,
                      _relatedUrl!, // Pass the new URL field here
                    );

                    // Reset form fields after submission
                    controller.jobTitle.clear();
                    controller.jobDescription.clear();
                    controller.imageUrl.clear();
                    controller.relatedUrl.clear();  // Reset the related URL field as well
                    setState(() {
                      _jobType = null;
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
