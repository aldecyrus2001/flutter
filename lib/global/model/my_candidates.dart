class Candidate {
  final String id;
  final String userID;
  final String name;
  final String position;
  final String image; // Base64 image string
  final String section;
  final String age;
  final String motto;

  Candidate({
    required this.id,
    required this.userID,
    required this.name,
    required this.position,
    required this.image, // Base64 image string
    required this.section,
    required this.age,
    required this.motto,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {

    return Candidate(
      id: json['candidateID'].toString(), // Adjusted to match your PHP structure
      userID: json['userID'] ?? '', // Handle potential null value
      name: '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(), // Combine names if needed
      position: json['position'] ?? '', // Provide a default empty string if null
      image: json['image'] ?? '', // Base64 image string, default to empty
      section: '${json['yearLevel'] ?? ''} ${json['course'] ?? ''}'.trim(), // Default to empty string if null
      age: json['age']?.toString() ?? '', // Safely handle potential null value
      motto: json['platform'] ?? '', // Assuming 'platform' is your motto, default to empty
    );
  }
}
