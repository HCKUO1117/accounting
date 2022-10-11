import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/widget/accounting_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_recode_page.dart';

class CalendarPage extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final double topPadding;

  const CalendarPage({
    Key? key,
    required this.start,
    required this.end, required this.topPadding,
  }) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? start;
  DateTime? end;

  @override
  void initState() {
    start = widget.start;
    end = widget.end;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
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
                      end = e;
                    });

                      provider.dashBoardStartDate = start!;
                      provider.dashBoardEndDate = end != null ?end! :start!;
                      provider.setCurrentAccounting(start!, end != null ?end! :start!);
                      provider.selectedValue = 5;

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
                                ),),
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
          ),
        );
      },
    );
  }
}
