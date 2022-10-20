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
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/models/states.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/chart/chart_screen.dart';
import 'package:accounting/screens/chart/line_chart_setting_page.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainProvider with ChangeNotifier {
  AppState calendarState = AppState.finish;

  ///dashboard
  DateTime dashBoardStartDate = DateTime.now();
  DateTime dashBoardEndDate = DateTime.now();
  double currentIncome = 0;
  double currentExpenditure = 0;

  List<int>? incomeCategoryFilter;
  List<int>? expenditureCategoryFilter;

  List<int>? dashBoardTagFilter;

  int selectedValue = 0;

  bool get filter =>
      incomeCategoryFilter != null ||
      expenditureCategoryFilter != null ||
      dashBoardTagFilter != null;

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
    insertAccounting();
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      insertAccounting();
    });
  }

  Future<void> insertAccounting() async {
    DateTime d = DateTime.now();
    for (var element in fixedIncomeList) {
      switch (element.type) {
        case FixedIncomeType.eachDay:
          for (DateTime i = element.lastAddTime ?? element.createDate;
              !Utils.checkIsSameDay(i, d.add(const Duration(days: 1)));
              i = DateTime(i.year, i.month, i.day + 1)) {
            if (Utils.checkIsSameDay(i, DateTime(d.year, d.month, d.day)) &&
                DateTime(i.year, i.month, i.day, element.day).isAfter(d)) {
              break;
            }
            if (element.lastAddTime == null) {
              if (!i.isBefore(element.createDate)) {
                int? id = await AccountingDB.insertData(
                  AccountingModel(
                    date: DateTime(i.year, i.month, i.day, element.day),
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
                    date: DateTime(i.year, i.month, i.day, element.day),
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
        case FixedIncomeType.eachMonth:
          for (DateTime i = element.lastAddTime ?? element.createDate;
              !Utils.checkIsSameMonth(i, DateTime(d.year, d.month + 1));
              i = DateTime(i.year, i.month + 1, i.day)) {
            if (Utils.checkIsSameMonth(i, DateTime(d.year, d.month)) &&
                DateTime(i.year, i.month, element.day).isAfter(d)) {
              break;
            }
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
            if (Utils.checkIsSameYear(
                    i,
                    DateTime(
                      d.year,
                    )) &&
                DateTime(i.year, element.month, element.day).isAfter(d)) {
              break;
            }
            if (element.lastAddTime == null) {
              if (!i.isBefore(element.createDate)) {
                int? id = await AccountingDB.insertData(
                  AccountingModel(
                    date: DateTime(i.year, element.month, element.day),
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
                    date: DateTime(i.year, element.month, element.day),
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
      }
    }
  }

  void setIncomeFilter(int id) {
    if (incomeCategoryFilter == null) {
      incomeCategoryFilter = [];
      if (id != 0) {
        for (var element in categoryIncomeList) {
          if (element.id != id) {
            incomeCategoryFilter!.add(element.id!);
          }
        }
        if (id != -1) {
          incomeCategoryFilter!.add(-1);
        }
      }
    } else {
      if (id != 0) {
        if (incomeCategoryFilter!.contains(id)) {
          incomeCategoryFilter!.removeWhere((element) => element == id);
        } else {
          incomeCategoryFilter!.add(id);
        }
      } else {
        incomeCategoryFilter = null;
      }
    }
    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  }

  void setExpenditureFilter(int id) {
    if (expenditureCategoryFilter == null) {
      expenditureCategoryFilter = [];
      if (id != 0) {
        for (var element in categoryExpenditureList) {
          if (element.id != id) {
            expenditureCategoryFilter!.add(element.id!);
          }
        }
        if (id != -1) {
          expenditureCategoryFilter!.add(-1);
        }
      }
    } else {
      if (id != 0) {
        if (expenditureCategoryFilter!.contains(id)) {
          expenditureCategoryFilter!.removeWhere((element) => element == id);
        } else {
          expenditureCategoryFilter!.add(id);
        }
      } else {
        expenditureCategoryFilter = null;
      }
    }
    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  }

  // void setFilter(int id) {
  //   if (dashBoardFilter == null) {
  //     dashBoardFilter = [];
  //     if (id != 0) {
  //       for (var element in categoryList) {
  //         if (element.id != id) {
  //           dashBoardFilter!.add(element.id!);
  //         }
  //       }
  //       if (id != -1) {
  //         dashBoardFilter!.add(-1);
  //       }
  //     }
  //   } else {
  //     if (id != 0) {
  //       if (dashBoardFilter!.contains(id)) {
  //         dashBoardFilter!.removeWhere((element) => element == id);
  //       } else {
  //         dashBoardFilter!.add(id);
  //       }
  //     } else {
  //       dashBoardFilter = null;
  //     }
  //   }
  //   setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  //   notifyListeners();
  // }

  void setTagFilter(int id) {
    if (dashBoardTagFilter == null) {
      dashBoardTagFilter = [];
      if (id != 0) {
        for (var element in tagList) {
          if (element.id != id) {
            dashBoardTagFilter!.add(element.id!);
          }
        }
        if (id != -1) {
          dashBoardTagFilter!.add(-1);
        }
      }
    } else {
      if (id != 0) {
        if (dashBoardTagFilter!.contains(id)) {
          dashBoardTagFilter!.removeWhere((element) => element == id);
        } else {
          dashBoardTagFilter!.add(id);
        }
      } else {
        dashBoardTagFilter = null;
      }
    }
    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  }

  void setDashBoardDateRange(DateTimeRange range) {
    dashBoardStartDate = range.start;

    dashBoardEndDate = range.end;

    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
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

  Future<void> dashboardInit() async {
    await Future.wait([
      getTagList(),
      getCategoryList(),
      getAccountingList(),
    ]);
    notifyListeners();
  }

  Future<void> getCategoryList({bool? notify}) async {
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
    if (notify ?? true) {
      notifyListeners();
    }
  }

  Future<void> getTagList({bool? notify}) async {
    final List<TagModel> list = await TagDB.displayAllData();
    tagList = [];
    for (var element in list) {
      tagList.add(element);
    }
    tagList.sort((a, b) => a.sort.compareTo(b.sort));
    if (notify ?? true) {
      notifyListeners();
    }
  }

  Future<void> getAccountingList({bool? notify}) async {
    final List<AccountingModel> list = await AccountingDB.displayAllData();
    accountingList = [];
    for (var element in list) {
      accountingList.add(element);
    }
    setCurrentAccounting(
      dashBoardStartDate,
      dashBoardEndDate,
      notify: false,
    );
  }

  Future<void> setCurrentAccounting(DateTime start, DateTime end, {bool? notify}) async {
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

    for (var element in currentAccountingList) {
      List<RecordTagModel> l =
          await RecordTagDB.queryData(queryType: RecordTagType.record, query: [element.id!]);
      element.tags = List.generate(l.length, (index) => l[index].tagId);
    }

    ///收入
    List<AccountingModel> fl = [];
    if (incomeCategoryFilter != null) {
      List<AccountingModel> list = [];
      for (var element in currentAccountingList) {
        if (incomeCategoryFilter!.contains(element.category)) {
          if (element.category == -1) {
            if (element.amount > 0) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      }
      fl.addAll(list);
    } else {
      for (var element in currentAccountingList) {
        if (element.amount > 0) {
          fl.add(element);
        }
      }
    }

    ///支出
    if (expenditureCategoryFilter != null) {
      List<AccountingModel> list = [];
      for (var element in currentAccountingList) {
        if (expenditureCategoryFilter!.contains(element.category)) {
          if (element.category == -1) {
            if (element.amount < 0) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      }
      fl.addAll(list);
    } else {
      for (var element in currentAccountingList) {
        if (element.amount < 0) {
          fl.add(element);
        }
      }
    }

    currentAccountingList = fl;

    currentAccountingList.sort((a, b) => b.date.compareTo(a.date));

    if (dashBoardTagFilter != null) {
      List<AccountingModel> list = [];
      for (var element in currentAccountingList) {
        if (element.tags.isEmpty) {
          if (dashBoardTagFilter!.contains(-1)) {
            list.add(element);
          }
        } else {
          bool done = false;
          for (var e in element.tags) {
            if (dashBoardTagFilter!.contains(e) && !done) {
              list.add(element);
              done = true;
            }
          }
        }
      }
      currentAccountingList = list;
    }
    currentIncome = 0;
    currentExpenditure = 0;
    for (var element in currentAccountingList) {
      if (element.amount < 0) {
        currentExpenditure += element.amount;
      } else {
        currentIncome += element.amount;
      }
    }
    if (notify ?? true) {
      notifyListeners();
    }
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

  ///chart page
  DateTime lineChartStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime lineChartEnd = DateTime.now();

  bool get lineSamDay =>
      lineChartStart.year == lineChartEnd.year &&
      lineChartStart.month == lineChartEnd.month &&
      lineChartStart.day == lineChartEnd.day;

  ChartDataType lineChartDataType = ChartDataType.inOut;

  int lineScale = 0;

  List<int> lineFilter = [0, 1];

  List<int>? lineTagFilter;

  List<ChartSeries> lineChartList = [];

  AppState lineChartState = AppState.finish;

  Future<void> setLineChartTime({
    required DateTime start,
    required DateTime end,
    required ChartDataType type,
    required int scale,
    required List<int> filter,
    required List<int>? tagFilter,
  }) async {
    lineChartStart = start;
    lineChartEnd = end;
    lineChartDataType = type;
    lineScale = scale;
    lineFilter = filter;
    lineTagFilter = tagFilter;

    notifyListeners();
  }

  Future<void> drawLineChart(BuildContext context) async {
    lineChartState = AppState.loading;
    notifyListeners();

    List<AccountingModel> allList = [];

    if (lineChartDataType == ChartDataType.category) {
      List<AccountingModel> list = [];
      for (var element in accountingList) {
        if (lineFilter.contains(element.category)) {
          if (element.category == -1) {
            if (element.amount > 0) {
              list.add(element);
            }
          } else {
            list.add(element);
          }
        }
      }
      allList.addAll(list);
    } else {
      allList.addAll(accountingList);
    }

    allList.sort((a, b) => b.date.compareTo(b.date));
    if (lineChartDataType == ChartDataType.inOut) {
      int days = lineChartEnd.difference(lineChartStart).inDays;
      List<SalesData> incomes = [];
      List<SalesData> expenditures = [];
      switch (lineScale) {
        case 0:
          for (int i = 0; i < days; i++) {
            double income = 0;
            double expenditure = 0;
            DateTime d =
                DateTime(lineChartStart.year, lineChartStart.month, lineChartStart.day + i);

            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameDay(element.date, d)).toList();
            for (var element in l) {
              if (element.amount > 0) {
                income += element.amount;
              } else {
                expenditure += element.amount;
              }
            }
            incomes.add(SalesData(d, income));
            expenditures.add(SalesData(d, expenditure.abs()));
          }
          break;
        case 1:
          DateTime end = DateTime(lineChartEnd.year, lineChartEnd.month + 1);
          for (DateTime i = lineChartStart;
              i.year != end.year || i.month != end.month;
              i = DateTime(i.year, i.month + 1)) {
            print(i);
            double income = 0;
            double expenditure = 0;

            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameMonth(element.date, i)).toList();
            for (var element in l) {
              if (element.amount > 0) {
                income += element.amount;
              } else {
                expenditure += element.amount;
              }
            }
            incomes.add(SalesData(i, income));
            expenditures.add(SalesData(i, expenditure.abs()));
          }
          break;
        case 2:
          DateTime end = DateTime(lineChartEnd.year + 1);
          for (DateTime i = lineChartStart; i.year != end.year + 1; i = DateTime(i.year + 1)) {
            double income = 0;
            double expenditure = 0;

            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameYear(element.date, i)).toList();
            for (var element in l) {
              if (element.amount > 0) {
                income += element.amount;
              } else {
                expenditure += element.amount;
              }
            }
            incomes.add(SalesData(i, income));
            expenditures.add(SalesData(i, expenditure.abs()));
          }
          break;
      }

      lineChartList = [
        LineSeries<SalesData, DateTime>(
          dataSource: incomes,
          name: S.of(context).income,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
        ),
        LineSeries<SalesData, DateTime>(
          dataSource: expenditures,
          name: S.of(context).expenditure,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
        ),
      ];
    }
    lineChartState = AppState.finish;
    notifyListeners();
  }
}
