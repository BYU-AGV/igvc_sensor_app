import 'package:flutter/material.dart';
import 'sensor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.grey,
//        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'IGVC Sensors'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var sensors = [
      new Sensor(title: "Camera's", icon: Icons.camera_alt),
      new Sensor(title: "IMU", icon: Icons.accessibility),
      new Sensor(title: "Compass", icon: Icons.navigation),
      new Sensor(title: "Fingerprint", icon: Icons.fingerprint),
      new Sensor(title: "NFC", icon: Icons.nfc)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: List.generate(sensors.length, (index) {
              return Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        sensors[index].icon,
                        color: Colors.grey[300],
                        size: 128,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          sensors[index].title,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })),
      ),
    );
  }
}
