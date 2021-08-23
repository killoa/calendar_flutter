
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Event {
  final String title;
  Event({@required this.title});

  String toString() => this.title;
}