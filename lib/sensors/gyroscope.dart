import 'package:flutter/material.dart';
import 'package:igvc/server.dart';
import 'dart:convert';
import 'sensor.dart';
import 'package:sensors/sensors.dart';

class Gyroscope extends Sensor {
  Gyroscope({String title, IconData icon});
  Gyroscope.def() : super(title: "Gyroscope", icon: Icons.blur_circular);

  @override
  Widget buildPage() {
    // TODO: implement buildPage
    return GyroscopePage(title: title,);
  }
}

class GyroscopePage extends StatefulWidget {
  GyroscopePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => GyroscopePageState();
}

class GyroscopePageState extends State<GyroscopePage> {
  double _x = 0;
  double _y = 0;
  double _z = 0;
  bool _dropped = false;

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
          _buildTile("X rad/sec: " + _x.toString()),
          _buildTile("Y rad/sec: " + _y.toString()),
          _buildTile("Z rad/sec: " + _z.toString()),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dropped = false;
    gyroscopeEvents.listen((event) {
      if (_dropped != true) {
        setState(() {
          _x = event.x;
          _y = event.y;
          _z = event.z;
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

class GyroEvent implements Serializable {
  double x, y, z;

  GyroEvent(this.x, this.y, this.z);

  @override
  String toJson() {
    // TODO: implement toJson
    var body = {};
    body['x'] = x;
    body['y'] = y;
    body['z'] = z;
    return json.encode(body);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }
}