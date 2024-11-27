import 'dart:convert';
import 'dart:typed_data'; // Import this to use Uint8List
import 'package:flutter/material.dart';
import 'package:voting_system/global/model/my_candidates.dart';

class CandidatesCard extends StatefulWidget {
  final Candidate candidate;
  final bool isForVoting;

  const CandidatesCard(
      {super.key, required this.candidate, this.isForVoting = true});

  @override
  State<CandidatesCard> createState() => _CandidatesCardState();
}

class _CandidatesCardState extends State<CandidatesCard> {
  @override
  Widget build(BuildContext context) {
    // Convert Base64 image string to Uint8List
    Uint8List imageBytes = base64Decode(widget.candidate.image
        .split(',')
        .last); // Remove data URL prefix if present

    return Container(
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Use SizedBox to maintain space for the icon
              SizedBox(
                width: 40, // Set a fixed width to maintain layout
                child: widget.isForVoting
                    ? const Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.red,
                      )
                    : null, // Will not render anything if not for voting
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10, top: 15),
                child: SizedBox(), // Extra space if needed when icon is absent
              ),
            ],
          ),
          SizedBox(
            height: 130,
            width: 130,
            child: ClipOval(
              child: Image.memory(
                imageBytes,
                fit: BoxFit.cover,
                width: 130, // Set width to match the SizedBox
                height: 130, // Set height to match the SizedBox
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.candidate.name,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          Text(
            widget.candidate.section,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
