import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomAlertDialog({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20), // Add padding for content
      content: Column(
        mainAxisSize: MainAxisSize.min, // Make the column take only as much space as needed
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.blue, // Customize icon color
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center, // Center the text
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.bottomRight, // Align the button to the bottom right
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}