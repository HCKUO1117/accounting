import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowToast {
  static void showToast(
    String msg,
  ) {
    Fluttertoast.showToast(
        msg: msg, backgroundColor: Colors.grey.withOpacity(0.9));
  }
}
