import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/custom_date_picker_dialog.dart';
import 'package:accounting/screens/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
        builder: (BuildContext context, MainProvider provider, _) {
      return Scaffold(
        backgroundColor: Colors.orangeAccent.shade200.withOpacity(0.2),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: InkWell(
            onTap: () {
              CustomDatePickerDialog.show(
                context,
                onDateSelect: (arg) {
                  provider.setDashBoardDateRange(arg.value as PickerDateRange);
                },
                start: provider.dashBoardStartDate,
                end: provider.dashBoardEndDate,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_drop_down,color: Colors.transparent,),
                Text(
                    '${Utils.toDateString(provider.dashBoardStartDate)}${!provider.samDay ? ' ~ ' : ''}${!provider.samDay ? Utils.toDateString(provider.dashBoardEndDate) : ''}'),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, b) {
            return [
              SliverAppBar(
                elevation: 0,
                stretch: true,
                expandedHeight: MediaQuery.of(context).size.height / 3,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Center(
                    child: SfCircularChart(
                      legend: Legend(isVisible: false),
                      series: <PieSeries<_PieData, String>>[
                        PieSeries<_PieData, String>(
                          explode: true,
                          explodeIndex: 0,
                          dataSource: [
                            _PieData('支出', 15, '支出', Colors.redAccent),
                            _PieData('收入', 20, '收入', Colors.blueAccent),
                          ],
                          xValueMapper: (_PieData data, _) => data.xData,
                          yValueMapper: (_PieData data, _) => data.yData,
                          dataLabelMapper: (_PieData data, _) => data.text,
                          pointColorMapper: (_PieData data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            height: 1000,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      );
    });
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
