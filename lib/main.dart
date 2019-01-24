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
//        accentColor: Colors.grey,
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
  int _counter = 0;
  var sensors = [new Sensor("Camera's")];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(sensors.length, (index) {
            return Text(sensors[index].name);
          })
        ),
      ),
    );
  }
}
