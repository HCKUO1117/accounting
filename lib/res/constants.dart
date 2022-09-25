import 'package:accounting/db/category_model.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String hadOpen = 'hadOpen';
  static String setIcon = 'setIcon';

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
