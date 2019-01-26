import 'package:flutter/material.dart';
import 'package:igvc/sensor.dart';
import 'package:sensors/sensors.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class IMU extends Sensor {
  IMU({String title, IconData icon});

  IMU.def() : super(title: "IMU", icon: Icons.accessibility);

  @override
  Widget buildPage() {
    // TODO: implement buildPage
    return IMUPage(
      title: title,
    );
  }
}

class IMUPage extends StatefulWidget {
  IMUPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => IMUPageState();
}

class IMUPageState extends State<IMUPage> {
  double accel_x, accel_y, accel_z, user_x, user_y, user_z;
  List<charts.Series> chartData;
  bool dropped = false;

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

  // Builds the tile to display the sensor data
  Widget _buildTitle(String title) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          _buildTitle("Accelorometer"),
          _buildTile("X: " + accel_x.toString()),
          _buildTile("Y: " + accel_y.toString()),
          _buildTile("Z: " + accel_z.toString()),
          _buildTitle("User Accelorometer"),
          _buildTile("X: " + user_x.toString()),
          _buildTile("Y: " + user_y.toString()),
          _buildTile("Z: " + user_z.toString()),
        ],
      ),
    );
  }

  // Set the accelerometer callbacks
  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      if (dropped != true) {
        setState(() {
          accel_x = event.x;
          accel_y = event.y;
          accel_z = event.z;
        });
      }
    });
    userAccelerometerEvents.listen((event) {
      if (dropped != true) {
        setState(() {
          user_x = event.x;
          user_y = event.y;
          user_z = event.z;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    dropped = true;
  }
}

/// Class holding info about each event
class IMUData {
  DateTime time;
  final double acceleration;

  IMUData(this.time, this.acceleration);
}
