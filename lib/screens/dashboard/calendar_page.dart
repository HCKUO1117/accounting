import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/widget/accounting_title.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_recode_page.dart';

class CalendarPage extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final double topPadding;

  const CalendarPage({
    Key? key,
    required this.start,
    required this.end,
    required this.topPadding,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin {
  DateTime? start;
  DateTime? end;

  int currentType = 0;

  late final TabController _pageController;

  final DateRangePickerController _controller = DateRangePickerController();
  final DateRangePickerController _yearController = DateRangePickerController();
  dynamic args;

  @override
  void initState() {
    start = widget.start;
    end = widget.end;
    _pageController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  provider.balance.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${S.of(context).income} : ',
                            style: const TextStyle(
                              fontFamily: 'RobotoMono',
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            provider.currentIncome.toString(),
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${S.of(context).expenditure} : ',
                            style: const TextStyle(
                              fontFamily: 'RobotoMono',
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            provider.currentExpenditure.toString(),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              controller: _pageController,
              tabs: [
                Tab(
                  text: S.of(context).day,
                ),
                Tab(
                  text: S.of(context).month,
                ),
                Tab(
                  text: S.of(context).year,
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              day(provider),
              month(provider),
              year(provider),
            ],
          ),
        );
      },
    );
  }

  Widget day(MainProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(1970),
            lastDay: DateTime(DateTime.now().year + 100),
            focusedDay: DateTime.now(),
            currentDay: DateTime.now(),
            daysOfWeekHeight: 60,
            rangeStartDay: start,
            rangeEndDay: end,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            availableGestures: AvailableGestures.horizontalSwipe,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.orange),
              ),
              todayTextStyle: const TextStyle(color: Colors.black),
            ),
            onRangeSelected: (s, e, t) {
              setState(() {
                start = s;
                if (e == null) {
                  end = start;
                } else {
                  end = e;
                }
              });

              _controller.selectedRange = PickerDateRange(start, end);
              _yearController.selectedRange = PickerDateRange(start, end);

              provider.dashBoardStartDate = start!;
              provider.dashBoardEndDate = end != null ? end! : start!;
              provider.setCurrentAccounting(start!, end != null ? end! : start!);
              provider.selectedValue = 5;
            },
            onHeaderTapped: (d) {},
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, d, _) {
                double amount = 0;
                bool show = false;
                for (var element in provider.accountingList) {
                  if (Utils.checkIsSameDay(element.date, d)) {
                    amount += element.amount;
                    show = true;
                  }
                }
                if (!show) {
                  return null;
                }
                return Text(
                  amount.toString(),
                  style: TextStyle(
                    color: amount < 0 ? Colors.redAccent : Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    shadows: const <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          provider.currentAccountingList.isEmpty
              ? Column(
                  children: [
                    Text(
                      S.of(context).noRecord,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/icons/question.png',
                      height: 50,
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    top: 32,
                    left: 16,
                    right: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.currentAccountingList.length,
                  itemBuilder: (context, index) {
                    return AccountingTitle(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(top: widget.topPadding),
                            child: AddRecodePage(
                              model: provider.currentAccountingList[index],
                            ),
                          ),
                        );
                      },
                      model: provider.currentAccountingList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 4);
                  },
                ),
        ],
      ),
    );
  }

  Widget month(MainProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SfDateRangePicker(
            controller: _controller,
            onSelectionChanged: (arg) {
              args = arg;
              PickerDateRange range = arg.value;
              setState(() {
                start = range.startDate!;
                if (range.endDate != null) {
                  end = range.endDate!;
                } else {
                  DateTime lastDayOfMonth = DateTime(start!.year, start!.month + 1, 0);
                  end = lastDayOfMonth;
                }
                _yearController.selectedRange = PickerDateRange(start, end);
              });
              provider.dashBoardStartDate = start!;
              provider.dashBoardEndDate = end != null ? end! : start!;
              provider.setCurrentAccounting(start!, end != null ? end! : start!);
              provider.selectedValue = 5;
            },
            view: DateRangePickerView.year,
            allowViewNavigation: false,
            initialSelectedRange: PickerDateRange(start, end),
            navigationMode: DateRangePickerNavigationMode.scroll,
            selectionMode: DateRangePickerSelectionMode.range,
            cellBuilder: (BuildContext context, DateRangePickerCellDetails cellDetails) {
              double amount = 0;
              bool show = false;
              for (var element in provider.accountingList) {
                if (element.date.year == cellDetails.date.year &&
                    element.date.month == cellDetails.date.month) {
                  amount += element.amount;
                  show = true;
                }
              }
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
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.MMMM().format(cellDetails.date),
                      style: TextStyle(
                        color: Utils.checkIsSameMonth(cellDetails.date, start!) ||
                                Utils.checkIsSameMonth(cellDetails.date, end!)
                            ? Colors.white
                            : null,
                      ),
                    ),
                    if (show)
                      Expanded(
                        child: Center(
                          child: Text(
                            amount.toString(),
                            style: TextStyle(
                              color: amount < 0 ? Colors.redAccent : Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: const <Shadow>[
                                Shadow(
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 10.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          provider.currentAccountingList.isEmpty
              ? Column(
                  children: [
                    Text(
                      S.of(context).noRecord,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/icons/question.png',
                      height: 50,
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    top: 32,
                    left: 16,
                    right: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.currentAccountingList.length,
                  itemBuilder: (context, index) {
                    return AccountingTitle(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(top: widget.topPadding),
                            child: AddRecodePage(
                              model: provider.currentAccountingList[index],
                            ),
                          ),
                        );
                      },
                      model: provider.currentAccountingList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 4);
                  },
                ),
        ],
      ),
    );
  }

  Widget year(MainProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SfDateRangePicker(
            controller: _yearController,
            onSelectionChanged: (arg) {
              args = arg;
              PickerDateRange range = arg.value;
              setState(() {
                start = range.startDate!;
                if (range.endDate != null) {
                  end = range.endDate!;
                } else {
                  DateTime lastDayOfMonth = DateTime(start!.year + 1, 0);
                  end = lastDayOfMonth;
                }
                _controller.selectedRange = PickerDateRange(start, end);
              });
              provider.dashBoardStartDate = start!;
              provider.dashBoardEndDate = end != null ? end! : start!;
              provider.setCurrentAccounting(start!, end != null ? end! : start!);
              provider.selectedValue = 5;
            },
            view: DateRangePickerView.decade,
            allowViewNavigation: false,
            initialSelectedRange: PickerDateRange(widget.start, widget.end),
            navigationMode: DateRangePickerNavigationMode.scroll,
            selectionMode: DateRangePickerSelectionMode.range,
            cellBuilder: (BuildContext context, DateRangePickerCellDetails cellDetails) {
              double amount = 0;
              bool show = false;
              for (var element in provider.accountingList) {
                if (element.date.year == cellDetails.date.year) {
                  amount += element.amount;
                  show = true;
                }
              }
              return Container(
                width: cellDetails.bounds.width,
                height: cellDetails.bounds.height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: cellDetails.date.year == DateTime.now().year
                      ? Border.all(color: Colors.orange)
                      : null,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      cellDetails.date.year.toString(),
                      style: TextStyle(
                        color: Utils.checkIsSameYear(cellDetails.date, start!) ||
                                Utils.checkIsSameYear(cellDetails.date, end!)
                            ? Colors.white
                            : null,
                      ),
                    ),
                    if (show)
                      Expanded(
                        child: Center(
                          child: Text(
                            amount.toString(),
                            style: TextStyle(
                              color: amount < 0 ? Colors.redAccent : Colors.blueAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              shadows: const <Shadow>[
                                Shadow(
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 10.0,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          provider.currentAccountingList.isEmpty
              ? Column(
                  children: [
                    Text(
                      S.of(context).noRecord,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/icons/question.png',
                      height: 50,
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    top: 32,
                    left: 16,
                    right: 16,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.currentAccountingList.length,
                  itemBuilder: (context, index) {
                    return AccountingTitle(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(top: widget.topPadding),
                            child: AddRecodePage(
                              model: provider.currentAccountingList[index],
                            ),
                          ),
                        );
                      },
                      model: provider.currentAccountingList[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 4);
                  },
                ),
        ],
      ),
    );
  }
}
