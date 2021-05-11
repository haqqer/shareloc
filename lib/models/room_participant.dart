class RoomParticipant {
  int id;
  String name;
  bool status;
  String latitude;
  String longitude;

  RoomParticipant(
      {this.id, this.name, this.status, this.latitude, this.longitude});

  RoomParticipant.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        status = json['status'],
        latitude = json['latitude'] ?? '',
        longitude = json['longitude'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'latitude': latitude,
        'longitude': longitude,
      };
}
