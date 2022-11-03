import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/models/date_model.dart';
import 'package:accounting/models/states.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/chart/line_chart_setting_page.dart';
import 'package:accounting/utils/my_banner_ad.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../provider/iap.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    Future.delayed(
      Duration.zero,
      () {
        context.read<MainProvider>().drawLineChart(context);
        context.read<MainProvider>().drawPieChart(context);
        context.read<MainProvider>().drawStackChart(context);
      },
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
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              S.of(context).chart,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.compare_arrows),
            //   ),
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.restart_alt),
            //   ),
            // ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.show_chart)),
                Tab(icon: Icon(Icons.pie_chart_outline_outlined)),
                Tab(icon: Icon(Icons.stacked_bar_chart))
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              line(provider),
              pie(provider),
              stackColumn(provider),
            ],
          ),
        );
      },
    );
  }

  Widget line(MainProvider provider) {
    int r = DateTime.now().millisecondsSinceEpoch;
    if (provider.lineChartState == AppState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${Utils.dateStringByType(provider.lineChartStart, provider.lineScale)}${!provider.lineSamDay ? ' ~ ' : ''}${!provider.lineSamDay ? Utils.dateStringByType(provider.lineChartEnd, provider.lineScale) : ''}'),
                  Text(
                      '${S.of(context).timeScale} : ${provider.lineScale == 0 ? S.of(context).day : provider.lineScale == 1 ? S.of(context).month : S.of(context).year}')
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    scrollable: true,
                    content: const LineChartSettingPage(
                      type: ChartType.line,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            )
          ],
        ),
        SfCartesianChart(
          key: Key('$r line'),
          primaryXAxis: CategoryAxis(),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
          trackballBehavior: TrackballBehavior(
            enable: true,
            tooltipSettings: const InteractiveTooltip(enable: true),
            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            activationMode: ActivationMode.singleTap,
          ),
          series: provider.lineChartList,
        ),
        const SizedBox(height: 16),
         const AdBanner(large: false),
        if (provider.lineScale != 2)
          dayList(
            provider,
            start: provider.lineChartStart,
            end: provider.lineChartEnd,
            categoryFilter: provider.lineFilter,
            tagFilter: provider.lineTagFilter,
            scale: provider.lineScale,
            income: provider.lineCurrentIncome,
            expenditure: provider.lineCurrentExpenditure,
            allList: provider.lineAllList,
          )
        else
          yearList(
            provider,
            start: provider.lineChartStart,
            end: provider.lineChartEnd,
            categoryFilter: provider.lineFilter,
            tagFilter: provider.lineTagFilter,
            income: provider.lineCurrentIncome,
            expenditure: provider.lineCurrentExpenditure,
            allList: provider.lineAllList,
          )
      ],
    );
  }

  Widget pie(MainProvider provider) {
    int r = DateTime.now().millisecondsSinceEpoch;

    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${Utils.dateStringByType(provider.pieChartStart, provider.pieScale)}${!provider.pieSamDay ? ' ~ ' : ''}${!provider.pieSamDay ? Utils.dateStringByType(provider.pieChartEnd, provider.pieScale) : ''}'),
                  Text(
                      '${S.of(context).timeScale} : ${provider.pieScale == 0 ? S.of(context).day : provider.pieScale == 1 ? S.of(context).month : S.of(context).year}')
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    scrollable: true,
                    content: const LineChartSettingPage(
                      type: ChartType.pie,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            )
          ],
        ),
        SfCircularChart(
          key: Key('$r pie'),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <PieSeries<PieData, String>>[
            PieSeries<PieData, String>(
              strokeColor: Colors.black,
              strokeWidth: 1,
              explode: true,
              explodeIndex: 0,
              animationDuration: 600,
              dataSource: provider.pieDataList,
              xValueMapper: (PieData data, _) => data.xData,
              yValueMapper: (PieData data, _) => data.yData,
              dataLabelMapper: (PieData data, _) => data.text,
              pointColorMapper: (PieData data, _) => data.color,
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
        const SizedBox(height: 16),
         const AdBanner(large: false),
        if (provider.pieScale != 2)
          dayList(
            provider,
            start: provider.pieChartStart,
            end: provider.pieChartEnd,
            categoryFilter: provider.pieFilter,
            tagFilter: provider.pieTagFilter,
            scale: provider.pieScale,
            income: provider.pieCurrentIncome,
            expenditure: provider.pieCurrentExpenditure,
            allList: provider.pieAllList,
          )
        else
          yearList(
            provider,
            start: provider.pieChartStart,
            end: provider.pieChartEnd,
            categoryFilter: provider.pieFilter,
            tagFilter: provider.pieTagFilter,
            income: provider.pieCurrentIncome,
            expenditure: provider.pieCurrentExpenditure,
            allList: provider.pieAllList,
          )
      ],
    );
  }

  Widget stackColumn(MainProvider provider) {
    int r = DateTime.now().millisecondsSinceEpoch;
    if (provider.lineChartState == AppState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${Utils.dateStringByType(provider.stackChartStart, provider.stackScale)}${!provider.stackSamDay ? ' ~ ' : ''}${!provider.stackSamDay ? Utils.dateStringByType(provider.stackChartEnd, provider.stackScale) : ''}'),
                  Text(
                      '${S.of(context).timeScale} : ${provider.stackScale == 0 ? S.of(context).day : provider.stackScale == 1 ? S.of(context).month : S.of(context).year}')
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    scrollable: true,
                    content: const LineChartSettingPage(
                      type: ChartType.stack,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            )
          ],
        ),
        SfCartesianChart(
            key: Key('$r stack'),
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipSettings: const InteractiveTooltip(enable: true),
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
            ),
            series: provider.stackChartList),
        const SizedBox(height: 16),
         const AdBanner(large: false),
        if (provider.stackScale != 2)
          dayList(
            provider,
            start: provider.stackChartStart,
            end: provider.stackChartEnd,
            categoryFilter: provider.stackFilter,
            tagFilter: provider.stackTagFilter,
            scale: provider.stackScale,
            income: provider.stackCurrentIncome,
            expenditure: provider.stackCurrentExpenditure,
            allList: provider.stackAllList,
          )
        else
          yearList(
            provider,
            start: provider.stackChartStart,
            end: provider.stackChartEnd,
            categoryFilter: provider.stackFilter,
            tagFilter: provider.stackTagFilter,
            income: provider.stackCurrentIncome,
            expenditure: provider.stackCurrentExpenditure,
            allList: provider.stackAllList,
          )
      ],
    );
  }

  Widget dayList(
    MainProvider provider, {
    required DateTime start,
    required DateTime end,
    required List<int> categoryFilter,
    required List<int>? tagFilter,
    required int scale,
    required double income,
    required double expenditure,
    required List<AccountingModel> allList,
  }) {
    return Column(
      children: [
        const Divider(),
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
                      income.toString(),
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      expenditure.toString(),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      (income + expenditure).toString(),
                      style: TextStyle(
                        color: (income + expenditure) > 0 ? Colors.blueAccent : Colors.redAccent,
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
        const Divider(),
        Builder(
          builder: (context) {
            List<DateModel> list = [];
            for (DateTime i = start;
                i.year != end.year || i.month != end.month;
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
                year: end.year,
                month: end.month,
              ),
            );
            // List<AccountingModel> allList = [];
            //
            // if (provider.lineChartDataType == ChartDataType.category) {
            //   List<AccountingModel> list = [];
            //   for (var element in provider.accountingList) {
            //     if (provider.lineFilter.contains(element.category)) {
            //       if (element.category == -1) {
            //         if (element.amount > 0) {
            //           list.add(element);
            //         }
            //       } else {
            //         list.add(element);
            //       }
            //     }
            //   }
            //   allList.addAll(list);
            // } else {
            //   allList.addAll(provider.accountingList);
            // }
            //
            // if (provider.lineTagFilter != null) {
            //   List<AccountingModel> list = [];
            //   for (var element in allList) {
            //     if (element.tags.isEmpty) {
            //       if (provider.lineTagFilter!.contains(-1)) {
            //         list.add(element);
            //       }
            //     } else {
            //       bool done = false;
            //       for (var e in element.tags) {
            //         if (provider.lineTagFilter!.contains(e) && !done) {
            //           list.add(element);
            //           done = true;
            //         }
            //       }
            //     }
            //   }
            //   allList = list;
            // }
            //
            // allList.sort((a, b) => b.date.compareTo(b.date));
            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final List<AccountingModel> l = [];
                List<int> dList = [];
                for (var element in allList) {
                  if (scale == 0) {
                    if (start.year == end.year &&
                        start.month == end.month &&
                        start.day == end.day) {
                      if (element.date.year == start.year &&
                          element.date.month == start.month &&
                          element.date.day == start.day) {
                        if (element.date.year == list[index].year &&
                            element.date.month == list[index].month) {
                          l.add(element);

                          dList.add(element.date.day);
                        }
                      }
                    } else {
                      if (element.date.isAfter(start) &&
                          element.date.isBefore(end.add(const Duration(days: 1)))) {
                        if (element.date.year == list[index].year &&
                            element.date.month == list[index].month) {
                          l.add(element);

                          dList.add(element.date.day);
                        }
                      }
                    }
                  } else {
                    if (element.date.year == list[index].year &&
                        element.date.month == list[index].month) {
                      l.add(element);

                      dList.add(element.date.day);
                    }
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
    );
  }

  Widget yearList(
    MainProvider provider, {
    required DateTime start,
    required DateTime end,
    required List<int> categoryFilter,
    required List<int>? tagFilter,
    required double income,
    required double expenditure,
    required List<AccountingModel> allList,
  }) {
    return Column(
      children: [
        const Divider(),
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
                      income.toString(),
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      expenditure.toString(),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      (income + expenditure).toString(),
                      style: TextStyle(
                        color: (income + expenditure) > 0 ? Colors.blueAccent : Colors.redAccent,
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
        const Divider(),
        Builder(
          builder: (context) {
            List<DateModel> list = [];
            for (DateTime i = start; i.year != end.year; i = DateTime(i.year + 1, 1)) {
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
                year: end.year,
                month: 1,
              ),
            );
            // List<AccountingModel> allList = [];
            //
            // if (provider.lineChartDataType == ChartDataType.category) {
            //   List<AccountingModel> list = [];
            //   for (var element in provider.accountingList) {
            //     if (provider.lineFilter.contains(element.category)) {
            //       if (element.category == -1) {
            //         if (element.amount > 0) {
            //           list.add(element);
            //         }
            //       } else {
            //         list.add(element);
            //       }
            //     }
            //   }
            //   allList.addAll(list);
            // } else {
            //   allList.addAll(provider.accountingList);
            // }
            //
            // if (provider.lineTagFilter != null) {
            //   List<AccountingModel> list = [];
            //   for (var element in allList) {
            //     if (element.tags.isEmpty) {
            //       if (provider.lineTagFilter!.contains(-1)) {
            //         list.add(element);
            //       }
            //     } else {
            //       bool done = false;
            //       for (var e in element.tags) {
            //         if (provider.lineTagFilter!.contains(e) && !done) {
            //           list.add(element);
            //           done = true;
            //         }
            //       }
            //     }
            //   }
            //   allList = list;
            // }
            //
            // allList.sort((a, b) => b.date.compareTo(b.date));
            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final List<AccountingModel> l = [];
                List<int> dList = [];
                for (var element in allList) {
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
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final DateTime year;
  final double sales;
}

class PieData {
  PieData(
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

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
