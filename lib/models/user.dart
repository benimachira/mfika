class User {
  final int id;
  final String name;
  final String email;
  final String userType;
  final String phoneNum;
  final String? staffNum;
  final String idNum;
  final bool passwordChanged;
  final bool usingApp;
  final String? grade;
  final String avatar;
  final bool darkMode;
  final String? messengerColor;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.phoneNum,
    this.staffNum,
    required this.idNum,
    required this.passwordChanged,
    required this.usingApp,
    this.grade,
    required this.avatar,
    required this.darkMode,
    this.messengerColor,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      phoneNum: json['phone_num'],
      staffNum: json['staff_num'],
      idNum: json['id_num'],
      passwordChanged: json['password_changed'] == 1,
      usingApp: json['using_app'] == 1,
      grade: json['grade'],
      avatar: json['avatar'],
      darkMode: json['dark_mode'] == 1,
      messengerColor: json['messenger_color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'phone_num': phoneNum,
      'staff_num': staffNum,
      'id_num': idNum,
      'password_changed': passwordChanged ? 1 : 0,
      'using_app': usingApp ? 1 : 0,
      'grade': grade,
      'avatar': avatar,
      'dark_mode': darkMode ? 1 : 0,
      'messenger_color': messengerColor,
    };
  }
}
