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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SimpleDialog(
      title: Text("Ping Server"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Server ip and port"
            ),
            controller: controller,
          ),
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
                  http.get(url).then((response) {
                    print("Response recieved");
                    print(response.toString());
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FlatButton(
                textColor: Colors.red,
                child: Text("CLOSE"),
                onPressed: () {
                  Navigator.pop(context, "192.168.226.132");
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}