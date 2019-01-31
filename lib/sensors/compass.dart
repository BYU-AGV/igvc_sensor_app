import 'package:flutter/material.dart';
import 'package:igvc/server.dart';
import 'dart:convert';
import 'sensor.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math';

class Compass extends Sensor {
  Compass({String title, IconData icon});

  Compass.def() : super(title: "Compass", icon: Icons.navigation);

  @override
  Widget buildPage() {
    // TODO: implement buildPage
    return CompassPage(
      title: title,
    );
  }
}

class CompassPage extends StatefulWidget {
  CompassPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => CompassPageState();
}

class CompassPageState extends State<CompassPage> {
  bool _dropped = false;
  double _heading;

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          _buildTile("Heading: " + _heading.toString()),
          new Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: new Transform.rotate(
                  angle: (((_heading ?? 0) + 30) * (pi / 180) * -1),
                  child: new Image.asset(
                    'images/compass.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dropped = false;
    FlutterCompass.events.listen((double heading) {
      if (_dropped != true) {
        setState(() {
          _heading = heading;
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

class CompassEvent implements Serializable {
  double heading;

  CompassEvent(this.heading);

  @override
  String toJson() {
    // TODO: implement toJson
    var body = {};
    body['heading'] = heading;
    return json.encode(body);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    var body = {};
    body['heading'] = heading;
    return body;
  }
}
