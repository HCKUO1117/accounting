import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/custom_date_picker_dialog.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChartTimeSettingPage extends StatefulWidget {
  const ChartTimeSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChartTimeSettingPage> createState() => _ChartTimeSettingPageState();
}

class _ChartTimeSettingPageState extends State<ChartTimeSettingPage> {
  late DateTime? start;
  late DateTime? end;

  int scale = 0;

  @override
  void initState() {
    start = context.read<MainProvider>().chartStart;
    end = context.read<MainProvider>().chartEnd;
    scale = context.read<MainProvider>().chartScale;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool samDay = false;
    if (start != null && end != null) {
      samDay = start!.year == end!.year && start!.month == end!.month && start!.day == end!.day;
    }

    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Column(
          children: [
            Text(
              S.of(context).setting,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 16),

            ///scale
            cardBackground([
              Text(
                '${S.of(context).timeScale} : ',
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: DropdownButton<int>(
                  underline: const SizedBox(),
                  isExpanded: true,
                  value: scale,
                  items: [
                    DropdownMenuItem<int>(
                      value: 0,
                      alignment: AlignmentDirectional.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.of(context).day)],
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 1,
                      alignment: AlignmentDirectional.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.of(context).month)],
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      alignment: AlignmentDirectional.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(S.of(context).year)],
                      ),
                    ),
                  ],
                  onChanged: (v) {
                    setState(() {
                      if (v != scale) {
                        start = null;
                        end = null;
                      }
                      scale = v!;
                    });
                  },
                ),
              ),
            ]),
            const SizedBox(height: 8),

            ///time
            cardBackground([
              Text(
                '${S.of(context).time} : ',
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
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
                    start: start ?? DateTime.now(),
                    end: end ?? DateTime.now(),
                    showDot: false,
                    allowViewNavigation: scale == 0,
                    view: scale == 0
                        ? DateRangePickerView.month
                        : scale == 1
                            ? DateRangePickerView.year
                            : DateRangePickerView.decade,
                    noInit: start == null || end == null ? true : false,
                  );
                  if (range == null) {
                    return;
                  }
                  setState(() {
                    start = range!.start;
                    end = range!.end;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          start != null && end != null
                              ? '${Utils.dateStringByType(start!, scale)}${!samDay ? ' ~ ' : ''}${!samDay ? Utils.dateStringByType(end!, scale) : ''}'
                              : S.of(context).plzChooseTime,
                          textAlign: TextAlign.center,
                          strutStyle: const StrutStyle(height: 1.5),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 8),

            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () async {
                if (start == null || end == null) {
                  Fluttertoast.showToast(msg: S.of(context).plzChooseTime);
                  return;
                }
                await provider.setChartTime(
                  start: start ?? DateTime.now(),
                  end: end ?? DateTime.now(),
                  scale: scale,
                );
                if (!context.mounted) return;
                provider.drawLineChart(context);
                provider.drawPieChart(context);
                provider.drawStackChart(context);
                provider.drawListChart(context);

                Navigator.pop(context);
              },
              child: Text(
                S.of(context).ok,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget cardBackground(List<Widget> child) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.backgroundColorLight, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: child,
      ),
    );
  }
}
