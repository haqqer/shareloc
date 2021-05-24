import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shareloc/models/room.dart';
import 'package:shareloc/models/room_participant.dart';
import 'package:shareloc/utils/request.dart';

class RoomService {
  static Future<Map<String, dynamic>> postRoomAndJoin(
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

  static Future<bool> getRoomExist(String roomCode) async {
    try {
      var response = await request().get('/room/code/' + roomCode);
      print(response.statusCode);
      return true;
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        return false;
      }
      return false;
    }
  }

  static Future<Map<String, dynamic>> postJoinRoom(
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

  static Future<Map<String, dynamic>> getRoomParticipantsUpdate(
      String code) async {
    try {
      var response = await request().get('/room/code/' + code + '?status=1');
      return response.data['data'];
    } catch (e) {
      print(e);
      return <String, dynamic>{'error': e.toString()};
    }
  }

  static Future<bool> updateQuitRoom(String code, int userId) async {
    try {
      var response = await request().put('/room/quit',
          data: <String, dynamic>{'code': code, 'userId': userId});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
