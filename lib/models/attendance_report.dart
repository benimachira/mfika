class AttendanceReport {
  final String name;
  final String grade;
  final List<Absence> flagOff;

  AttendanceReport({
    required this.name,
    required this.grade,
    required this.flagOff,
  });

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      name: json['name'],
      grade: json['grade'],
      flagOff: (json['flag_off'] as List<dynamic>)
          .map((item) => Absence.fromJson(item))
          .toList(),
    );
  }
}

class Absence {
  final int id;
  final int parentId;
  final int studentId;
  final String reason;
  final DateTime date;

  Absence({
    required this.id,
    required this.parentId,
    required this.studentId,
    required this.reason,
    required this.date,
  });

  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      parentId: json['parent_id'],
      studentId: json['student_id'],
      reason: json['reason'],
      date: DateTime.parse(json['date']),
    );
  }
}
