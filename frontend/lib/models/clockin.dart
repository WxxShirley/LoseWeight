import 'package:flutter/material.dart';

class Clockin{
  final String todo;
  final String detail;
  final IconData icon;
  final Color itemColor;
  final DateTime timestamp;
  final bool finish;

  Clockin({this.todo, this.detail, this.icon, this.itemColor, this.timestamp, this.finish});
}