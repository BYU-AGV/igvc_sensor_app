import 'package:flutter/cupertino.dart';

abstract class Sensor {
  String title;
  IconData icon;

  Sensor({this.title, this.icon});

  Widget buildPage();
}