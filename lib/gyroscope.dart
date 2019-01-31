import 'server.dart';
import 'dart:convert';

class GyroEvent implements Serializable {
  double x, y, z;

  GyroEvent(this.x, this.y, this.z);

  @override
  String toJson() {
    // TODO: implement toJson
    var body = {};
    body['x'] = x;
    body['y'] = y;
    body['z'] = z;
    return json.encode(body);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }

}