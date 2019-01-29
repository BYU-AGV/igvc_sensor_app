import 'server.dart';
import 'dart:convert';

class GPSEvent extends Serializable {
  Map<String, double> info;

  GPSEvent(this.info);

  @override
  String toJson() {
    // TODO: implement toJson
    var body = {};
//    body['latitude'] = info['latitude'];
    return json.encode(info);
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }

}