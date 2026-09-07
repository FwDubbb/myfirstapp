import 'package:flutter/material.dart';

class StudyClass {
  const StudyClass({
    required this.id,
    required this.name,
    this.color = Colors.indigo,
  });

  final int id;
  final String name;
  final Color color;
}
