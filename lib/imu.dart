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
  double accel_x, accel_y, accel_z;
  List<charts.Series> chartData;

  Widget _buildTile(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.all(Radius.circular(16)),
//          boxShadow: List<BoxShadow> [
//
//          ],
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

  List<charts.Series<IMUData, int>> _generateData() {
    var data = [
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
      new IMUData(DateTime.now(), 0),
    ];

    return [
      new charts.Series(id: 'IMU', data: data, domainFn: (IMUData imu,  _) => imu.acceleration.toInt(), measureFn: (IMUData imu, _) => imu.acceleration)
    ];
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
          _buildTile("X: " + accel_x.toString()),
          _buildTile("Y: " + accel_y.toString()),
          _buildTile("Z: " + accel_z.toString()),
          new charts.LineChart(chartData, animate: true,)
        ],
      ),
    );
  }

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      setState(() {
        accel_x = event.x;
        accel_y = event.y;
        accel_z = event.z;
      });
    });
  }
}

/// Class holding info about each event
class IMUData {
  DateTime time;
  final double acceleration;

  IMUData(this.time, this.acceleration);
}
