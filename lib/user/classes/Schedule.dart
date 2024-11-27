class Schedule {
  final int schedID;
  final String schedTitle;
  final String schedStart;
  final String schedEnd;

  Schedule({
    required this.schedID,
    required this.schedTitle,
    required this.schedStart,
    required this.schedEnd,
  });

  // Factory method to create a Schedule from a map (from JSON)
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      schedID: json['schedID'],
      schedTitle: json['schedTitle'],
      schedStart: json['schedStart'],
      schedEnd: json['schedEnd'],
    );
  }
}
