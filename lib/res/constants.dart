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
      type: CategoryType.expenditure,
      icon: 'fastfood',
      name: '餐飲',
      iconColor: Colors.redAccent,
    ),
    CategoryModel(
      sort: 1,
      type: CategoryType.expenditure,
      icon: 'shopping_bag',
      name: '服飾',
      iconColor: Colors.blue,
    ),
    CategoryModel(
      sort: 2,
      type: CategoryType.expenditure,
      icon: 'commute',
      name: '交通',
      iconColor: Colors.grey,
    ),
    CategoryModel(
      sort: 3,
      type: CategoryType.expenditure,
      icon: 'home',
      name: '家庭',
      iconColor: Colors.limeAccent,
    ),
    CategoryModel(
      sort: 4,
      type: CategoryType.expenditure,
      icon: 'flight_takeoff',
      name: '旅遊',
      iconColor: Colors.deepOrange,
    ),
    CategoryModel(
      sort: 5,
      type: CategoryType.expenditure,
      icon: 'school',
      name: '教育',
      iconColor: Colors.lightBlueAccent,
    ),
    CategoryModel(
      sort: 6,
      type: CategoryType.expenditure,
      icon: 'healing',
      name: '健康',
      iconColor: Colors.green,
    ),
    CategoryModel(
      sort: 7,
      type: CategoryType.expenditure,
      icon: 'videogame_asset',
      name: '娛樂',
      iconColor: Colors.purpleAccent,
    ),
    CategoryModel(
      sort: 8,
      type: CategoryType.expenditure,
      icon: 'people',
      name: '社交',
      iconColor: Colors.pinkAccent,
    ),
    CategoryModel(
      sort: 0,
      type: CategoryType.income,
      icon: 'account_balance_wallet_outlined',
      name: '薪水',
      iconColor: Colors.blue,
    ),
    CategoryModel(
      sort: 1,
      type: CategoryType.income,
      icon: 'account_balance',
      name: '投資',
      iconColor: Colors.amber,
    ),
    CategoryModel(
      sort: 2,
      type: CategoryType.income,
      icon: 'family_restroom',
      name: '家人',
      iconColor: Colors.teal,
    ),
    CategoryModel(
      sort: 3,
      type: CategoryType.income,
      icon: 'paid',
      name: '租金',
      iconColor: Colors.cyanAccent,
    ),
    CategoryModel(
      sort: 4,
      type: CategoryType.income,
      icon: 'emoji_events',
      name: '獎金',
      iconColor: Colors.deepOrangeAccent,
    ),
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
