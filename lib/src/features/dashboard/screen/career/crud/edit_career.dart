import 'package:compuvers/src/constants/text_strings.dart';
import 'package:compuvers/src/features/dashboard/controller/career_controller.dart';
import 'package:compuvers/src/features/dashboard/models/career_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCareerPage extends StatefulWidget {
  final String? careerId;

  const EditCareerPage({Key? key, this.careerId}) : super(key: key);

  @override
  _EditCareerPageState createState() => _EditCareerPageState();
}

class _EditCareerPageState extends State<EditCareerPage> {
  final _formKey = GlobalKey<FormState>();
  String? _jobType;
  String? _jobTitle;
  String? _jobDescription;
  String? _imageUrl;
  String? _applicationDeadline;
  String? _location;
  String? _relatedUrl; // New field for related URL
  bool isLoading = false;

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Internship',
    'Freelance',
    'Remote',
    'On-Site',
    'Hybrid',
  ];

  final controller = Get.put(CareerController());

  @override
  void initState() {
    super.initState();
    if (widget.careerId != null) {
      _loadCareerData(widget.careerId!);
    }
  }

  void _loadCareerData(String careerId) async {
    try {
      CareerModel career = await controller.getCareerData(careerId);
      setState(() {
        _jobType = career.jobType;
        _jobTitle = career.jobTitle;
        _jobDescription = career.jobDescription;
        _applicationDeadline = career.applicationDeadline;
        _location = career.location;
        _imageUrl = career.imageUrl;
        _relatedUrl = career.relatedUrl; // Set the related URL value
      });

      controller.jobTitle.text = _jobTitle!;
      controller.jobDescription.text = _jobDescription!;
      controller.applicationDeadline.text = _applicationDeadline!;
      controller.location.text = _location!;
      controller.imageUrl.text = _imageUrl!;
      controller.relatedUrl.text = _relatedUrl!; // Set the related URL text field
    } catch (e) {
      print('Error loading career: $e');
    }
  }

  // Function to delete career with confirmation
  void _deleteCareer() async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Career'),
          content: Text('Are you sure you want to delete this job listing?'),
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
      // Proceed with deleting the career listing
      setState(() {
        isLoading = true;
      });

      try {
        await controller.deleteCareer(widget.careerId!);
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
          'Failed to delete the job listing. Please try again later.',
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
          widget.careerId == null ? 'Add Career' : 'Update Career',
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
              // Job Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Job Type',
                  border: OutlineInputBorder(),
                ),
                value: _jobType ?? _jobTypes[0],
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
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),

              // Application Deadline TextField
              TextFormField(
                controller: controller.applicationDeadline,
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
              ),
              const SizedBox(height: 16.0),

              // Job Location TextField
              TextFormField(
                controller: controller.location,
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
              ),
              const SizedBox(height: 16.0),

              // Related Site URL TextField (New)
              TextFormField(
                controller: controller.relatedUrl,
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
              ),
              const SizedBox(height: 32.0),

              // Loading Indicator or Submit Button
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

                        if (widget.careerId == null) {
                          controller.addCareer(
                            controller.applicationDeadline.text,
                            controller.jobDescription.text,
                            controller.jobTitle.text,
                            _jobType!,
                            controller.location.text,
                            controller.imageUrl.text,
                            controller.relatedUrl.text, // Pass the related URL
                          );
                        } else {
                          CareerModel updatedCareer = CareerModel(
                            applicationDeadline: controller.applicationDeadline.text,
                            jobDescription: controller.jobDescription.text,
                            jobTitle: controller.jobTitle.text,
                            jobType: _jobType!,
                            location: controller.location.text,
                            imageUrl: controller.imageUrl.text,
                            relatedUrl: controller.relatedUrl.text, // Update with related URL
                          );
                          await controller.updateCareer(widget.careerId!, updatedCareer);
                        }

                        setState(() {
                          isLoading = false;
                        });

                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.careerId == null ? 'Create Career' : 'Update Career'),
                  ),
                  const SizedBox(height: 16.0),
                  if (widget.careerId != null)
                    ElevatedButton(
                      onPressed: _deleteCareer,
                      child: Text(
                        'Delete Career',
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
