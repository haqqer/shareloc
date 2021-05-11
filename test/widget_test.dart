// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shareloc/data/endpoint.dart';
import 'package:shareloc/models/room_participant.dart';
import 'package:shareloc/services/room_service.dart';
import 'package:shareloc/utils/request.dart';

void main() {
  group('http request module test', () {
    test('Get data from rooms', () async {
      var response = await getRoomParticipantsUpdate(1);
      expect(response['name'], equals('test'));
    });
    test('Room Participant Join', () async {
      RoomParticipant roomParticipant = RoomParticipant(
          name: 'test', status: true, latitude: '0.1', longitude: '-0.1');
      var response = await postJoinRoom('coba-dua-9748', roomParticipant);
      print(response);
      expect(response['name'], equals('test'));
    });
  });
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
