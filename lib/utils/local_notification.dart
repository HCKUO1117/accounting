import 'dart:math';

import 'package:accounting/app.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum Slang {
  slang1,
  slang2,
  slang3,
}

extension SlangEx on Slang {
  String get text {
    switch (this) {
      case Slang.slang1:
        return S.of(App.navigatorKey.currentContext!).slang1;
      case Slang.slang2:
        return S.of(App.navigatorKey.currentContext!).slang2;
      case Slang.slang3:
        return S.of(App.navigatorKey.currentContext!).slang3;
    }
  }
}

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(BuildContext context) async {
    var result = await checkPermission();
    if (!result) {
      ShowToast.showToast(S.of(context).openAlarmPermission);
    }
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  Future<bool> checkPermission() async {
    bool? result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications();
    if (result == true) return true;
    bool? r = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    return r == true;
  }

  Future<void> displayNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, 'plain title', 'plain body', platformChannelSpecifics, payload: 'item x');
  }

  Future<void> scheduleNotification(
      int id, TimeOfDay timeOfDay, int nowWeekday, int chooseWeekDay) async {
    DateTime dateTime = DateTime.now();
    int r = Random().nextInt(2);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        Slang.values[r].text,
        S.of(App.navigatorKey.currentContext!).savingNow,
        tz.TZDateTime.local(
          dateTime.year,
          dateTime.month,
          dateTime.day + chooseWeekDay - nowWeekday,
          timeOfDay.hour,
          timeOfDay.minute,
        ),
        NotificationDetails(
          android: AndroidNotificationDetails('$id', '$id', channelDescription: '$id'),
        ),
        // androidAllowWhileIdle: true,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> periodNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeating channel id', 'repeating channel name',
        channelDescription: 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0, 'repeating title', 'repeating body', RepeatInterval.weekly, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> pendingNotification() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(pendingNotificationRequests);
  }

  Future<void> deleteNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
