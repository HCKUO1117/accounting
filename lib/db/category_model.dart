import 'package:flutter/material.dart';

enum CategoryType {
  income,
  expenditure,
}

extension CategoryTypeEx on CategoryType {
  String get text {
    switch (this) {
      case CategoryType.income:
        return 'income';
      case CategoryType.expenditure:
        return 'expenditure';
    }
  }
}

class CategoryModel {
  int? id;
  int sort;
  CategoryType type;
  String icon;
  Color iconColor;
  String name;

  CategoryModel({
    this.id,
    required this.sort,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'icon': icon,
      'sort': sort,
      'iconColor':iconColor.value,
      'name': name,
      'type':type.text
    };
  }

  @override
  String toString() {
    return '\nid : $id\nicon : $icon \niconColor : ${iconColor.value} \nname : $name \ntype : ${type.text}\nsort: sort,';
  }
}
