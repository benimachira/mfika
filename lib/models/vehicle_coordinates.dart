class VehicleCoordinatesModel {
  final dynamic vehicleId;
  final dynamic time;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic title;
  final dynamic plate;
  final dynamic head;
  final dynamic speed;

  VehicleCoordinatesModel({
    required this.vehicleId,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.plate,
    required this.head,
    required this.speed,
  });

  factory VehicleCoordinatesModel.fromJson(Map<String, dynamic> json) {
    return VehicleCoordinatesModel(
      vehicleId: json['vehicle_id'],
      time: json['time'],
      latitude: json['lat'],
      longitude: json['lng'],
      title: json['title'],
      plate: json['plate'],
      head: json['head'],
      speed: json['speed'],
    );
  }
}

class StudentHomeCoordinatesModel {
  final dynamic studentName;
  final dynamic latitude;
  final dynamic longitude;

  StudentHomeCoordinatesModel({
    required this.studentName,
    required this.latitude,
    required this.longitude,
  });

  factory StudentHomeCoordinatesModel.fromJson(Map<String, dynamic> json) {
    return StudentHomeCoordinatesModel(
      studentName: json['std_name'],
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}

class TripModel {
  final dynamic id;
  final dynamic vehicleId;
  final dynamic title;
  final dynamic time;
  final dynamic timeFrom;
  final dynamic timeTo;
  final dynamic createdAt;
  final dynamic updatedAt;

  TripModel({
    required this.id,
    required this.vehicleId,
    required this.title,
    required this.time,
    required this.timeFrom,
    required this.timeTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      title: json['title'],
      time: json['time'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class SchoolLocationModel {
  final dynamic latitude;
  final dynamic longitude;

  SchoolLocationModel({
    required this.latitude,
    required this.longitude,
  });

  factory SchoolLocationModel.fromJson(Map<String, dynamic> json) {
    return SchoolLocationModel(
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}

class DataModel {
  final VehicleCoordinatesModel vehicleCoordinates;
  final StudentHomeCoordinatesModel studentHomeCoordinates;
  final TripModel trip;
  final SchoolLocationModel schoolLocation;

  DataModel({
    required this.vehicleCoordinates,
    required this.studentHomeCoordinates,
    required this.trip,
    required this.schoolLocation,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      vehicleCoordinates: VehicleCoordinatesModel.fromJson(json['vehicle_coordinates']),
      studentHomeCoordinates: StudentHomeCoordinatesModel.fromJson(json['student_home_coordinates']),
      trip: TripModel.fromJson(json['trip']),
      schoolLocation: SchoolLocationModel.fromJson(json['school_location']),
    );
  }
}