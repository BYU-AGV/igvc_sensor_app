import 'package:flutter/material.dart';
import 'package:igvc/sensors/sensor.dart';
import 'package:camera/camera.dart';

class Cameras implements Sensor {
  @override
  IconData icon;

  @override
  String title;

  Cameras({this.title, this.icon});

  Cameras.def() {
    this.title = "Camera's";
    this.icon = Icons.camera_alt;
  }

  @override
  Widget buildPage() {
    // TODO: implement buildPage
    return CameraApp();
//    return CamerasPage(title: title,);
  }
}

class CamerasPage extends StatefulWidget {
  CamerasPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _CamerasPageState();
}

class _CamerasPageState extends State<CamerasPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Text("Body"),
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
      setState(() {});
      availableCameras().then((list) {
        setState(() {
          cameras = list;
          controller = CameraController(cameras[0], ResolutionPreset.high);
          controller.initialize().then((_) {
            if (!mounted) {
              return;
            }
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    if (cameras == null) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
