import 'package:flutter/material.dart';
import 'package:igvc/server.dart';
import 'dart:convert';
import 'sensor.dart';
import 'package:location/location.dart';

class GPS extends Sensor {
  GPS({String title, IconData icon});
  GPS.def() : super (title: "GPS", icon: Icons.gps_fixed);

  @override
  Widget buildPage() {
    // TODO: implement buildPage
    return GPSPage(title: title,);
  }
}

class GPSPage extends StatefulWidget {
  GPSPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => GPSPageState();
}

class GPSPageState extends State<GPSPage> {
  final location = Location();
  double _longitude = 0;
  double _latitude = 0;
  double _altitude = 0;
  double _speed = 0;
  double _accuracy = 0;
  bool _dropped = true;

  Widget _buildTile(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            text,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          _buildTile("Longitude: " + _longitude.toString()),
          _buildTile("Latitude: " + _latitude.toString()),
          _buildTile("Altitude: " + _altitude.toString()),
          _buildTile("Accuracy: " + _accuracy.toString()),
          _buildTile("Speed: " + _speed.toString()),
        ],
      ),
    );
  }

  @override
  void initState() {
   super.initState();
   _dropped = false;
    location.onLocationChanged().listen((Map<String, double> loc) {
      if (_dropped != true) {
        setState(() {
          _longitude = loc['longitude'];
          _latitude = loc['latitude'];
          _altitude = loc['altitude'];
          _accuracy = loc['accuracy'];
          _speed = loc['speed'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dropped = true;
  }
}

class GPSEvent implements Serializable {
  Map<String, double> info;

  GPSEvent(this.info);

  @override
  String toJson() {
    // TODO: implement toJson
    var body = {};
//    body['latitude'] = info['latitude'];
    return json.encode(info);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }

}