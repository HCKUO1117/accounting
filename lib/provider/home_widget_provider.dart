import 'dart:convert';
import 'dart:math';

import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

class HomeWidgetProvider with ChangeNotifier {
  void init() {
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  Future<void> sendAndUpdate() async {
    List<AccountingModel> list = await AccountingDB.displayAllData();
    List<AccountingModel> todayList = [];
    List<CategoryModel> categories = await CategoryDB.displayAllData();

    List<Map<String, dynamic>> mapList = [];

    double budget = double.parse(Preferences.getString(Constants.goalNum, '-1'));
    print(budget);
    double income = 0;
    double expenditure = 0;
    double monthExpenditure = 0;

    for (var element in list) {
      if (Utils.checkIsSameDay(element.date, DateTime.now())) {
        todayList.add(element);
        String? categoryName = '';
        if (categories.indexWhere((e) => e.id == element.category) != -1) {
          categoryName = categories.firstWhere((e) => e.id == element.category).name;
        } else {
          categoryName = '';
        }

        mapList.add({
          'date': Utils.toDateTimeString(element.date),
          'amount': element.amount,
          'category': categoryName
        });

        if (element.amount < 0) {
          expenditure += element.amount;
        } else {
          income += element.amount;
        }
      }
      if(Utils.checkIsSameMonth(element.date, DateTime.now())){
        if(element.amount < 0){
          monthExpenditure += element.amount;
        }
      }
    }

    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        Utils.toDateString(DateTime.now(),format: 'yyyy/MM/dd'),
      ),
      HomeWidget.saveWidgetData(
        'message',
        List.generate(mapList.length, (index) => jsonEncode(mapList[index])).toString(),
      ),
      HomeWidget.saveWidgetData(
        'income',
        income.toString(),
      ),
      HomeWidget.saveWidgetData(
        'expenditure',
        expenditure.toString(),
      ),
      HomeWidget.saveWidgetData(
        'balance',
        (income + expenditure).toString(),
      ),
      HomeWidget.saveWidgetData(
        'budget',
        budget.toString(),
      ),
      HomeWidget.saveWidgetData(
        'monthExpenditure',
        monthExpenditure.toString(),
      ),
      HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        iOSName: 'HomeWidgetExample',
      ),
    ]).then((value) {});
  }

  void startBackgroundUpdate() {
    Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: const Duration(minutes: 15));
  }

// void _stopBackgroundUpdate() {
//   Workmanager().cancelByUniqueName('1');
// }
}

/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    List<AccountingModel> list = await AccountingDB.displayAllData();
    List<AccountingModel> todayList = [];
    List<CategoryModel> categories = await CategoryDB.displayAllData();

    List<Map<String, dynamic>> mapList = [];

    double budget = double.parse(Preferences.getString(Constants.goalNum, '-1'));
    double income = 0;
    double expenditure = 0;
    double monthExpenditure = 0;

    for (var element in list) {
      if (Utils.checkIsSameDay(element.date, DateTime.now())) {
        todayList.add(element);
        String categoryName = '';
        if (categories.indexWhere((e) => e.id == element.category) != -1) {
          categoryName = categories.firstWhere((e) => e.id == element.category).name;
        } else {
          categoryName = "";
        }

        mapList.add({
          'date': Utils.toDateTimeString(element.date),
          'amount': element.amount,
          'category': categoryName
        });

        if (element.amount < 0) {
          expenditure += element.amount;
        } else {
          income += element.amount;
        }
      }
      if(Utils.checkIsSameMonth(element.date, DateTime.now())){
        if(element.amount < 0){
          monthExpenditure += element.amount;
        }
      }
    }


    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        Utils.toDateString(DateTime.now(),format: 'yyyy/MM/dd'),
      ),
      HomeWidget.saveWidgetData(
        'message',
        List.generate(mapList.length, (index) => jsonEncode(mapList[index])).toString(),
      ),
      HomeWidget.saveWidgetData(
        'income',
        income.toString(),
      ),
      HomeWidget.saveWidgetData(
        'expenditure',
        expenditure.toString(),
      ),
      HomeWidget.saveWidgetData(
        'balance',
        (income + expenditure).toString(),
      ),
      HomeWidget.saveWidgetData(
        'budget',
        budget.toString(),
      ),
      HomeWidget.saveWidgetData(
        'monthExpenditure',
        monthExpenditure.toString(),
      ),
      HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        iOSName: 'HomeWidgetExample',
      ),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

/// Called when Doing Background Work initiated from Widget
dynamic backgroundCallback(Uri? data) async {
  if (data?.host == 'titleclicked') {
    final greetings = ['Hello', 'Hallo', 'Bonjour', 'Hola', 'Ciao', '哈洛', '안녕하세요', 'xin chào'];
    final selectedGreeting = greetings[Random().nextInt(greetings.length)];

    await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
    await HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
  }
}
