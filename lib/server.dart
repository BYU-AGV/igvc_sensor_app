import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum ServerStatus {PINGING, CONNECTED, DISCONNECTED, ERROR}
Server instance;

abstract class Serializable {
  String toJson();
  Map<String, dynamic> toMap();
}

Server get server {
  if (instance == null) {
    instance = new Server();
    print("Creating new server instance");
  }
  return instance;
}

class Server {
  ServerStatus _status = ServerStatus.DISCONNECTED;
  List<VoidCallback> _onServerStateChange;
  static List<VoidCallback> _stateChangeCallbacks = [];
  http.Client client;
  String serverURI;

  Server() {
    client = http.Client();
    _status = ServerStatus.DISCONNECTED;
  }

  void addStateListener(VoidCallback callback) {
    _onServerStateChange.add(callback);
  }

  static void addChangeListener(VoidCallback callback) {
    _stateChangeCallbacks.add(callback);
  }

  void _changeServerState(ServerStatus status) {
    _status = status;
    Server._triggerStateChange();
  }

  ServerStatus get status => _status;

  // Triggers the listeners
  static void _triggerStateChange() {
    for (var call in _stateChangeCallbacks) {
      call();
    }
  }

  // Pings a server and returns whether or not the server is active
  Future<bool> pingServer(String uri) async {
    await http.get(uri).then((response) {
      return true;
    });
    return false;
  }

  void disconnect() {
    _changeServerState(ServerStatus.DISCONNECTED);
  }

  Future<bool> connect(String url) async {
    print("Pinging: " + url);
    _changeServerState(ServerStatus.PINGING);
    await pingServer(url + '/ping').then((bool) {
      print("Connected");
      serverURI = url;
      _changeServerState(ServerStatus.CONNECTED);
      return true;
    });
    return false;
  }

  Future<bool> sendData(String extension, Serializable data) async {
    if (_status == ServerStatus.CONNECTED) {
//      print("Sending data: " + serverURI + '/webhook/accelerometer');
      print("Data: " + data.toJson().toString());
      await client.post(serverURI + extension, body: data.toJson()).then((response) {
        return true;
      }).catchError((error) {
        print(error);
//        _changeServerState(ServerStatus.ERROR);
      });
    }
    return false;
  }
}

class ServerDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServerDialogState();
}

class ServerDialogState extends State<ServerDialog> {
  final TextEditingController controller = new TextEditingController();
  bool serverPinged = false;
  bool pinging = false;
  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    setUp();
  }

  void setUp() async {
    prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('serverURL');
    controller.text = str;
  }

  Widget _buildServerStatus() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: pinging
          ? Text(
              "Pinging",
              style: TextStyle(color: Colors.blue),
            )
          : serverPinged
              ? Text(
                  "Success",
                  style: TextStyle(color: Colors.green),
                )
              : Text(
                  "No connection",
                  style: TextStyle(color: Colors.red),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
      title: Text("Ping Server"),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Server ip and port"),
                controller: controller,
                onChanged: (text) {
                  setState(() {
                    serverPinged = false;
                  });
                },
              ),
            ),
            _buildServerStatus()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: FlatButton(
                textColor: Colors.blue,
                child: Text("PING"),
                onPressed: () {
                  var url = 'http://' + controller.text + '/ping';
                  print("Attempting to connect to: " + url);
                  var uri = new Uri.http(controller.text, '/ping');
                  setState(() {
                    pinging = true;
                  });
                  http.get(url).then((response) {
                    print("Response recieved");
                    print(response.toString());
                    setState(() {
                      serverPinged = true;
                      pinging = false;
                    });
                  });
                },
              ),
            ),
            OutlineButton(
              highlightedBorderColor: Colors.green,
              child: Text("CONNECT",),
              borderSide: BorderSide(color: Colors.green),
              onPressed: () {
                Navigator.pop(context, "http://" + controller.text);
              },
              textColor: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FlatButton(
                textColor: Colors.red,
                child: Text("CLOSE"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
