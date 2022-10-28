import 'package:accounting/db/notification_data.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/reminder_data.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/widget/custom_dialog.dart';
import 'package:accounting/screens/widget/notification_card.dart';
import 'package:accounting/utils/local_notification.dart';
import 'package:accounting/utils/my_banner_ad.dart';
import 'package:accounting/utils/translate_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  LocalNotification localNotification = LocalNotification();

  ReminderData reminderData = ReminderData();

  @override
  void initState() {
    localNotification.init((p0) {});
    localNotification.pendingNotification();
    reminderData.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: reminderData,
      child: Consumer(
        builder: (context, ReminderData data, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(S
                  .of(context)
                  .notification, style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),),
            ),
            body: ListView.builder(
                itemCount: data.notifications.length + 1,
                itemBuilder: (context, index) {
                  if (index == data.notifications.length) {
                    return Column(
                      children: const [
                        SizedBox(height: 32),
                        AdBanner(large: true),
                      ],
                    );
                  }

                  return NotificationCard(
                    notificationData: data.notifications[index],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              foregroundColor: Colors.white,
              onPressed: () async {
                final TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 0, minute: 0),
                );
                if (newTime != null) {
                  data.resetWeek();
                  bool? set = await showDialog(
                    context: context,
                    builder: (context) =>
                        ChangeNotifierProvider.value(
                          value: data,
                          child: CustomDialog(
                            content: S
                                .of(context)
                                .repeat,
                            child: Consumer(
                              builder: (context, ReminderData data, _) {
                                return Column(
                                  children: [
                                    for (int i = 0; i < Constants.weeks.length; i++)
                                      CheckboxListTile(
                                        value:
                                        data.weekCheck[i] == 1 ? true : false,
                                        title: Text(TranslateLanguage()
                                            .getLanguageByContext(
                                            Constants.weeks[i])),
                                        onChanged: (value) {
                                          data.setWeek(i, value! ? 1 : 0);
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                  );
                  if (set ?? false) {
                    data.insert(
                      NotificationData(
                        id: null,
                        content: 'test',
                        timeOfDay: newTime,
                        open: true,
                        weekTimes: data.weekCheck,
                      ),
                    );
                  }
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
