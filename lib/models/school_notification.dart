class SchoolNotification {
  dynamic id;
  dynamic type;
  dynamic notifiableType;
  dynamic notifiableId;
  dynamic data;
  dynamic readAt;
  dynamic createdAt;
  dynamic updatedAt;

  SchoolNotification({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SchoolNotification.fromJson(Map<String, dynamic> json) {
    return SchoolNotification(
      id: json['id'],
      type: json['type'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      data: Data.fromJson(json['data']),
      readAt: json['read_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'data': data.toJson(),
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Data {
  String? msg;
  String? haeder;
  String? body;

  Data({this.msg, this.haeder, this.body});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      msg: json['msg'],
      haeder: json['haeder'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'haeder': haeder,
      'body': body,
    };
  }
}
