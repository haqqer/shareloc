import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareloc/models/room_participant.dart';
import 'package:shareloc/models/user_location.dart';
import 'package:shareloc/pages/map_tracking.dart';
import 'package:shareloc/services/room_service.dart';

class JoinRoomPage extends StatefulWidget {
  final String roomCode;
  JoinRoomPage({Key key, this.roomCode}) : super(key: key);
  @override
  _JoinRoomPageState createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  bool isLoading = false;
  UserLocation userLocation = UserLocation();

  RoomParticipant roomParticipant = new RoomParticipant();
  TextEditingController nameController = new TextEditingController();
  int participantId;

  @override
  void initState() {
    super.initState();
  }

  void setValueToModel() {
    setState(() {
      roomParticipant = RoomParticipant(
          name: nameController.text,
          status: true,
          latitude: userLocation.latitude.toString(),
          longitude: userLocation.longitude.toString());
    });
  }

  void joinRoom() async {
    var result =
        await RoomService.postJoinRoom(widget.roomCode, roomParticipant);
    // participantId = result['id'];
    print(result);
    setState(() {
      participantId = result['id'];
      if (participantId != null) {
        isLoading = false;
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext build) => MapTracking(
              roomCode: widget.roomCode, participantId: participantId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _userLocation = Provider.of<UserLocation>(context);
    userLocation = _userLocation;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 3,
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Join Room ${widget.roomCode}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 24,
              ),
              TextField(
                  autofocus: true,
                  maxLength: 5,
                  controller: nameController,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'your name',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30))))),
              SizedBox(
                height: 24,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width * 0.4),
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24)))),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      setValueToModel();
                      joinRoom();
                      // print(participantId);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (BuildContext context) => MapTracking(
                      //           roomCode: widget.roomCode,
                      //           participantId: participantId)),
                      // );
                    },
                    child: Text('Join',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
