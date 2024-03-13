import 'package:accounting/db/notification_data.dart';
import 'package:accounting/db/notification_db.dart';
import 'package:accounting/utils/local_notification.dart';
import 'package:accounting/utils/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class ReminderData extends ChangeNotifier {
  List<NotificationData> notifications = [];

  List<int> weekCheck = [
    for (int i = 0; i < 7; i++) 1,
  ];

  void resetWeek() {
    for (int i = 0; i < weekCheck.length; i++) {
      weekCheck[i] = 1;
    }
    notifyListeners();
  }

  void setWeek(int i, int value) {
    weekCheck[i] = value;
    notifyListeners();
  }

  Future<void> fetch() async {
    notifications = await NotificationDB.displayAllData();
    notifications.sort((a, b) {
      int aa = a.timeOfDay.hour * 100 + a.timeOfDay.minute;
      int bb = b.timeOfDay.hour * 100 + b.timeOfDay.minute;

      return aa.compareTo(bb);
    });
    notifyListeners();
  }

  Future<void> insert(NotificationData notificationData, BuildContext context) async {
    bool result = await LocalNotification().checkPermission();
    if (!result) {
      ShowToast.showToast(S.of(context).openAlarmPermission);
      return;
    }
    await NotificationDB.insertData(notificationData);
    await fetch();
    await setNotification(context);
  }

  Future<void> update(NotificationData notificationData, BuildContext context) async {
    bool result = await LocalNotification().checkPermission();
    if (!result) {
      ShowToast.showToast(S.of(context).openAlarmPermission);
      return;
    }
    await NotificationDB.updateData(notificationData);
    await fetch();
    await setNotification(context);
  }

  Future<void> delete(NotificationData notificationData, BuildContext context) async {
    // bool result = await LocalNotification().checkPermission();
    // if (!result) {
    //   ShowToast.showToast(S.of(context).openAlarmPermission);
    //   return;
    // }
    await NotificationDB.deleteData(notificationData);
    await fetch();
    await setNotification(context);
  }

  Future<void> setNotification(BuildContext context) async {

    await LocalNotification().deleteNotification();
    for (int i = 0; i < notifications.length; i++) {
      if (notifications[i].open) {
        for (int j = 0; j < notifications[i].weekTimes.length; j++) {
          if (notifications[i].weekTimes[j] == 1) {
            await LocalNotification().scheduleNotification(
              notifications[i].id! * 10 + j + 1,
              notifications[i].timeOfDay,
              DateTime.now().weekday,
              j + 1,
            );
          }
        }
      }
    }
  }
}
