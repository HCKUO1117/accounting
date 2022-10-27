import 'package:accounting/db/category_model.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String hadOpen = 'hadOpen';
  static const String setIcon = 'setIcon';
  static const String goalNum = 'goalNum';

  static List<CategoryModel> defaultCategories = [
    CategoryModel(
      sort: 0,
      type: CategoryType.income,
      icon: 'directions_car',
      name: '123',
      iconColor: Colors.redAccent,
    )
  ];

  ///notification
  static const List<String> weeks = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  static const List<String> weeksShort = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
    'sun',
  ];

  static const announcementText = 'announcement_';
}
