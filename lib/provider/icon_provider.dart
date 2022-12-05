import 'package:accounting/models/icon_model.dart';
import 'package:accounting/res/icons_to_show.dart';
import 'package:flutter/material.dart';

class IconProvider with ChangeNotifier {
  List<IconModel> list = [];

  String selected = '';

  void fetch({String? keyword,required String iconName}) {
    selected = iconName;
    iconsToShow.forEach((key, value) {
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
