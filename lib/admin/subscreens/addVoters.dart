import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voting_system/admin/screen/voters_list.dart';

import '../../assets/global/global.dart';
import '../../assets/global/global_variable.dart';
import 'package:http/http.dart' as http;

import '../../global/components/dropdownlist.dart';
import '../../login/Services/qr_scanner.dart';
import '../services/addVoters.dart';


class addVotersScreen extends StatefulWidget {
  const addVotersScreen({super.key});

  @override
  State<addVotersScreen> createState() => _addVotersScreenState();
}

class _addVotersScreenState extends State<addVotersScreen> {

  @override
  void initState() {
    super.initState();
    fetchYearLevels();
  }


  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController yearLevelController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<YearLevel> yearLevels = [];
  List<Course> courses = [];

  bool isLoadingYearLevels = true;
  bool isLoadingCourses = false;

  String selectedYearLevelTitle = '';
  String selectedCourseTitle = '';

  Future<void> fetchYearLevels() async {
    try {
      final response = await http.get(FetchYearLevel);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          yearLevels = (data['data'] as List)
              .map((yearLevelJson) => YearLevel.fromJson(yearLevelJson))
              .toList();
          isLoadingYearLevels = false; // Stop loading when data is fetched
        });
      } else {
        throw Exception('Failed to load year levels');
      }
    } catch (error) {
      print('Error fetching year levels: $error');
      setState(() {
        isLoadingYearLevels = false; // Stop loading on error
      });
    }
  }

  Future<void> fetchCourses(String yearLevelID) async {
    setState(() {
      isLoadingCourses = true; // Start loading courses
    });

    try {
      // Sending yearLevelID as a key-value pair
      final response = await http.post(
        FetchCourse,
        body: {'yearLevelID': yearLevelID}, // Use a map to send the data
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Retrieved data: $data'); // Print the retrieved data
        setState(() {
          courses = (data['data'] as List)
              .map((courseJson) => Course.fromJson(courseJson))
              .toList();
          isLoadingCourses = false; // Stop loading when data is fetched
        });
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (error) {
      print('Error fetching courses: $error');
      setState(() {
        isLoadingCourses = false; // Stop loading on error
      });
    }
  }

  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Voter'), // Set the title of your AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Your image preview logic here
              imageFile == null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: const Icon(
                  Icons.person,
                  size: 200,
                  color: Colors.grey,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: Image.file(
                  imageFile!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {

                  if (Platform.isAndroid) {
                    PermissionStatus storagePermission;
                    if (await Permission.photos.isGranted) {
                      storagePermission = await Permission.photos.request();
                    } else {
                      storagePermission =
                      await Permission.mediaLibrary.request();
                    }

                    if (storagePermission.isGranted) {
                      PermissionStatus cameraPermission =
                      await Permission.camera.request();

                      if (cameraPermission.isGranted) {
                        showImagePicker(context);
                      } else if (cameraPermission.isDenied) {
                        // Show snackbar if Camera permission is denied
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Camera permission denied")),
                        );
                      } else if (cameraPermission.isPermanentlyDenied) {
                        // Handle permanently denied case by redirecting to app settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Camera permission is permanently denied. Please enable it from settings.")),
                        );
                        await openAppSettings();
                      }
                    }
                  }
                },
                child: const Text("Select Image"),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // TextField widget
                  Expanded(
                    child: TextField(
                      controller: studentIdController,
                      // enabled: false, // Disable editing
                      decoration: InputDecoration(
                        hintText: "Student ID",
                        filled: true, // Enable filling the background
                        fillColor:
                        Colors.white, // Set the background color to white
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Add border radius if desired
                          borderSide: BorderSide(
                              color:
                              Colors.grey.shade300), // Light grey border
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),

                  // Camera Icon outside the TextField
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      // Open the QR scanner and wait for the result
                      final scannedId = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScanner(isForLogin: false, onScanComplete: _onScanComplete),
                        ),
                      );

                      // If a result was returned, update the TextField with the scanned ID
                      if (scannedId != null) {
                        setState(() {
                          studentIdController.text =
                              scannedId; // Populate the TextField
                        });
                      }
                    },
                  ),
                ],
              ),
              // const TextField(
              //   decoration: InputDecoration(hintText: "Student ID"),
              //   style: TextStyle(color: Colors.white),
              // ),
              const SizedBox(height: 10),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: "First Name",
                  filled: true, // Enable filling the background
                  fillColor:
                  Colors.white, // Set the background color to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Add border radius if desired
                    borderSide: BorderSide(
                        color: Colors.grey.shade300), // Light grey border
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: "Last Name",
                  filled: true, // Enable filling the background
                  fillColor:
                  Colors.white, // Set the background color to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Add border radius if desired
                    borderSide: BorderSide(
                        color: Colors.grey.shade300), // Light grey border
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true, // Enable filling the background
                  fillColor:
                  Colors.white, // Set the background color to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Add border radius if desired
                    borderSide: BorderSide(
                        color: Colors.grey.shade300), // Light grey border
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  hintText: "Age",
                  filled: true, // Enable filling the background
                  fillColor:
                  Colors.white, // Set the background color to white
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Add border radius if desired
                    borderSide: BorderSide(
                        color: Colors.grey.shade300), // Light grey border
                  ),
                ),
                style: TextStyle(
                    color: Colors
                        .black), // Change text color to black for visibility
              ),
              const SizedBox(height: 10),
              // Year Level Dropdown
              // Year Level Dropdown
              isLoadingYearLevels
                  ? CircularProgressIndicator() // Show loading indicator while fetching data
                  : DropdownButtonFormField<String>(
                value: yearLevelController.text.isNotEmpty
                    ? yearLevelController.text
                    : null,
                decoration: InputDecoration(
                  hintText: "Year Level",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                ),
                items: yearLevels.map((YearLevel yearLevel) {
                  return DropdownMenuItem<String>(
                    value: yearLevel.id, // Use the ID for the value
                    child: Text(
                      yearLevel.title,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    yearLevelController.text = newValue ?? '';
                    selectedYearLevelTitle = yearLevels.firstWhere((element) => element.id == newValue).title; // Store the title
                    fetchCourses(newValue ?? ''); // Fetch courses based on selected year level ID
                    courseController.clear(); // Clear course selection
                    selectedCourseTitle = ''; // Reset course title
                    courses.clear(); // Clear the course list
                  });
                },
                isExpanded: true,
                style: TextStyle(color: Colors.black),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),

              const SizedBox(height: 10),

                // Course Dropdown
              isLoadingCourses
                  ? CircularProgressIndicator() // Show loading indicator while fetching courses
                  : DropdownButtonFormField<String>(
                value: courseController.text.isNotEmpty
                    ? courseController.text
                    : null,
                decoration: InputDecoration(
                  hintText: "Course",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 15.0),
                ),
                items: courses.map((Course course) {
                  return DropdownMenuItem<String>(
                    value: course.id,
                    child: Text(
                      course.title,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    courseController.text = newValue ?? '';
                    selectedCourseTitle = courses.firstWhere((element) => element.id == newValue).title; // Store the title
                  });
                },
                isExpanded: true,
                style: TextStyle(color: Colors.black),
                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.center, // Adjust alignment as needed
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                    ),
                    child: const Text('Reset'),
                    onPressed: () {
                      setState(() {
                        // Clear all text fields
                        studentIdController.clear();
                        firstNameController.clear();
                        lastNameController.clear();
                        yearLevelController.clear();
                        courseController.clear();

                        // Reset the image to the default one
                        imageFile = null;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade100,
                    ),
                    child: const Text('Submit'),
                    onPressed: () {
                      Navigator.pop(
                          context); // Close the form before submitting
                      _submitForm(); // Call a function to handle the submission
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    AddVoters(
      studentId: studentIdController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      yearLevel: selectedYearLevelTitle,
      course: selectedCourseTitle,
      age: ageController.text,
      email: emailController.text,
      imageFile: imageFile,
      onSuccess: () {
        // fetchVoters();// Close the bottom sheet
        // Reset all fields
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VotersList()),
        );
        studentIdController.clear();
        firstNameController.clear();
        lastNameController.clear();
        yearLevelController.clear();
        courseController.clear();
        ageController.clear();
        emailController.clear();
        setState(() {
          imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data submitted successfully!")),
        );

      },
    ).submitData(context);
  }

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(Icons.image, size: 60.0),
                        SizedBox(height: 12.0),
                        Text("Gallery", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black)),
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt, size: 60.0),
                          SizedBox(height: 12.0),
                          Text("Camera", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black)),
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imgFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
  }

  Future<void> _imgFromCamera() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error capturing image from camera: $e");
    }
  }

  void _onScanComplete() {
    setState(() {

    });
  }
}
