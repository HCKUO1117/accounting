import 'package:flutter/material.dart';

class TagModel {
  int? id;
  Color color;
  String name;

  TagModel({
    this.id,
    required this.color,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'color':color.value,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'id : $id\ncolor : $color \nname : $name';
  }
}
