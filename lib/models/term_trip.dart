import 'dart:convert';

class SchoolTrip {
  final dynamic id;
  final dynamic name;
  final List<General> general;
  final List<General> tripsWithGrade;

  SchoolTrip({
    required this.id,
    required this.name,
    required this.general,
    required this.tripsWithGrade,
  });

  factory SchoolTrip.fromJson(Map<String, dynamic> json) {
    return SchoolTrip(
      id: json["id"],
      name: json["name"],
      general: List<General>.from(json["general"].map((x) => General.fromJson(x))),
      tripsWithGrade: List<General>.from(json["trips_with_grade"].map((x) => General.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "general": List<dynamic>.from(general.map((x) => x.toJson())),
      "trips_with_grade": List<dynamic>.from(tripsWithGrade.map((x) => x.toJson())),
    };
  }
}

class General {
  final dynamic id;
  final dynamic tripName;
  final List<dynamic> destinationName;
  final List<Teacher> teachers;
  final List<Vehicle> vehicles;
  final dynamic tripOriginLatLng;
  final dynamic tripDestinationLatLng;
  final dynamic status;
  final dynamic grade;
  final dynamic price;
  final dynamic tripDate;
  final dynamic departureTime;
  final dynamic returnTime;
  final dynamic hasMoreDestinations;
  final dynamic? wayPointOne;
  final dynamic? wayPointTwo;
  final dynamic? wayPointThree;
  final dynamic? wayPointFour;
  final dynamic? wayPointFive;
  final dynamic? wayPointSix;
  final dynamic? wayPointSeven;
  final dynamic? wayPointEight;

  General({
    required this.id,
    required this.tripName,
    required this.destinationName,
    required this.teachers,
    required this.vehicles,
    required this.tripOriginLatLng,
    required this.tripDestinationLatLng,
    required this.status,
    required this.grade,
    required this.price,
    required this.tripDate,
    required this.departureTime,
    required this.returnTime,
    required this.hasMoreDestinations,
    this.wayPointOne,
    this.wayPointTwo,
    this.wayPointThree,
    this.wayPointFour,
    this.wayPointFive,
    this.wayPointSix,
    this.wayPointSeven,
    this.wayPointEight,
  });

  factory General.fromJson(Map<dynamic, dynamic> json) {
    return General(
      id: json["id"],
      tripName: json["trip_name"],
      destinationName: List<String>.from(json["destination_name"].map((x) => x)),
      teachers: List<Teacher>.from(json["teachers"].map((x) => Teacher.fromJson(x))),
      vehicles: List<Vehicle>.from(json["vehicles"].map((x) => Vehicle.fromJson(x))),
      tripOriginLatLng: json["trip_origin_lat_lng"],
      tripDestinationLatLng: json["trip_destination_lat_lng"],
      status: json["status"],
      grade: json["grade"],
      price: json["price"],
      tripDate: json["trip_date"],
      departureTime: json["departure_time"],
      returnTime: json["return_time"],
      hasMoreDestinations: json["has_more_destinations"],
      wayPointOne: json["way_point_one"],
      wayPointTwo: json["way_point_two"],
      wayPointThree: json["way_point_three"],
      wayPointFour: json["way_point_four"],
      wayPointFive: json["way_point_five"],
      wayPointSix: json["way_point_six"],
      wayPointSeven: json["way_point_seven"],
      wayPointEight: json["way_point_eight"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "trip_name": tripName,
      "destination_name": List<dynamic>.from(destinationName.map((x) => x)),
      "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
      "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
      "trip_origin_lat_lng": tripOriginLatLng,
      "trip_destination_lat_lng": tripDestinationLatLng,
      "status": status,
      "grade": grade,
      "price": price,
      "trip_date": tripDate,
      "departure_time": departureTime,
      "return_time": returnTime,
      "has_more_destinations": hasMoreDestinations,
      "way_point_one": wayPointOne,
      "way_point_two": wayPointTwo,
      "way_point_three": wayPointThree,
      "way_point_four": wayPointFour,
      "way_point_five": wayPointFive,
      "way_point_six": wayPointSix,
      "way_point_seven": wayPointSeven,
      "way_point_eight": wayPointEight,
    };
  }
}

class Teacher {
  final dynamic id;
  final dynamic name;
  final dynamic email;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json["id"],
      name: json["name"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }
}
class Vehicle {
  final dynamic id;
  final dynamic name;
  final dynamic type;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"],
      name: json["name"],
      type: json["type"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "type": type,
    };
  }
}