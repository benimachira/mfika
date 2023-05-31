class OtherUsers {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic userType;
  dynamic phoneNum;
  dynamic staffNum;
  dynamic idNum;
  dynamic emailVerifiedAt;
  dynamic passwordChanged;
  dynamic usingApp;
  dynamic grade;
  dynamic stream;
  dynamic vehicleId;
  dynamic randNumber;
  dynamic expireAt;
  dynamic isParentTwo;
  dynamic isOther;
  dynamic linkedTo;
  dynamic image;
  dynamic gender;
  dynamic relationship;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic activeStatus;
  dynamic avatar;
  dynamic darkMode;
  dynamic messengerColor;

  OtherUsers({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.phoneNum,
    this.staffNum,
    required this.idNum,
    this.emailVerifiedAt,
    required this.passwordChanged,
    required this.usingApp,
    this.grade,
    this.stream,
    this.vehicleId,
    this.randNumber,
    this.expireAt,
    required this.isParentTwo,
    required this.isOther,
    required this.linkedTo,
    this.image,
    this.gender,
    this.relationship,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
    required this.avatar,
    required this.darkMode,
    this.messengerColor,
  });

  factory OtherUsers.fromJson(Map<String, dynamic> json) {
    return OtherUsers(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      phoneNum: json['phone_num'],
      staffNum: json['staff_num'],
      idNum: json['id_num'],
      emailVerifiedAt: json['email_verified_at'],
      passwordChanged: json['password_changed'],
      usingApp: json['using_app'],
      grade: json['grade'],
      stream: json['stream'],
      vehicleId: json['vehicle_id'],
      randNumber: json['rand_number'],
      expireAt: json['expire_at'],
      isParentTwo: json['is_parent_two'],
      isOther: json['is_other'],
      linkedTo: json['linked_to'],
      image: json['image'],
      gender: json['gender'],
      relationship: json['relationship'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      activeStatus: json['active_status'],
      avatar: json['avatar'],
      darkMode: json['dark_mode'],
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
      'email_verified_at': emailVerifiedAt,
      'password_changed': passwordChanged,
      'using_app': usingApp,
      'grade': grade,
      'stream': stream,
      'vehicle_id': vehicleId,
      'rand_number': randNumber,
      'expire_at': expireAt,
      'is_parent_two': isParentTwo,
      'is_other': isOther,
      'linked_to': linkedTo,
      'image': image,
      'gender': gender,
      'relationship': relationship,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'active_status': activeStatus,
      'avatar': avatar,
      'dark_mode': darkMode,
      'messenger_color': messengerColor,
    };
  }
}
