import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final Function(DateRangePickerSelectionChangedArgs) onDateSelect;
  final DateTime start;
  final DateTime end;

  const CustomDatePickerDialog({
    Key? key,
    required this.onDateSelect,
    required this.start,
    required this.end,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required Function(DateRangePickerSelectionChangedArgs) onDateSelect,
    required DateTime start,
    required DateTime end,
  }) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        onDateSelect: onDateSelect,
        start: start,
        end: end,
      ),
    );
  }

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  dynamic args;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: 500,
        child: SfDateRangePicker(
          onSelectionChanged: (arg) {
            args = arg;
          },
          initialSelectedRange: PickerDateRange(widget.start, widget.end),
          selectionMode: DateRangePickerSelectionMode.range,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            widget.onDateSelect(args);
            Navigator.pop(context);
          },
          child: const Text('確定'),
        ),
      ],
    );
  }
}
