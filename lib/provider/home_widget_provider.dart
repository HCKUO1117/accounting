import 'dart:math';

import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';

class HomeWidgetProvider with ChangeNotifier {
  void init() {
    HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
  }

  Future<void> _sendData() async {
    try {
      Future.wait([
        HomeWidget.saveWidgetData<String>('title', '_titleController.text'),
        HomeWidget.saveWidgetData<String>('message', '_messageController.text'),
      ]);
    } on PlatformException catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future<void> _updateWidget() async {
    try {
      HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  void _startBackgroundUpdate() {
    Workmanager().registerPeriodicTask('1', 'widgetBackgroundUpdate',
        frequency: const Duration(minutes: 15));
  }

  void _stopBackgroundUpdate() {
    Workmanager().cancelByUniqueName('1');
  }
}

/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    List<AccountingModel> list = await AccountingDB.displayAllData();
    List<AccountingModel> todayList =
        list.where((element) => Utils.checkIsSameDay(element.date, DateTime.now())).toList();

    double budgetLeft = double.parse(Preferences.getString(Constants.goalNum, '-1'));
    if(budgetLeft != -1){
      double expenditure = 0;
      for (var element in list) {
        if (Utils.checkIsSameMonth(element.date, DateTime.now())) {
          if (element.amount < 0) {
            expenditure += element.amount;
          }
        }
      }
      budgetLeft += expenditure;
    }



    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        List.generate(todayList.length, (index) => todayList[index].toMap()),
      ),
      HomeWidget.saveWidgetData(
        'budget',
        budgetLeft,
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
