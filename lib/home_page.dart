import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shareloc/models/user_location.dart';
import 'package:shareloc/pages/create_room.dart';
import 'package:shareloc/pages/join_room.dart';
import 'package:shareloc/services/room_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = new Location();

  TextEditingController roomCodeController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkRoomExist(String roomCode) async {
    bool result = await RoomService.getRoomExist(roomCode);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = context.watch<UserLocation>();
    print(userLocation.latitude);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(24),
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('ShareLoc',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 24,
              ),
              TextField(
                  controller: roomCodeController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'room code',
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
                    onPressed: () async {
                      bool room = await checkRoomExist(roomCodeController.text);
                      if (room) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => JoinRoomPage(
                                    roomCode: roomCodeController.text)));
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text('Room Not Found!'),
                              content: new Text('Room with code never exist'),
                              actions: <Widget>[
                                new GestureDetector(
                                  child: new Text("OK"),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Join',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600))),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width * 0.6),
                height: MediaQuery.of(context).size.height * 0.05,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    onPressed: () {
                      roomCodeController.text = '';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CreateRoomPage()));
                    },
                    child: Text('Create Room',
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
