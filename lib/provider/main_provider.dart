import 'dart:async';

import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/fixed_income_db.dart';
import 'package:accounting/db/fixed_income_model.dart';
import 'package:accounting/db/record_tag_db.dart';
import 'package:accounting/db/record_tag_model.dart';
import 'package:accounting/db/tag_db.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';

class MainProvider with ChangeNotifier {
  ///dashboard
  DateTime dashBoardStartDate = DateTime.now();
  DateTime dashBoardEndDate = DateTime.now();
  double currentIncome = 0;
  double currentExpenditure = 0;

  int selectedValue = 0;

  double get balance => currentIncome + currentExpenditure;

  bool get allEmpty => currentIncome == 0 && currentExpenditure == 0;

  ///Category
  List<CategoryModel> categoryList = [];
  List<CategoryModel> categoryIncomeList = [];
  List<CategoryModel> categoryExpenditureList = [];

  ///Tag
  List<TagModel> tagList = [];

  ///accounting
  List<AccountingModel> accountingList = [];
  List<AccountingModel> currentAccountingList = [];

  ///goal
  double get goalNum => double.parse(Preferences.getString(Constants.goalNum, '-1'));

  ///fixed income
  List<FixedIncomeModel> fixedIncomeList = [];

  bool get samDay =>
      dashBoardStartDate.year == dashBoardEndDate.year &&
      dashBoardStartDate.month == dashBoardEndDate.month &&
      dashBoardStartDate.day == dashBoardEndDate.day;

  ///insert fixed data
  Timer? timer;

  void checkInsertData() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      DateTime d = DateTime.now();
      for (var element in fixedIncomeList) {
        switch (element.type) {
          case FixedIncomeType.eachDay:
            for (DateTime i = element.lastAddTime ?? element.createDate;
                !Utils.checkIsSameDay(i, d.add(const Duration(days: 1)));
                i = DateTime(i.year, i.month, i.day + 1)) {
              print('day $i');
            }
            break;
          case FixedIncomeType.eachMonth:
            for (DateTime i = element.lastAddTime ?? element.createDate;
                !Utils.checkIsSameMonth(i, DateTime(d.year, d.month + 1));
                i = DateTime(i.year, i.month + 1, i.day)) {
              if (Utils.checkIsSameMonth(i, DateTime(d.year, d.month)) &&
                  DateTime(i.year, i.month, element.day).isAfter(d)) {
                break;
              }
              print('month $i');
              print(DateTime(i.year, i.month, element.day));
              if (element.lastAddTime == null) {
                if (!i.isBefore(element.createDate)) {
                  int? id = await AccountingDB.insertData(
                    AccountingModel(
                      date: DateTime(i.year, i.month, element.day),
                      category: element.category,
                      tags: element.tags,
                      amount: element.amount,
                      note: element.note,
                    ),
                  );
                  if (id != null) {
                    for (var element in element.tags) {
                      await RecordTagDB.insertData(RecordTagModel(recordId: id, tagId: element));
                    }
                  }
                }
              } else {
                if (i.isAfter(element.lastAddTime ?? element.createDate)) {
                  int? id = await AccountingDB.insertData(
                    AccountingModel(
                      date: DateTime(i.year, i.month, element.day),
                      category: element.category,
                      tags: element.tags,
                      amount: element.amount,
                      note: element.note,
                    ),
                  );
                  if (id != null) {
                    for (var element in element.tags) {
                      await RecordTagDB.insertData(RecordTagModel(recordId: id, tagId: element));
                    }
                  }
                }
              }
            }
            element.lastAddTime = d;
            FixedIncomeDB.updateData(
              element..lastAddTime = d,
            );
            break;
          case FixedIncomeType.eachYear:
            for (DateTime i = element.lastAddTime ?? element.createDate;
                !Utils.checkIsSameYear(i, DateTime(d.year + 1));
                i = DateTime(i.year + 1, i.month, i.day)) {
              print('year $i');
            }
            break;
        }
      }
    });
  }

  void setDashBoardDateRange(DateTimeRange range) {
    dashBoardStartDate = range.start;

    dashBoardEndDate = range.end;

    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
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
    categoryList = list;
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

  Future<void> getAccountingList() async {
    final List<AccountingModel> list = await AccountingDB.displayAllData();
    accountingList = [];
    for (var element in list) {
      accountingList.add(element);
    }
    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
    notifyListeners();
  }

  Future<void> setCurrentAccounting(
    DateTime start,
    DateTime end,
  ) async {
    final List<AccountingModel> list = await AccountingDB.displayAllData();
    end = end.add(
      const Duration(days: 1),
    );
    accountingList = list;
    currentAccountingList = [];
    for (var element in accountingList) {
      if (start.year == end.year && start.month == end.month && start.day == end.day) {
        if (element.date.year == start.year &&
            element.date.month == start.month &&
            element.date.day == start.day) {
          currentAccountingList.add(element);
        }
      } else {
        if (element.date.isAfter(start) && element.date.isBefore(end)) {
          currentAccountingList.add(element);
        }
      }
    }
    currentAccountingList.sort((a, b) => b.date.compareTo(a.date));
    currentIncome = 0;
    currentExpenditure = 0;
    for (var element in currentAccountingList) {
      if (element.amount < 0) {
        currentExpenditure += element.amount;
      } else {
        currentIncome += element.amount;
      }
    }
    for (var element in currentAccountingList) {
      List<RecordTagModel> l =
          await RecordTagDB.queryData(queryType: RecordTagType.record, query: [element.id!]);
      element.tags = List.generate(l.length, (index) => l[index].tagId);
    }
    notifyListeners();
  }

  Future<void> setGoal(double amount) async {
    await Future.wait([
      Preferences.setString(Constants.goalNum, amount.toString()),
    ]);

    notifyListeners();
  }

  Future<void> getFixedIncomeList() async {
    final List<FixedIncomeModel> list = await FixedIncomeDB.displayAllData();
    fixedIncomeList = [];
    for (var element in list) {
      fixedIncomeList.add(element);
    }
    notifyListeners();
  }
}
