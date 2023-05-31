class Child {
  final dynamic id;
  final dynamic vehicleId;
  final dynamic parentId;
  final dynamic firstName;
  final dynamic lastName;
  final dynamic grade;
  final dynamic lat;
  final dynamic lng;
  final dynamic latDrop;
  final dynamic lngDrop;
  final dynamic pickUp;
  final dynamic confirmPickupParent;
  final dynamic confirmPickupDriver;
  final dynamic pickupChanged;
  final dynamic parentTwo;
  final dynamic other;
  final dynamic image;
  final dynamic admission_num;

  Child({
    required this.id,
    required this.vehicleId,
    required this.parentId,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.lat,
    required this.lng,
    required this.latDrop,
    required this.lngDrop,
    required this.pickUp,
    required this.confirmPickupParent,
    required this.confirmPickupDriver,
    required this.pickupChanged,
    required this.parentTwo,
    required this.other,
    required this.admission_num,
    this.image,
  });

  factory Child.fromJson(Map<dynamic, dynamic> json) {
    return Child(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      parentId: json['parent_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      grade: json['grade'],
      lat: json['lat'],
      lng: json['lng'],
      latDrop: json['lat_drop'],
      lngDrop: json['lng_drop'],
      pickUp: json['pick_up'],
      confirmPickupParent: json['confirm_pickup_parent'],
      confirmPickupDriver: json['confirm_pickup_driver'],
      pickupChanged: json['pickup_changed'],
      parentTwo: json['parent_two'],
      other: json['other'],
      image: json['image'],
      admission_num: json['admission_num'],
    );
  }
}
