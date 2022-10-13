import 'dart:math';

import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/custom_date_picker_dialog.dart';
import 'package:accounting/screens/dashboard/add_recode_page.dart';
import 'package:accounting/screens/dashboard/calendar_page.dart';
import 'package:accounting/screens/widget/accounting_title.dart';
import 'package:accounting/utils/utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DashBoardScreen extends StatefulWidget {
  final double topPadding;

  const DashBoardScreen({
    Key? key,
    required this.topPadding,
  }) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    context.read<MainProvider>().getCategoryList();
    context.read<MainProvider>().getTagList();
    context.read<MainProvider>().getAccountingList();

    super.initState();
  }

  late List<String> items;

  @override
  Widget build(BuildContext context) {
    items = [
      S.of(context).today,
      S.of(context).yesterday,
      S.of(context).thisWeek,
      S.of(context).thisMonth,
      S.of(context).thisYear,
      S.of(context).customize,
    ];
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        if (provider.selectedValue == 5) {
          items[5] =
              '${Utils.toDateString(provider.dashBoardStartDate)}${!provider.samDay ? ' ~ ' : ''}${!provider.samDay ? Utils.toDateString(provider.dashBoardEndDate) : ''}';
        }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.backgroundColor,
            centerTitle: true,
            title: DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                items: [
                  for (int i = 0; i < items.length; i++)
                    DropdownMenuItem<int>(
                      alignment: AlignmentDirectional.center,
                      value: i,
                      child: Text(
                        items[i],
                        style: const TextStyle(
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
                value: provider.selectedValue,
                onChanged: (value) async {
                  final DateTime d = DateTime.now();
                  if (value == 0) {
                    provider.setDashBoardDateRange(
                      DateTimeRange(
                        start: DateTime(d.year, d.month, d.day),
                        end: DateTime(d.year, d.month, d.day),
                      ),
                    );
                  }
                  if (value == 1) {
                    provider.setDashBoardDateRange(
                      DateTimeRange(
                        start: DateTime(d.year, d.month, d.day - 1),
                        end: DateTime(d.year, d.month, d.day - 1),
                      ),
                    );
                  }
                  if (value == 2) {
                    final int weekDay = d.weekday;
                    final DateTime firstDayOfWeek =
                        DateTime(d.year, d.month, d.day).subtract(Duration(days: weekDay - 1));
                    provider.setDashBoardDateRange(
                      DateTimeRange(
                        start: firstDayOfWeek,
                        end: DateTime(d.year, d.month, d.day),
                      ),
                    );
                  }
                  if (value == 3) {
                    final DateTime firstDayOfMonth = DateTime(d.year, d.month, 1);
                    provider.setDashBoardDateRange(
                      DateTimeRange(
                        start: firstDayOfMonth,
                        end: DateTime(d.year, d.month, d.day),
                      ),
                    );
                  }
                  if (value == 4) {
                    final DateTime firstDayOfYear = DateTime(d.year, 1, 1);
                    provider.setDashBoardDateRange(
                      DateTimeRange(
                        start: firstDayOfYear,
                        end: DateTime(d.year, d.month, d.day),
                      ),
                    );
                  }
                  if (value == 5) {
                    DateTimeRange? range;
                    await CustomDatePickerDialog.show(
                      context,
                      onDateSelect: (arg) {
                        PickerDateRange r = arg.value;
                        range = DateTimeRange(
                          start: r.startDate!,
                          end: r.endDate != null ? r.endDate! : r.startDate!,
                        );
                      },
                      start: provider.dashBoardStartDate,
                      end: provider.dashBoardEndDate,
                    );
                    if (range == null) {
                      return;
                    }
                    provider.setDashBoardDateRange(range!);
                    // DateTimeRange? range = await showDateRangePicker(
                    //   context: context,
                    //   initialDateRange: DateTimeRange(
                    //       start: provider.dashBoardStartDate, end: provider.dashBoardEndDate),
                    //   firstDate: DateTime(1970, 1, 1),
                    //   lastDate: d,
                    //   locale: App.of(context)?.locale ?? const Locale('en', ''),
                    // );
                    // if (range == null) {
                    //   return;
                    // }
                    // provider
                    //     .setDashBoardDateRange(DateTimeRange(start: range.start, end: range.end));
                  }
                  setState(() {
                    provider.selectedValue = value as int;
                  });
                },
                iconSize: 14,
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: Colors.white,
                ),
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DashBoardSliverPersistentHeaderDelegate(
                  maxEx: MediaQuery.of(context).size.height / 3 + 100,
                  minEx: 100,
                  topPadding: widget.topPadding,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ColoredBox(
                    color: AppColors.backgroundColor,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            100 -
                            (MediaQuery.of(context).padding.top +
                                kToolbarHeight +
                                MediaQuery.of(context).padding.bottom +
                                kBottomNavigationBarHeight),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: provider.currentAccountingList.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height / 10,
                                  ),
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
                                padding: const EdgeInsets.only(bottom: 50),
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
                      ),
                    ),
                  ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PieData {
  _PieData(
    this.xData,
    this.yData,
    this.text,
    this.color,
  );

  final String xData;
  final num yData;
  final String text;
  final Color color;
}

class DashBoardSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxEx;
  final double minEx;
  final double topPadding;

  DashBoardSliverPersistentHeaderDelegate({
    required this.maxEx,
    required this.minEx,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        ///預算餘額
        double budgetLeft = provider.goalNum;
        double expenditure = 0;
        for (var element in provider.accountingList) {
          if (Utils.checkIsSameMonth(element.date, DateTime.now())) {
            if (element.amount < 0) {
              expenditure += element.amount;
            }
          }
        }
        budgetLeft += expenditure;

        return Material(
          color: Colors.white,
          child: Container(
            color: AppColors.backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    const SizedBox(
                      width: double.maxFinite,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        height: max(
                          50,
                          80 * (1 - shrinkPercentage),
                        ),
                      ),
                      child: FittedBox(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            provider.balance.toString(),
                            style: const TextStyle(
                              fontFamily: 'RobotoMono',
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarPage(
                                start: provider.dashBoardStartDate,
                                end: provider.dashBoardEndDate,
                                topPadding: topPadding,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (shrinkPercentage != 1)
                        Opacity(
                          opacity: 1 - shrinkPercentage,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.orange)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            S.of(context).income,
                                            style: const TextStyle(
                                              fontFamily: 'RobotoMono',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            provider.currentIncome.toString(),
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      height: 30,
                                      width: 1,
                                      color: Colors.black12,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            S.of(context).expenditure,
                                            style: const TextStyle(
                                              fontFamily: 'RobotoMono',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            provider.currentExpenditure.toString(),
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: SfCircularChart(
                                    legend: Legend(isVisible: false),
                                    series: <PieSeries<_PieData, String>>[
                                      PieSeries<_PieData, String>(
                                        strokeColor: Colors.black,
                                        strokeWidth: 1,
                                        explode: true,
                                        explodeIndex: 0,
                                        animationDuration: 600,
                                        dataSource: [
                                          if (provider.allEmpty || provider.currentExpenditure != 0)
                                            _PieData(
                                              S.of(context).expenditure,
                                              provider.allEmpty ? 1 : provider.currentExpenditure,
                                              S.of(context).expenditure,
                                              Colors.redAccent.shade100,
                                            ),
                                          if (provider.allEmpty || provider.currentIncome != 0)
                                            _PieData(
                                              S.of(context).income,
                                              provider.allEmpty ? 1 : provider.currentIncome,
                                              S.of(context).income,
                                              Colors.blueAccent.shade100,
                                            ),
                                        ],
                                        xValueMapper: (_PieData data, _) => data.xData,
                                        yValueMapper: (_PieData data, _) => data.yData,
                                        dataLabelMapper: (_PieData data, _) => data.text,
                                        pointColorMapper: (_PieData data, _) => data.color,
                                        dataLabelSettings: const DataLabelSettings(
                                          isVisible: true,
                                          textStyle: TextStyle(
                                            fontFamily: 'RobotoMono',
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 5.0,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (provider.goalNum != -1) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(width: 16),
                                    Text(
                                      '${DateFormat('yyyy/MM').format(DateTime.now())} ${S.of(context).budgetLeft} : ',
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(fontFamily: 'RobotoMono'),
                                    ),
                                    Text(
                                      ' $budgetLeft',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            budgetLeft < 0 ? Colors.redAccent : Colors.blueAccent,
                                      ),
                                      strutStyle: const StrutStyle(forceStrutHeight: true,height: 1.5,),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ]
                            ],
                          ),
                        ),
                      if (shrinkPercentage != 0)
                        Opacity(
                          opacity: shrinkPercentage,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${S.of(context).income} : ',
                                      style: const TextStyle(
                                        fontFamily: 'RobotoMono',
                                      ),
                                    ),
                                    Text(
                                      provider.currentIncome.toString(),
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
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
                                      ),
                                    ),
                                    Text(
                                      provider.currentExpenditure.toString(),
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => maxEx;

  @override
  double get minExtent => minEx;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true; // 如果内容需要更新，设置为true
}
