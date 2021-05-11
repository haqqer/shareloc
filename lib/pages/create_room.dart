import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shareloc/models/room.dart';
import 'package:shareloc/models/room_participant.dart';
import 'package:shareloc/models/user_location.dart';
import 'package:shareloc/pages/map_tracking.dart';
import 'package:shareloc/services/room_service.dart';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController roomNameController = new TextEditingController();
  TextEditingController roomDescController = new TextEditingController();
  bool isLoading = false;
  // LocationData currentLocation;
  // Location location = new Location();
  UserLocation userLocation = UserLocation();

  Room room = new Room();
  RoomParticipant roomParticipant = new RoomParticipant();
  String roomCode;
  int participantId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setInitialLocation();
  }

  // void setInitialLocation() async {
  //   currentLocation = await location.getLocation();
  // }

  void setValueToModel() {
    setState(() {
      room = Room(
          name: roomNameController.text,
          desc: roomDescController.text,
          code: '');
      roomParticipant = RoomParticipant(
          name: userNameController.text,
          status: true,
          latitude: userLocation.latitude.toString(),
          longitude: userLocation.longitude.toString());
    });
  }

  void createRoomAndJoin() async {
    var result = await RoomService.postRoomAndJoin(room, roomParticipant);
    setState(() {
      roomCode = result['code'].toString();
      participantId = result['participantId'];
      if (roomCode != null) {
        isLoading = false;
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext build) =>
              MapTracking(roomCode: roomCode, participantId: participantId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _userLocation = Provider.of<UserLocation>(context);
    userLocation = _userLocation;
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Create Room',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 24,
            ),
            TextField(
                autofocus: true,
                controller: userNameController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'your name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))))),
            Divider(
              height: 48,
              thickness: 3,
            ),
            TextField(
                autofocus: true,
                controller: roomNameController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'room name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))))),
            SizedBox(
              height: 20,
            ),
            TextField(
                autofocus: true,
                controller: roomDescController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'room desc',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))))),
            SizedBox(
              height: 24,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width -
                  (MediaQuery.of(context).size.width * 0.6),
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    setValueToModel();
                    createRoomAndJoin();
                  },
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text('Create Room',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ))),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
