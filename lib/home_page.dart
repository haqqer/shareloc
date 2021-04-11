import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shareloc/pages/create_room.dart';
import 'package:shareloc/pages/join_room.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  TextEditingController roomCodeController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationPermission();
  }

  void getLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => JoinRoomPage(
                                  roomCode: roomCodeController.text)));
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
    // TODO: implement dispose
    super.dispose();
  }
}
