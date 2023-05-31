class BusData {
  final Bus amBus;
  final Bus pmBus;

  BusData({required this.amBus, required this.pmBus});

  factory BusData.fromJson(Map<String, dynamic> json) {
    return BusData(
      amBus: Bus.fromJson(json['am bus']),
      pmBus: Bus.fromJson(json['pm bus']),
    );
  }
}

class Bus {
  final Vehicle vehicle;
  final Driver driver;
  final Attendant attendant;

  Bus({required this.vehicle, required this.driver, required this.attendant});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      vehicle: Vehicle.fromJson(json['vehicle']),
      driver: Driver.fromJson(json['driver']),
      attendant: Attendant.fromJson(json['attendant']),
    );
  }
}

class Vehicle {
  final  id;
  final dynamic driverId;
  final dynamic attendantId;
  final dynamic routeId;
  final dynamic title;
  final dynamic plateNum;
  final dynamic numOfSeats;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic head;
  final dynamic speed;
  final dynamic image;
  final dynamic createdAt;
  final dynamic updatedAt;

  Vehicle({
    required this.id,
    required this.driverId,
    required this.attendantId,
    required this.routeId,
    required this.title,
    required this.plateNum,
    required this.numOfSeats,
    required this.latitude,
    required this.longitude,
    required this.head,
    required this.speed,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      driverId: json['driver_id'],
      attendantId: json['attendant_id'],
      routeId: json['route_id'],
      title: json['title'],
      plateNum: json['plate_num'],
      numOfSeats: json['num_of_seats'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      head: json['head'],
      speed: json['speed'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Driver {
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
  final dynamic stream;
  final dynamic vehicleId;
  final dynamic randNumber;
  final dynamic expireAt;
  final dynamic isParentTwo;
  final dynamic isOther;
  final dynamic linkedTo;
  final dynamic image;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic activeStatus;
  final dynamic avatar;
  final dynamic darkMode;
  final dynamic messengerColor;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.phoneNum,
    required this.staffNum,
    required this.idNum,
    required this.emailVerifiedAt,
    required this.passwordChanged,
    required this.usingApp,
    required this.grade,
    required this.stream,
    required this.vehicleId,
    required this.randNumber,
    required this.expireAt,
    required this.isParentTwo,
    required this.isOther,
    required this.linkedTo,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
    required this.avatar,
    required this.darkMode,
    required this.messengerColor,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      activeStatus: json['active_status'],
      avatar: json['avatar'],
      darkMode: json['dark_mode'],
      messengerColor: json['messenger_color'],
    );
  }
}

class Attendant {
  final dynamic id;
  final dynamic name;
  final dynamic email;
  final dynamic userType;
  final dynamic phoneNumber;
  final dynamic staffNumber;
  final dynamic idNumber;
  final DateTime? emailVerifiedAt;
  final dynamic passwordChanged;
  final dynamic usingApp;
  final dynamic? grade;
  final dynamic? stream;
  final dynamic? vehicleId;
  final dynamic? randNumber;
  final DateTime? expireAt;
  final dynamic isParentTwo;
  final dynamic isOther;
  final dynamic? linkedTo;
  final dynamic image;
  final dynamic gender;
  final dynamic? relationship;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic activeStatus;
  final dynamic avatar;
  final dynamic darkMode;
  final dynamic? messengerColor;

  Attendant({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.phoneNumber,
    required this.staffNumber,
    required this.idNumber,
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
    this.linkedTo,
    required this.image,
    required this.gender,
    this.relationship,
    required this.createdAt,
    required this.updatedAt,
    required this.activeStatus,
    required this.avatar,
    required this.darkMode,
    this.messengerColor,
  });

  factory Attendant.fromJson(Map<String, dynamic> json) {
    return Attendant(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type'],
      phoneNumber: json['phone_num'],
      staffNumber: json['staff_num'],
      idNumber: json['id_num'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      passwordChanged: json['password_changed'],
      usingApp: json['using_app'],
      grade: json['grade'],
      stream: json['stream'],
      vehicleId: json['vehicle_id'],
      randNumber: json['rand_number'],
      expireAt: json['expire_at'] != null
          ? DateTime.parse(json['expire_at'])
          : null,
      isParentTwo: json['is_parent_two'],
      isOther: json['is_other'],
      linkedTo: json['linked_to'],
      image: json['image'],
      gender: json['gender'],
      relationship: json['relationship'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      activeStatus: json['active_status'],
      avatar: json['avatar'],
      darkMode: json['dark_mode'],
      messengerColor: json['messenger_color'],
    );
  }
}


// // Merge the provided JSON into the existing model
// void mergeData(BusData existingData, Map<String, dynamic> newData) {
//   existingData.amBus.vehicle = Vehicle.fromJson(newData['am bus']['vehicle']);
//   existingData.amBus.driver = Driver.fromJson(newData['am bus']['driver']);
//   existingData.amBus.attendant = Attendant.fromJson(newData['am bus']['attendant']);
//
//   existingData.pmBus.vehicle = Vehicle.fromJson(newData['pm bus']['vehicle']);
//   existingData.pmBus.driver = Driver.fromJson(newData['pm bus']['driver']);
//   existingData.pmBus.attendant = Attendant.fromJson(newData['pm bus']['attendant']);
// }
