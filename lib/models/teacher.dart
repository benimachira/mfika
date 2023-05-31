class Teacher {
  final dynamic id;
  final dynamic name;
  final dynamic email;
  final dynamic userType;
  final dynamic phoneNum;
  final dynamic staffNum;
  final dynamic idNum;
  final dynamic emailVerifiedAt;
  final dynamic passwordChanged;
  final dynamic usingApp;
  final dynamic grade;
  final dynamic vehicleId;
  final dynamic randNumber;
  final dynamic expireAt;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic activeStatus;
  final dynamic avatar;
  final dynamic darkMode;
  final dynamic messengerColor;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.phoneNum,
    required this.staffNum,
    required this.idNum,
    this.emailVerifiedAt,
    required this.passwordChanged,
    required this.usingApp,
    required this.grade,
    this.vehicleId,
    this.randNumber,
    this.expireAt,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
    required this.avatar,
    required this.darkMode,
    this.messengerColor,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      phoneNum: json['phone_num'],
      staffNum: json['staff_num'],
      idNum: json['id_num'],
      emailVerifiedAt: json['email_verified_at'] != 'null'
          ? DateTime.parse(json['email_verified_at'])
          : 'null',
      passwordChanged: json['password_changed'],
      usingApp: json['using_app'],
      grade: json['grade'],
      vehicleId: json['vehicle_id'],
      randNumber: json['rand_number'],
      expireAt:
      json['expire_at'] != 'null' ? DateTime.parse(json['expire_at']) : 'null',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      activeStatus: json['active_status'],
      avatar: json['avatar'],
      darkMode: json['dark_mode'],
      messengerColor: json['messenger_color'],
    );
  }
}
