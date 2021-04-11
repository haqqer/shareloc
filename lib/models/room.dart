import 'package:shareloc/models/room_participant.dart';

class Room {
  int id;
  String name;
  String desc;
  String code;

  Room({this.id, this.name, this.desc, this.code});

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        desc = json['desc'],
        code = json['code'];

  static List<RoomParticipant> parseParticipant(List<dynamic> items) {
    return items
        .map<RoomParticipant>((item) => RoomParticipant.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'desc': desc,
        'code': code,
      };
}
