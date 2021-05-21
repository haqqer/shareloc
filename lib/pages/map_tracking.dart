import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shareloc/data/endpoint.dart';
import 'package:shareloc/home_page.dart';
import 'package:shareloc/models/room.dart';
import 'package:shareloc/models/room_participant.dart';
import 'package:shareloc/services/room_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:ui' as ui;

const double CAMERA_ZOOM = 14;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 0;

class MapTracking extends StatefulWidget {
  final String roomCode;
  final int participantId;
  MapTracking({Key key, this.roomCode, this.participantId}) : super(key: key);
  @override
  _MapTrackingState createState() => _MapTrackingState();
}

class _MapTrackingState extends State<MapTracking> {
  IO.Socket socket;
  LocationData currentLocation;
  Location location = new Location();
  StreamSubscription<LocationData> locationSubscription;
  List<RoomParticipant> listParticipants = [];
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    connectSocket();
    setInitialLocation();
    locationSubscription =
        location.onLocationChanged.listen((LocationData cLoc) {
      print('update data');
      currentLocation = cLoc;
      updatePinOnMap();
      // roomParticipantsUpdate();
      socket.emit('updateLocation', <String, dynamic>{
        "id": widget.participantId,
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      });
    });
  }

  void connectSocket() {
    try {
      socket = IO.io(BASE_URL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
      socket.connect();
    } catch (e) {
      print(e);
    }
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }

  void quitRoom() async {
    bool result =
        await RoomService.updateQuitRoom(widget.roomCode, widget.participantId);
    if (!result) {
      Navigator.of(context).pop(false);
    } else {
      Navigator.of(context).pop(true);
    }
  }

  quitDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit an App'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                quitRoom();
                Navigator.of(context).pop(true);
              },
              child: Text("YES"),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return quitDialog() ?? false;
  }

  void showPinsOnMap() async {
    var response = await RoomService.getRoomParticipantsUpdate(widget.roomCode);
    var _roomParticipants = response['roomParticipants'];
    listParticipants = Room.parseParticipant(_roomParticipants);
    for (var e in listParticipants) {
      Uint8List customTextMarker;
      customTextMarker = await getBytesFromCanvas(e.name);
      setState(() {
        final MarkerId markerId = MarkerId(e.id.toString());
        markers.add(Marker(
            markerId: markerId,
            icon: BitmapDescriptor.fromBytes(customTextMarker),
            position:
                LatLng(double.parse(e.latitude), double.parse(e.longitude))));
      });
    }
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    var response = await RoomService.getRoomParticipantsUpdate(widget.roomCode);
    var _roomParticipants = response['roomParticipants'];
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    listParticipants = Room.parseParticipant(_roomParticipants);
    markers = {};
    for (var e in listParticipants) {
      Uint8List customTextMarker;
      customTextMarker = await getBytesFromCanvas(e.name);
      setState(() {
        final MarkerId markerId = MarkerId(e.id.toString());
        markers.add(Marker(
            markerId: markerId,
            icon: BitmapDescriptor.fromBytes(customTextMarker),
            position:
                LatLng(double.parse(e.latitude), double.parse(e.longitude))));
      });
    }
  }

  Future<Uint8List> getBytesFromCanvas(String text) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()
      ..color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    final int size = 100; //change this according to your app
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text, //you can write your own text here or take from parameter
      style: TextStyle(
          fontSize: size / 4, color: Colors.black, fontWeight: FontWeight.bold),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: LatLng(-6.9859062, 110.414304));

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude));
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ShareLoc'),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              markers: markers,
              // markers: _markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                showPinsOnMap();
              },
            ),
            SlidingUpPanel(
              isDraggable: false,
              minHeight: MediaQuery.of(context).size.height * 0.23,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              collapsed: Container(
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text('Room Code below :'),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Center(
                                child: Text(widget.roomCode,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ),
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            child: GestureDetector(
                              child: Icon(Icons.copy),
                              onTap: () {
                                FlutterClipboard.copy(widget.roomCode)
                                    .then((value) {
                                  final snackBar = SnackBar(
                                    content: Text('Copied to Clipboard'),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0)))),
                        onPressed: () {
                          quitDialog();
                        },
                        child: Text(
                          'End Session',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              panel: Center(child: Text('hello')),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    locationSubscription.cancel();
    super.dispose();
  }
}
