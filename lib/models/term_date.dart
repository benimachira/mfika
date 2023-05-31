class TermDate {
  int id;
  int status;
  String name;
  DateTime start;
  DateTime ends;
  String year;
  DateTime createdAt;
  DateTime updatedAt;

  TermDate({
    required this.id,
    required this.status,
    required this.name,
    required this.start,
    required this.ends,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermDate.fromJson(Map<String, dynamic> json) {
    return TermDate(
      id: json['id'],
      status: json['status'],
      name: json['name'],
      start: DateTime.parse(json['start']),
      ends: DateTime.parse(json['ends']),
      year: json['year'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'name': name,
      'start': start.toIso8601String(),
      'ends': ends.toIso8601String(),
      'year': year,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
