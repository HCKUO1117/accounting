import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePickerDialog extends StatelessWidget {
  const CustomDatePickerDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        height: 500,
        width: 500,
        child: SfDateRangePicker(
          onSelectionChanged: (arg){
            print(arg.value);
          },
          selectionMode: DateRangePickerSelectionMode.range,
        ),
      ),
    );
  }
}
