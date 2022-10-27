import 'package:flutter/material.dart';

class NotificationData {
  int? id;
  String content;
  TimeOfDay timeOfDay;
  List<int> weekTimes;
  bool open;

  NotificationData({
    required this.id,
    required this.content,
    required this.timeOfDay,
    required this.open,
    required this.weekTimes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'time': timeOfDay.hour.toString() + ':' + timeOfDay.minute.toString(),
      'weekTimes':weekTimes,
      'open': open.toString()
    };
  }

  @override
  String toString() {
    return 'id: $id,content: $content,time: $timeOfDay,weekTimes: $weekTimes,open : $open';
  }
}
