import 'package:accounting/db/notification_data.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/reminder_data.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/widget/yes_no_dialog.dart';
import 'package:accounting/utils/translate_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_dialog.dart';

class NotificationCard extends StatefulWidget {
  final NotificationData notificationData;

  const NotificationCard({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    ReminderData data = context.read<ReminderData>();
    String week = '';
    for (int i = 0; i < Constants.weeksShort.length; i++) {
      if (widget.notificationData.weekTimes[i] == 1) {
        week +=
            TranslateLanguage().getLanguageByContext(Constants.weeksShort[i]);
        week += ',';
      }
    }
    if (week.isNotEmpty) {
      week = week.substring(0, week.length - 1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: widget.notificationData.timeOfDay.hour,
                          minute: widget.notificationData.timeOfDay.minute,
                        ),
                      );
                      if (newTime != null) {
                        await data.update(NotificationData(
                          id: widget.notificationData.id,
                          content: widget.notificationData.content,
                          timeOfDay: newTime,
                          open: widget.notificationData.open,
                          weekTimes: widget.notificationData.weekTimes,
                        ));
                      }
                    },
                    child: Text(
                      '${widget.notificationData.timeOfDay.hour < 10 ? '0' : ''}${widget.notificationData.timeOfDay.hour}:${widget.notificationData.timeOfDay.minute < 10
                              ? '0'
                              : ''}${widget.notificationData.timeOfDay.minute}',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  Switch(
                    value: widget.notificationData.open,
                    onChanged: (value) async {
                      await data.update(NotificationData(
                        id: widget.notificationData.id,
                        content: widget.notificationData.content,
                        timeOfDay: widget.notificationData.timeOfDay,
                        open: value,
                        weekTimes: widget.notificationData.weekTimes,
                      ));
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      data.weekCheck = widget.notificationData.weekTimes;
                      bool? set = await showDialog(
                        context: context,
                        builder: (context) => ChangeNotifierProvider.value(
                          value: data,
                          child: CustomDialog(
                            content: S.of(context).repeat,
                            child: Consumer(
                              builder: (context, ReminderData data, _) {
                                return Column(
                                  children: [
                                    for (int i = 0;
                                        i < Constants.weeks.length;
                                        i++)
                                      CheckboxListTile(
                                        value: data.weekCheck[i] == 1
                                            ? true
                                            : false,
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
                        await data.update(NotificationData(
                          id: widget.notificationData.id,
                          content: widget.notificationData.content,
                          timeOfDay: widget.notificationData.timeOfDay,
                          open: widget.notificationData.open,
                          weekTimes: data.weekCheck,
                        ));
                      }
                    },
                    child: Text(
                      week,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      bool? delete = await showDialog(
                          context: context,
                          builder: (context) => YesNoDialog(
                              content: S.of(context).deleteCheck));
                      if (delete ?? false) {
                        data.delete(widget.notificationData);
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
