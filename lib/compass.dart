import 'server.dart';
import 'dart:convert';

class CompassEvent implements Serializable {
  double heading;

  CompassEvent(this.heading);

  @override
  String toJson() {
    // TODO: implement toJson
    var body = {};
    body['heading'] = heading;
    return json.encode(body);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    var body = {};
    body['heading'] = heading;
    return body;
  }

}