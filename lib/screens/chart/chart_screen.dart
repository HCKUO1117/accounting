import 'package:accounting/provider/main_provider.dart';
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
    SalesData(DateTime(2010, 1, 1), 35),
    SalesData(DateTime(2010, 1, 2), 28),
    SalesData(DateTime(2010, 1, 4), 34),
    SalesData(DateTime(2010, 1, 5), 32),
    SalesData(DateTime(2010, 1, 6), 40)
  ];

  final List<SalesData> chartData1 = [
    SalesData(DateTime(2010, 1, 1), 20),
    SalesData(DateTime(2010, 1, 2), 60),
    SalesData(DateTime(2010, 1, 4), 40),
    SalesData(DateTime(2010, 1, 5), 45),
    SalesData(DateTime(2010, 1, 6), 60)
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
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.compare_arrows),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.restart_alt),
              ),
            ],
            bottom: TabBar(controller: _tabController, tabs: const [
              Tab(icon: Icon(Icons.show_chart)),
              Tab(icon: Icon(Icons.pie_chart_outline_outlined)),
              Tab(icon: Icon(Icons.stacked_bar_chart))
            ]),
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
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipSettings: const InteractiveTooltip(enable: true, color: Colors.red),
          tooltipDisplayMode: TrackballDisplayMode.floatAllPoints),
      series: <ChartSeries>[
        LineSeries<SalesData, DateTime>(
          dataSource: chartData,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
        ),
        LineSeries<SalesData, DateTime>(
          dataSource: chartData1,
          xValueMapper: (SalesData sales, _) => sales.year,
          yValueMapper: (SalesData sales, _) => sales.sales,
        ),
      ],
    );
  }

  Widget pie(MainProvider provider) {
    return SizedBox();
  }

  Widget stackColumn(MainProvider provider) {
    return SizedBox();
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final DateTime year;
  final double sales;
}
