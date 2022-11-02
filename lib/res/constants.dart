import 'package:accounting/db/category_model.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String hadOpen = 'hadOpen';
  static const String setIcon = 'setIcon';
  static const String goalNum = 'goalNum';
  static const String previousVersion = 'previousVersion';

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

  ///ad
  static const bool testingMode = true;
  static const String testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testBackAdId = 'ca-app-pub-3940256099942544/3419835294';

  static const String bannerId = 'ca-app-pub-9063356592993842/3684734841';
  static const String interstitialAdId = 'ca-app-pub-9063356592993842/3301591466';
  static const String backAdId = 'ca-app-pub-9063356592993842/7428538738';

  ///feedback
  static const List<String> feedbackTypes = [
    'recommendation',
    'errorReport',
    'usageProblem',
    'other',
  ];
}
