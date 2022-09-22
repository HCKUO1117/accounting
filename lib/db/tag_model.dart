import 'package:flutter/material.dart';

class TagModel {
  int? id;
  String icon;
  Color color;
  String name;

  TagModel({
    this.id,
    required this.icon,
    required this.color,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'iconColor':color,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'id : $id\nicon : $icon \ncolor : $color \nname : $name';
  }
}
