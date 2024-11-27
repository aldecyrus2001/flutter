import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as https;
import 'package:voting_system/admin/screen/partylist_list.dart';

import '../../assets/global/global.dart';
import '../admin_entry_point.dart';

class Addpartylist extends StatefulWidget {
  const Addpartylist({super.key});

  @override
  State<Addpartylist> createState() => _AddpartylistState();
}

class _AddpartylistState extends State<Addpartylist> {
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController platformcontroller = new TextEditingController();

  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  storagePermission = await Permission.mediaLibrary.request();
                }
                if (storagePermission.isGranted) {
                  PermissionStatus cameraPermission =
                      await Permission.camera.request();
                  if (cameraPermission.isGranted) {
                    showImagePicker(context);
                  } else if (cameraPermission.isDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("camera permission denied")),
                    );
                  } else if (cameraPermission.isPermanentlyDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("camera permission is permanently denied.")));
                    await openAppSettings();
                  }
                }
              }
            },
            child: const Text("Select Image"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: titlecontroller,
            decoration: InputDecoration(
              hintText: "Party List Name",
              filled: true, // Enable filling the background
              fillColor: Colors.white, // Set the background color to white
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Add border radius if desired
                borderSide: BorderSide(
                    color: Colors.grey.shade300), // Light grey border
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
          TextField(
            controller: platformcontroller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Platform",
              filled: true, // Enable filling the background
              fillColor: Colors.white, // Set the background color to white
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Add border radius if desired
                borderSide: BorderSide(
                    color: Colors.grey.shade300), // Light grey border
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                ),
                child: const Text('Reset'),
                onPressed: () {
                  setState(() {
                    // Clear all text fields
                    titlecontroller.clear();
                    platformcontroller.clear();

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
                  Navigator.pop(context); // Close the form before submitting
                  _submitForm(
                      titlecontroller.text,
                      platformcontroller
                          .text); // Call a function to handle the submission
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm(String partylistName, String platform) async {
    final request = https.MultipartRequest('POST', AddPartyList);

    request.fields['partylistName'] = partylistName;
    request.fields['platform'] = platform;

    if (imageFile != null) {
      request.files
          .add(await https.MultipartFile.fromPath('image', imageFile!.path));
    }

    final response = await request.send();

    final responseString = await response.stream.bytesToString();
    final Map<String, dynamic> responseData = json.decode(responseString);

    if (responseData['statusCode'] == 200) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminEntryPoint(
            initialScreen: const PartylistList(), // Pass the initial screen here
          ),
        ),
      );
    } else {
      print("Failed to submit data, Status Code: ${response.statusCode}");
    }

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
                        Text("Gallery",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
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
                          Text("Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black)),
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
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
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
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error capturing image from camera: $e");
    }
  }
}
