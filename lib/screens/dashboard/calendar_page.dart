import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/models/date_model.dart';
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Utils.toDateString(provider.dashBoardStartDate)}${!provider.samDay ? ' ~ ' : ''}${!provider.samDay ? Utils.toDateString(provider.dashBoardEndDate) : ''}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      provider.balance.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
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
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            provider.currentIncome.toString(),
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 14,
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
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            provider.currentExpenditure.toString(),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
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
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
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
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 24),
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).income,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).expenditure,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).balance,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          Builder(
            builder: (context) {
              List<DateModel> list = [];
              for (DateTime i = start!;
                  i.year != end!.year || i.month != end!.month;
                  i = DateTime(i.year, i.month + 1)) {
                list.insert(
                  0,
                  DateModel(
                    year: i.year,
                    month: i.month,
                  ),
                );
              }
              list.insert(
                0,
                DateModel(
                  year: end!.year,
                  month: end!.month,
                ),
              );
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final List<AccountingModel> l = [];
                  List<int> dList = [];
                  for (var element in provider.accountingList) {
                    if (element.date.year == list[index].year &&
                        element.date.month == list[index].month) {
                      l.add(element);

                      dList.add(element.date.day);
                    }
                  }
                  dList = dList.toSet().toList();
                  dList.sort(
                    (a, b) => b.compareTo(a),
                  );
                  l.sort((a, b) => b.date.compareTo(a.date));

                  ///這個月總計
                  double monthIncome = 0;
                  double monthExpenditure = 0;
                  for (var element in l) {
                    if (element.date.year == list[index].year &&
                        element.date.month == list[index].month) {
                      if (element.amount > 0) {
                        monthIncome += element.amount;
                      } else {
                        monthExpenditure += element.amount;
                      }
                    }
                  }
                  final double total = monthIncome + monthExpenditure;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${list[index].year}/${list[index].month}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 50,
                            child: Text(
                              S.of(context).total,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    monthIncome.toString(),
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    monthExpenditure.toString(),
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    total.toString(),
                                    style: TextStyle(
                                      color: total < 0 ? Colors.redAccent : Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const Divider(),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double income = 0;
                          double outcome = 0;
                          for (var element in l) {
                            if (element.date.day == dList[index]) {
                              if (element.amount > 0) {
                                income += element.amount;
                              } else {
                                outcome += element.amount;
                              }
                            }
                          }
                          final balance = income + outcome;

                          return Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  DateFormat.d().format(DateTime(2000, 1, dList[index])),
                                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        income.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        outcome.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        balance.toString(),
                                        style: TextStyle(
                                          color: balance < 0 ? Colors.redAccent : Colors.blueAccent,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: dList.length,
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  );
                },
                itemCount: list.length,
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget year(MainProvider provider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54), borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SfDateRangePicker(
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
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 24),
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).income,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).expenditure,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).balance,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          Builder(
            builder: (context) {
              List<DateModel> list = [];
              for (DateTime i = start!; i.year != end!.year; i = DateTime(i.year + 1, 1)) {
                list.insert(
                  0,
                  DateModel(
                    year: i.year,
                    month: 1,
                  ),
                );
              }
              list.insert(
                0,
                DateModel(
                  year: end!.year,
                  month: 1,
                ),
              );
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final List<AccountingModel> l = [];
                  List<int> dList = [];
                  for (var element in provider.accountingList) {
                    if (element.date.year == list[index].year) {
                      l.add(element);

                      dList.add(element.date.month);
                    }
                  }
                  dList = dList.toSet().toList();
                  dList.sort(
                    (a, b) => b.compareTo(a),
                  );
                  l.sort((a, b) => b.date.compareTo(a.date));

                  ///這年總計
                  double monthIncome = 0;
                  double monthExpenditure = 0;
                  for (var element in l) {
                    if (element.date.year == list[index].year) {
                      if (element.amount > 0) {
                        monthIncome += element.amount;
                      } else {
                        monthExpenditure += element.amount;
                      }
                    }
                  }
                  final double total = monthIncome + monthExpenditure;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${list[index].year}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 50,
                            child: Text(
                              S.of(context).total,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    monthIncome.toString(),
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    monthExpenditure.toString(),
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    total.toString(),
                                    style: TextStyle(
                                      color: total < 0 ? Colors.redAccent : Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const Divider(),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double income = 0;
                          double outcome = 0;
                          for (var element in l) {
                            if (element.date.month == dList[index]) {
                              if (element.amount > 0) {
                                income += element.amount;
                              } else {
                                outcome += element.amount;
                              }
                            }
                          }
                          final balance = income + outcome;

                          return Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(
                                  DateFormat.MMM().format(DateTime(2000, dList[index])),
                                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        income.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        outcome.toString(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        balance.toString(),
                                        style: TextStyle(
                                          color: balance < 0 ? Colors.redAccent : Colors.blueAccent,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: dList.length,
                      )
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(),
                  );
                },
                itemCount: list.length,
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class TextRowSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxEx;
  final double minEx;

  TextRowSliverPersistentHeaderDelegate({
    required this.maxEx,
    required this.minEx,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Row(
          children: [
            const SizedBox(width: 24),
            const Text(
              '10',
              style: TextStyle(color: Colors.transparent, fontSize: 18),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).income,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).expenditure,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).balance,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
          ],
        );
      },
    );
  }

  @override
  double get maxExtent => maxEx;

  @override
  double get minExtent => minEx;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false; // 如果内容需要更新，设置为true
}
