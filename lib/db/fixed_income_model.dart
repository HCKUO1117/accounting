import 'package:accounting/generated/l10n.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/cupertino.dart';

enum FixedIncomeType {
  eachDay,
  eachMonth,
  eachYear,
}

extension FixedIncomeTypeEx on FixedIncomeType {
  String text(BuildContext context) {
    switch (this) {
      case FixedIncomeType.eachDay:
        return S.of(context).eachDay;
      case FixedIncomeType.eachMonth:
        return S.of(context).eachMonth;
      case FixedIncomeType.eachYear:
        return S.of(context).eachYear;
    }
  }

  int get minDay {
    switch (this) {
      case FixedIncomeType.eachDay:
        return 0;
      case FixedIncomeType.eachMonth:
        return 1;
      case FixedIncomeType.eachYear:
        return 1;
    }
  }

  int get maxDay {
    switch (this) {
      case FixedIncomeType.eachDay:
        return 23;
      case FixedIncomeType.eachMonth:
        return 28;
      case FixedIncomeType.eachYear:
        return 28;
    }
  }
}

class FixedIncomeModel {
  int? id;
  FixedIncomeType type;
  int month;
  int day;
  int category;
  List<int> tags;
  double amount;
  String note;
  DateTime createDate;
  DateTime? lastAddTime;

  FixedIncomeModel({
    this.id,
    required this.type,
    required this.month,
    required this.day,
    required this.category,
    required this.tags,
    required this.amount,
    required this.note,
    required this.createDate,
    this.lastAddTime,
  });

  Map<String, dynamic> toMap() {
    String tagString = tags.toString();

    return {
      'type': type.index,
      'month': month,
      'day': day,
      'category': category,
      'tags': tagString.replaceAll('[', '').replaceAll(']', ''),
      'amount': amount.toString(),
      'note': note,
      'createDate': Utils.toDateTimeString(createDate),
      'lastAddTime': lastAddTime == null ? null : Utils.toDateTimeString(lastAddTime!),
    };
  }

  factory FixedIncomeModel.fromJson(Map json){
    List<int> tags = [];
    if (json['tags'].toString().isNotEmpty) {
      tags = [
        for (var element in json['tags'].toString().split(',')) int.parse(element)
      ];
    }

    return FixedIncomeModel(
      type: FixedIncomeType.values[json['type']],
      month: json['month'],
      day: json['day'],
      category: json['category'],
      tags: tags,
      amount: double.parse(json['amount']),
      note: json['note'],
      createDate: DateTime.parse(json['createDate']),
      lastAddTime: json['lastAddTime'] != null ? DateTime.parse(json['lastAddTime']) : null,
    );
  }

  @override
  String toString() {
    return 'id : $id\ntype : $type\nmonth : $month\nday : $day \ncategory : $category\ntags : $tags\namount : $amount\nnote : $note \ncreateDate : $createDate';
  }
}
