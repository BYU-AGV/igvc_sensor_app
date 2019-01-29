import 'package:flutter/material.dart';
import 'package:igvc/Cameras.dart';
import 'package:igvc/imu.dart';
import 'server.dart';
import 'package:sensors/sensors.dart';
import 'server.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IGVC Sensors',
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
  MyHomePage({Key key, this.title}) : super(key: key) {
    accelerometerEvents.listen((event) {
      if (server.status == ServerStatus.CONNECTED) {
        print("Got data");
        server.sendData(IMUEvent(event.x, event.y, event.z));
      }
    });
  }
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ServerStatus state;
  String serverURL;

  @override
  Widget build(BuildContext context) {
    var sensors = [
      new Cameras.def(),
      new IMU.def(),
      new Cameras(title: "GPS", icon: Icons.gps_fixed),
      new Cameras(title: "Compass", icon: Icons.navigation),
      new Cameras(title: "Fingerprint", icon: Icons.fingerprint),
      new Cameras(title: "NFC", icon: Icons.nfc),
      new Cameras(title: "Proximity", icon: Icons.format_size),
      new Cameras(title: "Gyroscope", icon: Icons.blur_circular)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                (serverURL == null || serverURL == "") ? "Connect to Server" : "Server: " + serverURL,
                style: Theme.of(context).textTheme.title,
              ),
              onTap: () async {
                final result = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return ServerDialog();
                    });
                server.connect(result);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: List.generate(sensors.length, (index) {
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => sensors[index].buildPage()),
                  );
                },
                child: Container(
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
                ),
              );
            })),
      ),
    );
  }

//  @override
//  void initState() {
//    super.initState();
//    server.addStateListener(() {
//      state = server.status;
//    });
//  }
}
