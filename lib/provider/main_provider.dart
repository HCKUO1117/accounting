import 'package:accounting/db/category_db.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainProvider with ChangeNotifier {
  ///dashboard
  DateTime dashBoardStartDate = DateTime.now();
  DateTime dashBoardEndDate = DateTime.now();

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

  void setDefaultDB() {
    final hadOpen = Preferences.getBool(Constants.hadOpen, false);
    if (!hadOpen) {
      CategoryDB.initDataBase();
      for (var element in Constants.defaultCategories) {
        CategoryDB.insertData(element);
      }
    }
    Preferences.setBool(Constants.hadOpen, true);
  }
}
