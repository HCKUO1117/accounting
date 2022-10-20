import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/models/date_model.dart';
import 'package:accounting/models/states.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/chart/line_chart_setting_page.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    super.initState();
  }

  final List<SalesData> chartData = [
    SalesData(DateTime(2010, 1), 35),
    SalesData(DateTime(2010, 2), 28),
    SalesData(DateTime(2010, 3), 34),
    SalesData(DateTime(2010, 4), 32),
    SalesData(DateTime(2010, 5), 40)
  ];

  final List<SalesData> chartData1 = [
    SalesData(DateTime(2010, 1, 1), 20),
    SalesData(DateTime(2010, 1, 2), 60),
    SalesData(DateTime(2010, 1, 4), 40),
    SalesData(DateTime(2010, 1, 5), 45),
    SalesData(DateTime(2010, 1, 6), -60)
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
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
    print(13);
    int r = DateTime.now().millisecondsSinceEpoch;
    if (provider.lineChartState == AppState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print(provider.lineChartList);
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        scrollable: true,
                        content: const LineChartSettingPage(),
                      ),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            )
          ],
        ),
        SfCartesianChart(
          key: Key('$r line'),
          primaryXAxis: DateTimeAxis(),
          legend: Legend(isVisible: true, position: LegendPosition.bottom),
          zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
          trackballBehavior: TrackballBehavior(
            enable: true,
            tooltipSettings: const InteractiveTooltip(enable: true, color: Colors.red),
            tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
          ),
          series: provider.lineChartList,
        )
      ],
    );
  }

  Widget pie(MainProvider provider) {
    return SizedBox();
  }

  Widget stackColumn(MainProvider provider) {
    return SizedBox();
  }

  Widget dayList(MainProvider provider, {
    required DateTime start,
    required DateTime end,
    required List<int> categoryFilter,
    required List<int> tagFilter,
  }) {
    return SizedBox();
  }

  Widget monthList(MainProvider provider, {
    required DateTime start,
    required DateTime end,
    required List<int> categoryFilter,
    required List<int> tagFilter,
  }) {
    List<DateModel> list = [];

    for (DateTime i = provider.lineChartStart;
    i.year != provider.lineChartEnd.year;
    i = DateTime(i.year + 1, 1)) {
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
        year: provider.lineChartEnd.year,
        month: 1,
      ),
    );
    return SizedBox();
  }

  Widget yearList(MainProvider provider, {
    required DateTime start,
    required DateTime end,
    required List<int> categoryFilter,
    required List<int> tagFilter,
  }) {
    return SizedBox();
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final DateTime year;
  final double sales;
}
