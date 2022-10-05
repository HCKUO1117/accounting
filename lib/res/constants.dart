import 'package:accounting/db/category_model.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String hadOpen = 'hadOpen';
  static const String setIcon = 'setIcon';
  static const String goalType = 'goalType';
  static const String goalNum = 'goalNum';
  static const String goalDate = 'goalDate';
  static const String goalStartDate = 'goalStartDate';

  static List<CategoryModel> defaultCategories = [
    CategoryModel(
      sort: 0,
      type: CategoryType.income,
      icon: 'directions_car',
      name: '123',
      iconColor: Colors.redAccent,
    )
  ];
}
