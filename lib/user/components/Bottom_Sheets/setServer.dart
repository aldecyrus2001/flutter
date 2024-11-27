import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../assets/global/global.dart';

class SetServer extends StatefulWidget {
  const SetServer({super.key});

  @override
  State<SetServer> createState() => _SetServerState();
}

class _SetServerState extends State<SetServer> {
  final TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Set IP Address"),
      content: TextField(
        controller: ipController,
        decoration: const InputDecoration(
          labelText: 'Enter IP Address',
          hintText: 'e.g., 192.168.1.1',
          fillColor: Colors.white
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String ipAddress = ipController.text;
            if (ipAddress.isNotEmpty) {
              setState(() {
                IpAddress = ipAddress;  // Modify the global variable
              });
              Navigator.of(context).pop(); // Close the dialog after submission
            } else {
              // Show a message if the field is empty
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid IP address')),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

}
