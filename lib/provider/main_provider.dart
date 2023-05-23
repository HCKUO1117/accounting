import 'dart:async';
import 'dart:io';

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
import 'package:accounting/models/line_chart_model.dart';
import 'package:accounting/models/states.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/chart/chart_screen.dart';
import 'package:accounting/screens/chart/line_chart_setting_page.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainProvider with ChangeNotifier {
  AppState calendarState = AppState.finish;

  ///dashboard
  DateTime dashBoardStartDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime dashBoardEndDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  double currentIncome = 0;
  double currentExpenditure = 0;

  List<int>? incomeCategoryFilter;
  List<int>? expenditureCategoryFilter;

  List<int>? dashBoardTagFilter;

  int selectedValue = 0;

  bool get filter =>
      (incomeCategoryFilter != null &&
          incomeCategoryFilter!.length != categoryIncomeList.length + 1) ||
      (expenditureCategoryFilter != null &&
          expenditureCategoryFilter!.length != categoryExpenditureList.length + 1) ||
      (dashBoardTagFilter != null && dashBoardTagFilter!.length != tagList.length + 1);

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

  DateTime currentDay = DateTime.now();

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
                element.lastAddTime = DateTime(i.year, i.month, i.day, element.day);
                FixedIncomeDB.updateData(
                  element..lastAddTime = DateTime(i.year, i.month, i.day, element.day),
                );
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
                element.lastAddTime = DateTime(i.year, i.month, i.day, element.day);
                FixedIncomeDB.updateData(
                  element..lastAddTime = DateTime(i.year, i.month, i.day, element.day),
                );
              }
            }
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
                element.lastAddTime = DateTime(i.year, i.month, element.day);
                FixedIncomeDB.updateData(
                  element..lastAddTime = DateTime(i.year, i.month, element.day),
                );
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
                element.lastAddTime = DateTime(i.year, i.month, element.day);
                FixedIncomeDB.updateData(
                  element..lastAddTime = DateTime(i.year, i.month, element.day),
                );
              }
            }
          }

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
                element.lastAddTime = DateTime(i.year, element.month, element.day);
                FixedIncomeDB.updateData(
                  element..lastAddTime = DateTime(i.year, element.month, element.day),
                );
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
                element.lastAddTime = DateTime(i.year, element.month, element.day);
                FixedIncomeDB.updateData(
                  element..lastAddTime = DateTime(i.year, element.month, element.day),
                );
              }
            }
          }

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
        if (incomeCategoryFilter!.length == categoryIncomeList.length + 1) {
          incomeCategoryFilter = [];
        } else {
          incomeCategoryFilter = null;
        }
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
        if (expenditureCategoryFilter!.length == categoryExpenditureList.length + 1) {
          expenditureCategoryFilter = [];
        } else {
          expenditureCategoryFilter = null;
        }
      }
    }
    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  }

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
        if (dashBoardTagFilter!.length == tagList.length + 1) {
          dashBoardTagFilter = [];
        } else {
          dashBoardTagFilter = null;
        }
      }
    }
    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  }

  void setDashBoardDateRange(DateTimeRange range) {
    dashBoardStartDate = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
      range.start.hour,
      range.start.minute,
      range.start.second,
    );

    dashBoardEndDate = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      range.end.hour,
      range.end.minute,
      range.end.second,
    );

    setCurrentAccounting(dashBoardStartDate, dashBoardEndDate);
  }

  Future<void> setDefaultDB() async {
    final hadOpen = Preferences.getBool(Constants.hadOpen, false);
    if (!hadOpen) {
      final String defaultLocale = Platform.localeName;
      if (defaultLocale.startsWith('zh')) {
        for (var element in Constants.defaultCategories) {
          await CategoryDB.insertData(element);
        }
        for (var element in Constants.defaultTags) {
          await TagDB.insertData(element);
        }
      } else {
        for (var element in Constants.defaultCategoriesEn) {
          await CategoryDB.insertData(element);
        }
        for (var element in Constants.defaultTagsEn) {
          await TagDB.insertData(element);
        }
      }
    }
    await Preferences.setBool(Constants.hadOpen, true);
  }

  Future<void> dashboardInit() async {
    await Future.wait([
      getTagList(),
      getCategoryList(),
      getAccountingList(notify: false),
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
      notify: notify,
    );
  }

  Future<void> setCurrentAccounting(DateTime start, DateTime end, {bool? notify}) async {
    currentDay = start.subtract(const Duration(days: 1));
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
        if (!element.date.isBefore(start) && element.date.isBefore(end)) {
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
  int initTab = 0;

  ///line
  DateTime lineChartStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .subtract(const Duration(days: 30));
  DateTime lineChartEnd =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

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

  double lineCurrentIncome = 0;

  double lineCurrentExpenditure = 0;

  List<AccountingModel> lineAllList = [];

  Future<void> setLineChartTime({
    required DateTime start,
    required DateTime end,
    required ChartDataType type,
    required int scale,
    required List<int> filter,
    required List<int>? tagFilter,
  }) async {
    lineChartStart = DateTime(start.year, start.month, start.day);
    lineChartEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
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

    if (lineTagFilter != null) {
      List<AccountingModel> list = [];
      for (var element in allList) {
        if (element.tags.isEmpty) {
          if (lineTagFilter!.contains(-1)) {
            list.add(element);
          }
        } else {
          bool done = false;
          for (var e in element.tags) {
            if (lineTagFilter!.contains(e) && !done) {
              list.add(element);
              done = true;
            }
          }
        }
      }
      allList = list;
    }

    if (lineChartDataType == ChartDataType.inOut) {
      if (!lineFilter.contains(0)) {
        allList.removeWhere((element) => element.amount > 0);
      }

      if (!lineFilter.contains(1)) {
        allList.removeWhere((element) => element.amount < 0);
      }
    }

    allList.sort((a, b) => b.date.compareTo(b.date));
    lineAllList = allList;

    lineCurrentIncome = 0;
    lineCurrentExpenditure = 0;

    // for (var element in allList) {
    //   if (element.amount > 0) {
    //     lineCurrentIncome += element.amount;
    //   } else {
    //     lineCurrentExpenditure += element.amount;
    //   }
    // }

    if (lineChartDataType == ChartDataType.inOut) {
      int days = lineChartEnd.difference(lineChartStart).inDays + 1;
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
            lineCurrentIncome += income;
            lineCurrentExpenditure += expenditure;
            incomes.add(SalesData(d, income));
            expenditures.add(SalesData(d, expenditure.abs()));
          }
          break;
        case 1:
          DateTime end = DateTime(lineChartEnd.year, lineChartEnd.month + 1);
          for (DateTime i = lineChartStart;
              i.year != end.year || i.month != end.month;
              i = DateTime(i.year, i.month + 1)) {
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
            lineCurrentIncome += income;
            lineCurrentExpenditure += expenditure;
            incomes.add(SalesData(i, income));
            expenditures.add(SalesData(i, expenditure.abs()));
          }
          break;
        case 2:
          DateTime end = DateTime(lineChartEnd.year + 1);
          for (DateTime i = lineChartStart; i.year != end.year; i = DateTime(i.year + 1)) {
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
            lineCurrentIncome += income;
            lineCurrentExpenditure += expenditure;
            incomes.add(SalesData(i, income));
            expenditures.add(SalesData(i, expenditure.abs()));
          }
          break;
      }

      lineChartList = [
        if (lineFilter.contains(0))
          LineSeries<SalesData, String>(
            dataSource: incomes,
            name: S.of(context).income,
            color: Colors.blueAccent,
            xValueMapper: (SalesData sales, _) => dateScaleTransfer(time: sales.year),
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
        if (lineFilter.contains(1))
          LineSeries<SalesData, String>(
            dataSource: expenditures,
            name: S.of(context).expenditure,
            color: Colors.redAccent,
            xValueMapper: (SalesData sales, _) => dateScaleTransfer(time: sales.year),
            yValueMapper: (SalesData sales, _) => sales.sales,
          ),
      ];
    } else {
      List<LineChartModel> chartList = [];
      for (var element in lineFilter) {
        if (categoryList.indexWhere((e) => e.id == element) != -1) {
          CategoryModel model = categoryList.firstWhere((e) => e.id == element);
          chartList.add(
            LineChartModel(model: model, dataList: []),
          );
        }
      }
      if (lineFilter.contains(-1)) {
        chartList.add(
          LineChartModel(
            model: CategoryModel(
                id: -1,
                sort: -1,
                type: CategoryType.income,
                icon: 'help_outline',
                iconColor: Colors.grey,
                name: S.of(context).unCategory),
            dataList: [],
          ),
        );
      }

      switch (lineScale) {
        case 0:
          int days = lineChartEnd.difference(lineChartStart).inDays + 1;
          for (int i = 0; i < days; i++) {
            DateTime d =
                DateTime(lineChartStart.year, lineChartStart.month, lineChartStart.day + i);

            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameDay(element.date, d)).toList();

            for (var element in chartList) {
              List<AccountingModel> al = l.where((e) => e.category == element.model.id).toList();
              double amount = 0;
              for (var el in al) {
                amount += el.amount;
              }
              element.dataList.add(SalesData(d, amount.abs()));
            }
          }
          break;
        case 1:
          DateTime end = DateTime(lineChartEnd.year, lineChartEnd.month + 1);
          for (DateTime i = lineChartStart;
              i.year != end.year || i.month != end.month;
              i = DateTime(i.year, i.month + 1)) {
            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameMonth(element.date, i)).toList();

            for (var element in chartList) {
              List<AccountingModel> al = l.where((e) => e.category == element.model.id).toList();
              double amount = 0;
              for (var el in al) {
                amount += el.amount;
              }
              element.dataList.add(SalesData(i, amount.abs()));
            }
          }
          break;
        case 2:
          DateTime end = DateTime(lineChartEnd.year);
          for (DateTime i = lineChartStart; i.year != end.year + 1; i = DateTime(i.year + 1)) {
            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameYear(element.date, i)).toList();

            for (var element in chartList) {
              List<AccountingModel> al = l.where((e) => e.category == element.model.id).toList();
              double amount = 0;
              for (var el in al) {
                amount += el.amount;
              }
              element.dataList.add(SalesData(i, amount.abs()));
            }
          }
          break;
      }

      lineChartList = [];
      for (final element in chartList) {
        double amount = 0;
        for (var e in element.dataList) {
          amount += e.sales;
        }
        if (amount != 0) {
          lineChartList.add(
            LineSeries<SalesData, String>(
              dataSource: element.dataList,
              name: element.model.name,
              color: element.model.iconColor,
              xValueMapper: (SalesData sales, _) => dateScaleTransfer(time: sales.year),
              yValueMapper: (SalesData sales, _) => sales.sales,
            ),
          );
        }
      }

      // lineChartList = [
      //   for (final element in chartList)
      //     LineSeries<SalesData, String>(
      //       dataSource: element.dataList,
      //       name: element.model.name,
      //       color: element.model.iconColor,
      //       xValueMapper: (SalesData sales, _) => dateScaleTransfer(time: sales.year),
      //       yValueMapper: (SalesData sales, _) => sales.sales,
      //     ),
      // ];
    }
    lineChartState = AppState.finish;
    notifyListeners();
  }

  String dateScaleTransfer({required DateTime time}) {
    switch (lineScale) {
      case 0:
        return DateFormat('yyyy/MM/dd').format(time);
      case 1:
        return DateFormat('yyyy/MM').format(time);
      case 2:
        return DateFormat('yyyy').format(time);
      default:
        return 'NA';
    }
  }

  ///pie
  DateTime pieChartStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .subtract(const Duration(days: 30));
  DateTime pieChartEnd =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

  bool get pieSamDay =>
      pieChartStart.year == pieChartEnd.year &&
      pieChartStart.month == pieChartEnd.month &&
      pieChartStart.day == pieChartEnd.day;

  ChartDataType pieChartDataType = ChartDataType.inOut;

  List<int> pieFilter = [0, 1];

  List<int>? pieTagFilter;

  int pieScale = 0;

  AppState pieChartState = AppState.finish;

  List<PieData> pieDataList = [];

  List<PieData> inPieDataList = [];
  List<PieData> outPieDataList = [];

  double pieCurrentIncome = 0;

  double pieCurrentExpenditure = 0;

  List<AccountingModel> pieAllList = [];

  Future<void> setPieChartTime({
    required DateTime start,
    required DateTime end,
    required ChartDataType type,
    required int scale,
    required List<int> filter,
    required List<int>? tagFilter,
  }) async {
    pieChartStart = DateTime(start.year, start.month, start.day);
    pieChartEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    pieChartDataType = type;
    pieScale = scale;
    pieFilter = filter;
    pieTagFilter = tagFilter;

    notifyListeners();
  }

  Future<void> drawPieChart(BuildContext context) async {
    pieChartState = AppState.loading;
    notifyListeners();

    List<AccountingModel> tempList = [];

    switch (pieScale) {
      case 0:
        for (var element in accountingList) {
          if (pieChartStart.year == pieChartEnd.year &&
              pieChartStart.month == pieChartEnd.month &&
              pieChartStart.day == pieChartEnd.day) {
            if (element.date.year == pieChartStart.year &&
                element.date.month == pieChartStart.month &&
                element.date.day == pieChartStart.day) {
              tempList.add(element);
            }
          } else {
            if (!element.date.isBefore(pieChartStart) && !element.date.isAfter(pieChartEnd)) {
              tempList.add(element);
            }
          }
        }
        break;
      case 1:
        for (var element in accountingList) {
          if (!element.date.isBefore(pieChartStart) &&
              element.date.isBefore(DateTime(pieChartEnd.year, pieChartEnd.month + 1))) {
            tempList.add(element);
          }
        }
        break;
      case 2:
        for (var element in accountingList) {
          if (!element.date.isBefore(pieChartStart) &&
              element.date.isBefore(DateTime(pieChartEnd.year, 12, 31))) {
            tempList.add(element);
          }
        }

        break;
    }

    List<AccountingModel> allList = [];

    if (pieChartDataType == ChartDataType.category) {
      List<AccountingModel> list = [];
      for (var element in tempList) {
        if (pieFilter.contains(element.category)) {
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
      allList.addAll(tempList);
    }

    if (pieTagFilter != null) {
      List<AccountingModel> list = [];
      for (var element in allList) {
        if (element.tags.isEmpty) {
          if (pieTagFilter!.contains(-1)) {
            list.add(element);
          }
        } else {
          bool done = false;
          for (var e in element.tags) {
            if (pieTagFilter!.contains(e) && !done) {
              list.add(element);
              done = true;
            }
          }
        }
      }
      allList = list;
    }

    if (pieChartDataType == ChartDataType.inOut) {
      if (!pieFilter.contains(0)) {
        allList.removeWhere((element) => element.amount > 0);
      }

      if (!pieFilter.contains(1)) {
        allList.removeWhere((element) => element.amount < 0);
      }
    }

    allList.sort((a, b) => b.date.compareTo(b.date));

    pieAllList = allList;

    pieCurrentIncome = 0;
    pieCurrentExpenditure = 0;

    for (var element in allList) {
      if (element.amount > 0) {
        pieCurrentIncome += element.amount;
      } else {
        pieCurrentExpenditure += element.amount;
      }
    }

    if (pieChartDataType == ChartDataType.inOut) {
      double income = 0;
      double expenditure = 0;

      for (var element in allList) {
        if (element.amount > 0) {
          income += element.amount;
        } else {
          expenditure += element.amount;
        }
      }

      // bool allEmpty = income == 0 && expenditure == 0;
      pieDataList = [
        if (pieFilter.contains(1))
          PieData(
            S.of(context).expenditure,
            expenditure,
            S.of(context).expenditure,
            Colors.redAccent.shade100,
          ),
        if (pieFilter.contains(0))
          PieData(
            S.of(context).income,
            income,
            S.of(context).income,
            Colors.blueAccent.shade100,
          )
      ];
    } else {
      pieDataList = [];
      inPieDataList = [];
      outPieDataList = [];
      for (var element in pieFilter) {
        List<AccountingModel> l = allList.where((e) => e.category == element).toList();

        double amount = 0;
        for (var element in l) {
          amount += element.amount;
        }

        if (categoryList.indexWhere((e) => e.id == element) != -1) {
          CategoryModel model = categoryList.firstWhere((e) => e.id == element);
          pieDataList.add(PieData(
            model.name,
            amount,
            model.name,
            model.iconColor,
          ));
          if (model.type == CategoryType.expenditure) {
            outPieDataList.add(PieData(
              model.name,
              amount,
              model.name,
              model.iconColor,
            ));
          } else {
            inPieDataList.add(PieData(
              model.name,
              amount,
              model.name,
              model.iconColor,
            ));
          }
        }
        if (element == -1) {
          pieDataList.add(PieData(
            S.of(context).unCategory,
            amount,
            S.of(context).unCategory,
            Colors.grey,
          ));
          if (amount < 0) {
            outPieDataList.add(PieData(
              S.of(context).unCategory,
              amount,
              S.of(context).unCategory,
              Colors.grey,
            ));
          } else {
            inPieDataList.add(PieData(
              S.of(context).unCategory,
              amount,
              S.of(context).unCategory,
              Colors.grey,
            ));
          }
        }
      }
    }
    pieChartState = AppState.finish;
    notifyListeners();
  }

  ///stack
  DateTime stackChartStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .subtract(const Duration(days: 30));
  DateTime stackChartEnd =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

  bool get stackSamDay =>
      stackChartStart.year == stackChartEnd.year &&
      stackChartStart.month == stackChartEnd.month &&
      stackChartStart.day == stackChartEnd.day;

  ChartDataType stackChartDataType = ChartDataType.inOut;

  int stackScale = 0;

  List<int> stackFilter = [0, 1];

  List<int>? stackTagFilter;

  List<ChartSeries> stackChartList = [];

  AppState stackChartState = AppState.finish;

  double stackCurrentIncome = 0;

  double stackCurrentExpenditure = 0;

  List<AccountingModel> stackAllList = [];

  Future<void> setStackChartTime({
    required DateTime start,
    required DateTime end,
    required ChartDataType type,
    required int scale,
    required List<int> filter,
    required List<int>? tagFilter,
  }) async {
    stackChartStart = DateTime(start.year, start.month, start.day);
    stackChartEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    stackChartDataType = type;
    stackScale = scale;
    stackFilter = filter;
    stackTagFilter = tagFilter;
    notifyListeners();
  }

  Future<void> drawStackChart(BuildContext context) async {
    stackChartState = AppState.loading;
    notifyListeners();

    List<AccountingModel> allList = [];

    allList.addAll(accountingList);

    if (stackTagFilter != null) {
      List<AccountingModel> list = [];
      for (var element in allList) {
        if (element.tags.isEmpty) {
          if (stackTagFilter!.contains(-1)) {
            list.add(element);
          }
        } else {
          bool done = false;
          for (var e in element.tags) {
            if (stackTagFilter!.contains(e) && !done) {
              list.add(element);
              done = true;
            }
          }
        }
      }
      allList = list;
    }

    if (stackChartDataType == ChartDataType.inOut) {
      if (!stackFilter.contains(0)) {
        allList.removeWhere((element) => element.amount > 0);
      }

      if (!stackFilter.contains(1)) {
        allList.removeWhere((element) => element.amount < 0);
      }
    }
    stackCurrentIncome = 0;
    stackCurrentExpenditure = 0;

    // for (var element in allList) {
    //   if (element.amount > 0) {
    //     stackCurrentIncome += element.amount;
    //   } else {
    //     stackCurrentExpenditure += element.amount;
    //   }
    // }

    allList.sort((a, b) => b.date.compareTo(b.date));

    stackAllList = allList;

    if (stackChartDataType == ChartDataType.inOut) {
      int days = stackChartEnd.difference(stackChartStart).inDays + 1;
      stackChartList = [];
      switch (stackScale) {
        case 0:
          for (var element in categoryList) {
            if ((!stackFilter.contains(0) && element.type == CategoryType.income ||
                (!stackFilter.contains(1) && element.type == CategoryType.expenditure))) {
              continue;
            }

            List<ChartData> data = [];
            double totalAmount = 0;
            for (int i = 0; i < days; i++) {
              DateTime d =
                  DateTime(stackChartStart.year, stackChartStart.month, stackChartStart.day + i);
              final List<AccountingModel> l =
                  allList.where((element) => Utils.checkIsSameDay(element.date, d)).toList();
              double amount = 0;
              for (var e in l) {
                if (e.category == element.id) {
                  amount += e.amount;
                }
              }
              data.add(ChartData(Utils.dateStringByType(d, 0), amount.abs()));
              totalAmount += amount;
              if (amount > 0) {
                stackCurrentIncome += amount;
              } else {
                stackCurrentExpenditure += amount;
              }
            }

            if (totalAmount != 0) {
              stackChartList.add(
                StackedColumnSeries<ChartData, String>(
                  name: element.name,
                  color: element.iconColor,
                  groupName: element.type == CategoryType.income ? 'income' : 'expenditure',
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                ),
              );
            }
          }
          List<ChartData> incomeData = [];
          List<ChartData> expenditureData = [];
          double incomeAmount = 0;
          double expenditureAmount = 0;
          for (int i = 0; i < days; i++) {
            DateTime d =
                DateTime(stackChartStart.year, stackChartStart.month, stackChartStart.day + i);
            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameDay(element.date, d)).toList();
            for (var e in l) {
              if (e.category == -1) {
                if (e.amount > 0) {
                  incomeData.add(ChartData(Utils.dateStringByType(d, 0), e.amount.abs()));
                  incomeAmount += e.amount;
                  stackCurrentIncome += e.amount;
                } else {
                  expenditureData.add(ChartData(Utils.dateStringByType(d, 0), e.amount.abs()));
                  expenditureAmount += e.amount;
                  stackCurrentExpenditure += e.amount;
                }
              }
            }
          }

          if (incomeAmount != 0) {
            stackChartList.add(
              StackedColumnSeries<ChartData, String>(
                  name: '${S.of(context).unCategory}-${S.of(context).income}',
                  groupName: 'income',
                  color: Colors.grey,
                  dataSource: incomeData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            );
          }
          if (expenditureAmount != 0) {
            stackChartList.add(
              StackedColumnSeries<ChartData, String>(
                  name: '${S.of(context).unCategory}-${S.of(context).expenditure}',
                  groupName: 'expenditure',
                  color: Colors.grey,
                  dataSource: expenditureData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            );
          }
          break;
        case 1:
          for (var element in categoryList) {
            if ((!stackFilter.contains(0) && element.type == CategoryType.income ||
                (!stackFilter.contains(1) && element.type == CategoryType.expenditure))) {
              continue;
            }
            List<ChartData> data = [];
            DateTime end = DateTime(stackChartEnd.year, stackChartEnd.month + 1);
            double totalAmount = 0;
            for (DateTime i = stackChartStart;
                i.year != end.year || i.month != end.month;
                i = DateTime(i.year, i.month + 1)) {
              final List<AccountingModel> l =
                  allList.where((element) => Utils.checkIsSameMonth(element.date, i)).toList();
              double amount = 0;
              for (var e in l) {
                if (e.category == element.id) {
                  amount += e.amount;
                }
              }
              data.add(ChartData(Utils.dateStringByType(i, 1), amount.abs()));
              totalAmount += amount;
              if (amount > 0) {
                stackCurrentIncome += amount;
              } else {
                stackCurrentExpenditure += amount;
              }
            }

            if (totalAmount != 0) {
              stackChartList.add(
                StackedColumnSeries<ChartData, String>(
                    name: element.name,
                    groupName: element.type == CategoryType.income ? 'income' : 'expenditure',
                    color: element.iconColor,
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y),
              );
            }
          }
          List<ChartData> incomeData = [];
          List<ChartData> expenditureData = [];
          double incomeAmount = 0;
          double expenditureAmount = 0;
          DateTime end = DateTime(stackChartEnd.year, stackChartEnd.month + 1);
          for (DateTime i = stackChartStart;
              i.year != end.year || i.month != end.month;
              i = DateTime(i.year, i.month + 1)) {
            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameMonth(element.date, i)).toList();
            for (var e in l) {
              if (e.category == -1) {
                if (e.amount > 0) {
                  incomeData.add(ChartData(Utils.dateStringByType(i, 1), e.amount.abs()));
                  incomeAmount += e.amount;
                  stackCurrentIncome += e.amount;
                } else {
                  expenditureData.add(ChartData(Utils.dateStringByType(i, 1), e.amount.abs()));
                  expenditureAmount += e.amount;
                  stackCurrentExpenditure += e.amount;
                }
              }
            }
          }

          if (incomeAmount != 0) {
            stackChartList.add(
              StackedColumnSeries<ChartData, String>(
                  name: '${S.of(context).unCategory}-${S.of(context).income}',
                  groupName: 'income',
                  color: Colors.grey,
                  dataSource: incomeData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            );
          }
          if (expenditureAmount != 0) {
            stackChartList.add(
              StackedColumnSeries<ChartData, String>(
                  name: '${S.of(context).unCategory}-${S.of(context).expenditure}',
                  groupName: 'expenditure',
                  color: Colors.grey,
                  dataSource: expenditureData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            );
          }
          break;
        case 2:
          for (var element in categoryList) {
            if ((!stackFilter.contains(0) && element.type == CategoryType.income ||
                (!stackFilter.contains(1) && element.type == CategoryType.expenditure))) {
              continue;
            }
            List<ChartData> data = [];
            DateTime end = DateTime(stackChartEnd.year + 1);
            double totalAmount = 0;
            for (DateTime i = stackChartStart; i.year != end.year; i = DateTime(i.year + 1)) {
              final List<AccountingModel> l =
                  allList.where((element) => Utils.checkIsSameYear(element.date, i)).toList();
              double amount = 0;
              for (var e in l) {
                if (e.category == element.id) {
                  amount += e.amount;
                }
              }
              data.add(ChartData(Utils.dateStringByType(i, 2), amount.abs()));
              totalAmount += amount;
              if (amount > 0) {
                stackCurrentIncome += amount;
              } else {
                stackCurrentExpenditure += amount;
              }
            }

            if (totalAmount != 0) {
              stackChartList.add(
                StackedColumnSeries<ChartData, String>(
                    name: element.name,
                    groupName: element.type == CategoryType.income ? 'income' : 'expenditure',
                    color: element.iconColor,
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y),
              );
            }
          }
          List<ChartData> incomeData = [];
          List<ChartData> expenditureData = [];
          double incomeAmount = 0;
          double expenditureAmount = 0;
          DateTime end = DateTime(lineChartEnd.year + 1);
          for (DateTime i = lineChartStart; i.year != end.year; i = DateTime(i.year + 1)) {
            final List<AccountingModel> l =
                allList.where((element) => Utils.checkIsSameYear(element.date, i)).toList();
            for (var e in l) {
              if (e.category == -1) {
                if (e.amount > 0) {
                  incomeAmount += e.amount;
                  incomeData.add(ChartData(Utils.dateStringByType(i, 2), e.amount.abs()));
                  stackCurrentIncome += e.amount;
                } else {
                  expenditureAmount += e.amount;
                  expenditureData.add(ChartData(Utils.dateStringByType(i, 2), e.amount.abs()));
                  stackCurrentExpenditure += e.amount;
                }
              }
            }
          }

          if (incomeAmount != 0) {
            stackChartList.add(
              StackedColumnSeries<ChartData, String>(
                  name: '${S.of(context).unCategory}-${S.of(context).income}',
                  groupName: 'income',
                  color: Colors.grey,
                  dataSource: incomeData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            );
          }
          if (expenditureAmount != 0) {
            stackChartList.add(
              StackedColumnSeries<ChartData, String>(
                  name: '${S.of(context).unCategory}-${S.of(context).expenditure}',
                  groupName: 'expenditure',
                  color: Colors.grey,
                  dataSource: expenditureData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y),
            );
          }
          break;
      }
    }

    stackChartState = AppState.finish;
    notifyListeners();
  }

  ///list
  DateTime listChartStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      .subtract(const Duration(days: 30));
  DateTime listChartEnd =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

  bool get listSamDay =>
      stackChartStart.year == stackChartEnd.year &&
      stackChartStart.month == stackChartEnd.month &&
      stackChartStart.day == stackChartEnd.day;

  int listScale = 0;

  List<int>? listTagFilter;

  AppState listChartState = AppState.finish;

  double listCurrentIncome = 0;

  double listCurrentExpenditure = 0;

  List<AccountingModel> listAllList = [];

  List<ListChartCategoryModel> sortedIncomeCategories = [];
  List<ListChartCategoryModel> sortedExpenditureCategories = [];

  Future<void> setListChartTime({
    required DateTime start,
    required DateTime end,
    required int scale,
    required List<int>? tagFilter,
  }) async {
    listChartStart = DateTime(start.year, start.month, start.day);
    listChartEnd = DateTime(end.year, end.month, end.day, 23, 59, 59);
    listScale = scale;
    listTagFilter = tagFilter;
    notifyListeners();
  }

  Future<void> drawListChart(BuildContext context) async {
    listChartState = AppState.loading;
    notifyListeners();

    List<AccountingModel> tempList = [];

    switch (listScale) {
      case 0:
        for (var element in accountingList) {
          if (listChartStart.year == listChartEnd.year &&
              listChartStart.month == listChartEnd.month &&
              listChartStart.day == listChartEnd.day) {
            if (element.date.year == listChartStart.year &&
                element.date.month == listChartStart.month &&
                element.date.day == listChartStart.day) {
              tempList.add(element);
            }
          } else {
            if (!element.date.isBefore(listChartStart) && !element.date.isAfter(listChartEnd)) {
              tempList.add(element);
            }
          }
        }
        break;
      case 1:
        for (var element in accountingList) {
          if (!element.date.isBefore(listChartStart) &&
              element.date.isBefore(DateTime(listChartEnd.year, listChartEnd.month + 1))) {
            tempList.add(element);
          }
        }
        break;
      case 2:
        for (var element in accountingList) {
          if (!element.date.isBefore(listChartStart) &&
              element.date.isBefore(DateTime(listChartEnd.year, 12, 31))) {
            tempList.add(element);
          }
        }

        break;
    }

    List<AccountingModel> allList = [];

    if (listTagFilter != null) {
      List<AccountingModel> list = [];
      for (var element in tempList) {
        if (element.tags.isEmpty) {
          if (listTagFilter!.contains(-1)) {
            list.add(element);
          }
        } else {
          bool done = false;
          for (var e in element.tags) {
            if (listTagFilter!.contains(e) && !done) {
              list.add(element);
              done = true;
            }
          }
        }
      }
      allList = list;
    } else {
      allList = tempList;
    }

    allList.sort((a, b) => b.date.compareTo(b.date));

    listAllList = allList;

    listCurrentIncome = 0;
    listCurrentExpenditure = 0;

    for (var element in allList) {
      if (element.amount > 0) {
        listCurrentIncome += element.amount;
      } else {
        listCurrentExpenditure += element.amount;
      }
    }

    sortedIncomeCategories = [];

    for (var element in categoryIncomeList) {
      double amount = 0;
      int count = 0;
      for (var e in listAllList) {
        if (e.category == element.id) {
          amount += e.amount;
          count++;
        }
      }
      sortedIncomeCategories.add(ListChartCategoryModel(
        model: element,
        amount: amount,
        count: count,
      ));
    }
    sortedExpenditureCategories = [];
    for (var element in categoryExpenditureList) {
      double amount = 0;
      int count = 0;
      for (var e in listAllList) {
        if (e.category == element.id) {
          amount += e.amount;
          count++;
        }
      }
      sortedExpenditureCategories.add(ListChartCategoryModel(
        model: element,
        amount: amount,
        count: count,
      ));
    }

    ///加入未分類
    double unCategoryIncome = 0;
    int unCategoryIncomeCount = 0;
    double unCategoryExpenditure = 0;
    int unCategoryExpenditureCount = 0;
    for (var e in listAllList) {
      if (e.category == -1) {
        if (e.amount > 0) {
          unCategoryIncome += e.amount;
          unCategoryIncomeCount++;
        } else {
          unCategoryExpenditure += e.amount;
          unCategoryExpenditureCount++;
        }
      }
    }
    sortedIncomeCategories.add(
      ListChartCategoryModel(
        model: CategoryModel(
          id: -1,
          sort: 0,
          type: CategoryType.income,
          icon: 'help_outline',
          iconColor: Colors.grey,
          name: S.of(context).unCategory,
        ),
        amount: unCategoryIncome,
        count: unCategoryIncomeCount,
      ),
    );
    sortedExpenditureCategories.add(
      ListChartCategoryModel(
        model: CategoryModel(
          id: -1,
          sort: 0,
          type: CategoryType.expenditure,
          icon: 'help_outline',
          iconColor: Colors.grey,
          name: S.of(context).unCategory,
        ),
        amount: unCategoryExpenditure,
        count: unCategoryExpenditureCount,
      ),
    );

    sortedIncomeCategories.sort((a, b) => b.amount.compareTo(a.amount));
    sortedExpenditureCategories.sort((a, b) => a.amount.compareTo(b.amount));

    listChartState = AppState.finish;
    notifyListeners();
  }
}

class ListChartCategoryModel {
  CategoryModel model;
  double amount;
  int count;

  ListChartCategoryModel({
    required this.model,
    required this.amount,
    required this.count,
  });
}
