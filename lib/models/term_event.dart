class TermEvent {
  final int id;
  final int termId;
  final String name;
  final bool pickup;
  final DateTime start;
  final DateTime ends;
  final String startTime;
  final String endTime;
  final String year;
  final DateTime createdAt;
  final DateTime updatedAt;

  TermEvent({
    required this.id,
    required this.termId,
    required this.name,
    required this.pickup,
    required this.start,
    required this.ends,
    required this.startTime,
    required this.endTime,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermEvent.fromJson(Map<String, dynamic> json) {
    return TermEvent(
      id: json['id'],
      termId: json['term_id'],
      name: json['name'],
      pickup: json['pickup'] == 1,
      start: DateTime.parse(json['start']),
      ends: DateTime.parse(json['ends']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      year: json['year'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term_id': termId,
      'name': name,
      'pickup': pickup ? 1 : 0,
      'start': start.toIso8601String(),
      'ends': ends.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'year': year,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
