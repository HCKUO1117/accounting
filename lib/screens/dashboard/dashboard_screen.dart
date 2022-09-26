import 'dart:math';

import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/custom_date_picker_dialog.dart';
import 'package:accounting/screens/dashboard/add_recode_page.dart';
import 'package:accounting/screens/widget/accounting_title.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.backgroundColor,
            centerTitle: true,
            title: InkWell(
              onTap: () {
                CustomDatePickerDialog.show(
                  context,
                  onDateSelect: (arg) {
                    provider
                        .setDashBoardDateRange(arg.value as PickerDateRange);
                  },
                  start: provider.dashBoardStartDate,
                  end: provider.dashBoardEndDate,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.transparent,
                  ),
                  Text(
                      '${Utils.toDateString(provider.dashBoardStartDate)}${!provider.samDay ? ' ~ ' : ''}${!provider.samDay ? Utils.toDateString(provider.dashBoardEndDate) : ''}'),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DashBoardSliverPersistentHeaderDelegate(
                  maxEx: MediaQuery.of(context).size.height / 3 + 50,
                  minEx: 90,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ColoredBox(
                    color: AppColors.backgroundColor,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height / 3 * 2 + 50,
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
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.accountingList.length,
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
                                      padding: EdgeInsets.only(
                                          top: widget.topPadding),
                                      child: AddRecodePage(
                                        model: provider.accountingList[index],
                                      ),
                                    ),
                                  );
                                },
                                model: provider.accountingList[index],
                              );
                            }),
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

class DashBoardSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double maxEx;
  final double minEx;

  DashBoardSliverPersistentHeaderDelegate({
    required this.maxEx,
    required this.minEx,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));
    return Container(
      color: Colors.white,
      child: Container(
        color: AppColors.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                  width: 200,
                  child: const Text(
                    '\$ 5329.05',
                    style: TextStyle(
                      fontFamily: 'Barlow',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (shrinkPercentage != 1)
                    Opacity(
                      opacity: 1 - shrinkPercentage,
                      child: Center(
                        child: SfCircularChart(
                          legend: Legend(isVisible: false),
                          series: <PieSeries<_PieData, String>>[
                            PieSeries<_PieData, String>(
                              explode: true,
                              explodeIndex: 0,
                              dataSource: [
                                _PieData(
                                  S.of(context).expenditure,
                                  15,
                                  S.of(context).expenditure,
                                  Colors.redAccent,
                                ),
                                _PieData(
                                  S.of(context).income,
                                  20,
                                  S.of(context).income,
                                  Colors.blueAccent,
                                ),
                              ],
                              xValueMapper: (_PieData data, _) => data.xData,
                              yValueMapper: (_PieData data, _) => data.yData,
                              dataLabelMapper: (_PieData data, _) => data.text,
                              pointColorMapper: (_PieData data, _) =>
                                  data.color,
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
                                Text('${S.of(context).income} : '),
                                const Text(
                                  '1000',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('${S.of(context).expenditure} : '),
                                const Text(
                                  '800',
                                  style: TextStyle(color: Colors.redAccent),
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
  }

  @override
  double get maxExtent => maxEx;

  @override
  double get minExtent => minEx;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) =>
      true; // 如果内容需要更新，设置为true
}
