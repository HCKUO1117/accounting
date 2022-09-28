import 'package:accounting/models/icon_model.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/res/icons.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:flutter/material.dart';

class IconProvider with ChangeNotifier {
  List<IconModel> list = [];

  String selected = '';

  void fetch({String? keyword}) {
    selected = Preferences.getString(Constants.setIcon, '');
    icons.forEach((key, value) {
      list.add(IconModel(name: key, iconData: value));
    });
    notifyListeners();
  }

  void setIcon(String name) {
    if (name == selected) {
    } else {
      selected = name;
    }

    notifyListeners();
  }
}
