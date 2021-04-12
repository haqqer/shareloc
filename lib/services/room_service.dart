import 'dart:convert';

import 'package:shareloc/models/room.dart';
import 'package:shareloc/models/room_participant.dart';
import 'package:shareloc/utils/request.dart';

Future<Map<String, dynamic>> postRoomAndJoin(
    Room room, RoomParticipant roomParticipant) async {
  try {
    var response = await request().post('/room/join',
        data: json.encode({
          'name': room.name,
          'desc': room.desc,
          'username': roomParticipant.name,
          'status': roomParticipant.status,
          'latitude': roomParticipant.latitude,
          'longitude': roomParticipant.longitude
        }));
    return response.data['data'];
  } catch (e) {
    print(e);
    return <String, dynamic>{'error': 'intinte error'};
  }
}

Future<Map<String, dynamic>> postJoinRoom(
    String code, RoomParticipant roomParticipant) async {
  try {
    var response = await request()
        .post('/room/code/' + code, data: roomParticipant.toJson());
    return response.data['data'];
  } catch (e) {
    print(e);
    return <String, dynamic>{'error': e.toString()};
  }
}

Future<Map<String, dynamic>> getRoomParticipantsUpdate(String code) async {
  try {
    var response = await request().get('/room/code/' + code);
    return response.data['data'];
  } catch (e) {
    print(e);
    return <String, dynamic>{'error': e.toString()};
  }
}
