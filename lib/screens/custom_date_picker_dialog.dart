import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final Function(DateRangePickerSelectionChangedArgs) onDateSelect;
  final DateTime start;
  final DateTime end;
  final bool showDot;
  final bool allowViewNavigation;
  final DateRangePickerView view;
  final bool noInit;

  const CustomDatePickerDialog({
    Key? key,
    required this.onDateSelect,
    required this.start,
    required this.end,
    this.showDot = true,
    this.allowViewNavigation = true,
    this.view = DateRangePickerView.month, this.noInit = false,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Function(DateRangePickerSelectionChangedArgs) onDateSelect,
    required DateTime start,
    required DateTime end,
    bool? showDot,
    bool? allowViewNavigation,
    DateRangePickerView? view,
        bool noInit = false,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        onDateSelect: onDateSelect,
        start: start,
        end: end,
        showDot: showDot ?? true,
        allowViewNavigation: allowViewNavigation ?? true,
        view: view ?? DateRangePickerView.month,
        noInit: noInit,
      ),
    );
  }

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  dynamic args;

  late DateTime start;
  late DateTime end;

  final DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    start = widget.start;
    end = widget.end;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width - 32,
        child: SfDateRangePicker(
          controller: _controller,
          onSelectionChanged: (arg) {
            args = arg;
            PickerDateRange range = arg.value;
            setState(() {
              start = range.startDate!;
              if (range.endDate != null) {
                end = range.endDate!;
              } else {
                end = start;
              }
            });
          },
          initialSelectedRange: widget.noInit ? null:PickerDateRange(widget.start, widget.end),
          navigationMode: DateRangePickerNavigationMode.scroll,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          selectionMode: DateRangePickerSelectionMode.range,
          allowViewNavigation: widget.allowViewNavigation,
          view: widget.view,
          cellBuilder: widget.showDot
              ? (BuildContext context, DateRangePickerCellDetails cellDetails) {
                  Widget dot = Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Utils.checkIsSameDay(cellDetails.date, start) ||
                              Utils.checkIsSameDay(cellDetails.date, end)
                          ? Colors.white
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );

                  if (_controller.view == DateRangePickerView.month) {
                    return Container(
                      width: cellDetails.bounds.width,
                      height: cellDetails.bounds.height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Utils.checkIsSameDay(cellDetails.date, DateTime.now())
                            ? Border.all(color: Colors.orange)
                            : null,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            cellDetails.date.day.toString(),
                            style: TextStyle(
                              color: Utils.checkIsSameDay(cellDetails.date, start) ||
                                      Utils.checkIsSameDay(cellDetails.date, end)
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                          if (context.read<MainProvider>().accountingList.indexWhere((element) =>
                                  Utils.checkIsSameDay(element.date, cellDetails.date)) !=
                              -1)
                            Expanded(
                                child: Center(
                              child: dot,
                            )),
                        ],
                      ),
                    );
                  } else if (_controller.view == DateRangePickerView.year) {
                    return Container(
                      width: cellDetails.bounds.width,
                      height: cellDetails.bounds.height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: cellDetails.date.year == DateTime.now().year &&
                                cellDetails.date.month == DateTime.now().month
                            ? Border.all(color: Colors.orange)
                            : null,
                      ),
                      child: Text(DateFormat.MMMM().format(cellDetails.date)),
                    );
                  } else if (_controller.view == DateRangePickerView.decade) {
                    return Container(
                      width: cellDetails.bounds.width,
                      height: cellDetails.bounds.height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: cellDetails.date.year == DateTime.now().year
                            ? Border.all(color: Colors.orange)
                            : null,
                      ),
                      child: Text(cellDetails.date.year.toString()),
                    );
                  } else {
                    final int yearValue = (cellDetails.date.year ~/ 10) * 10;
                    return Container(
                      width: cellDetails.bounds.width,
                      height: cellDetails.bounds.height,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: cellDetails.date.year <= DateTime.now().year &&
                                cellDetails.date.year + 9 >= DateTime.now().year
                            ? Border.all(color: Colors.orange)
                            : null,
                      ),
                      child: Text('$yearValue - ${yearValue + 9}'),
                    );
                  }
                }
              : null,
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
            if (args != null) {
              widget.onDateSelect(args);
            }
            Navigator.pop(context);
          },
          child: const Text('確定'),
        ),
      ],
    );
  }
}
