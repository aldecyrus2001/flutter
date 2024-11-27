class Position {
  final String positionID;
  final String positionTitle;
  final int maxCandidate;
  final int maxVote;

  Position({
    required this.positionID,
    required this.positionTitle,
    required this.maxCandidate,
    required this.maxVote,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      positionID: json['positionID'],
      positionTitle: json['positionTitle'],
      maxCandidate: int.parse(json['maxCandidate']),
      maxVote: int.parse(json['maxVote']),
    );
  }
}