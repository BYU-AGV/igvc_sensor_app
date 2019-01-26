import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class ServerDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ServerDialogState();
}

class ServerDialogState extends State<ServerDialog> {
  final TextEditingController controller = new TextEditingController();
  bool serverPinged = false;
  bool pinging = false;

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
                Navigator.pop(context, controller.text);
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
