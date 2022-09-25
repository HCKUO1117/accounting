import 'package:flutter/material.dart';

class TagModel {
  int? id;
  int sort;
  Color color;
  String name;

  TagModel({
    this.id,
    required this.sort,
    required this.color,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'sort':sort,
      'color':color.value,
      'name': name,
    };
  }

  @override
  String toString() {
    return '\nid : $id\ncolor : $color \nname : $name\nsort : $sort';
  }
}
