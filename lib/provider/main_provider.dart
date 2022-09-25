import 'dart:math';

import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/tag_db.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainProvider with ChangeNotifier {
  ///dashboard
  DateTime dashBoardStartDate = DateTime.now();
  DateTime dashBoardEndDate = DateTime.now();

  ///Category
  List<CategoryModel> categoryIncomeList = [];
  List<CategoryModel> categoryExpenditureList = [];

  ///Tag
  List<TagModel> tagList = [];

  bool get samDay =>
      dashBoardStartDate.year == dashBoardEndDate.year &&
      dashBoardStartDate.month == dashBoardEndDate.month &&
      dashBoardStartDate.day == dashBoardEndDate.day;

  void setDashBoardDateRange(PickerDateRange range) {
    if (range.startDate != null) {
      dashBoardStartDate = range.startDate!;
    }
    if (range.endDate != null) {
      dashBoardEndDate = range.endDate!;
    } else if (range.startDate != null && range.endDate == null) {
      dashBoardEndDate = range.startDate!;
    }
    notifyListeners();
  }

  Future<void> setDefaultDB() async {
    final hadOpen = Preferences.getBool(Constants.hadOpen, false);
    if (!hadOpen) {
      for (var element in Constants.defaultCategories) {
        await CategoryDB.insertData(element);
      }
    }
    await Preferences.setBool(Constants.hadOpen, true);
  }

  Future<void> getCategoryList() async {
    final List<CategoryModel> list = await CategoryDB.displayAllData();
    categoryIncomeList = [];
    categoryExpenditureList = [];
    for (var element in list) {
      if (element.type == CategoryType.income) {
        categoryIncomeList.add(element);
      } else {
        categoryExpenditureList.add(element);
      }
    }
    categoryIncomeList.sort((a, b) => a.sort.compareTo(b.sort));
    categoryExpenditureList.sort((a, b) => a.sort.compareTo(b.sort));
    notifyListeners();
  }

  Future<void> getTagList() async {
    final List<TagModel> list = await TagDB.displayAllData();
    tagList = [];
    for (var element in list) {
      tagList.add(element);
    }
    tagList.sort((a, b) => a.sort.compareTo(b.sort));
    notifyListeners();
  }
}
