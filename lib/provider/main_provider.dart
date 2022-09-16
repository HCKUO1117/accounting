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
}
