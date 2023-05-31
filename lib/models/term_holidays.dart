class TermHoliday {
  final int id;
  final int termId;
  final String name;
  final String start;
  final String ends;
  final String year;
  final String createdAt;
  final String updatedAt;

  TermHoliday({
    required this.id,
    required this.termId,
    required this.name,
    required this.start,
    required this.ends,
    required this.year,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermHoliday.fromJson(Map<String, dynamic> json) {
    return TermHoliday(
      id: json['id'],
      termId: json['term_id'],
      name: json['name'],
      start: json['start'],
      ends: json['ends'],
      year: json['year'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term_id': termId,
      'name': name,
      'start': start,
      'ends': ends,
      'year': year,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
