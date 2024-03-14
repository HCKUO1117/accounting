import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/res/icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

enum ChartType {
  line,
  pie,
  stack,
  list,
}

enum ChartDataType {
  inOut,
  category,
}

extension ChartDataTypeEx on ChartDataType {
  String text(BuildContext context) {
    switch (this) {
      case ChartDataType.inOut:
        return S.of(context).inOut;
      case ChartDataType.category:
        return S.of(context).category;
      // case ChartDataType.tag:
      //   return S.of(context).tag;
    }
  }
}

class LineChartSettingPage extends StatefulWidget {
  final ChartType type;

  const LineChartSettingPage({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<LineChartSettingPage> createState() => _LineChartSettingPageState();
}

class _LineChartSettingPageState extends State<LineChartSettingPage> {
  late DateTime? start;
  late DateTime? end;

  ChartDataType lineChartDataType = ChartDataType.inOut;

  int scale = 0;

  List<int> lineFilter = [];

  List<int>? tagFilter;

  @override
  void initState() {
    switch (widget.type) {
      case ChartType.line:
        start = context.read<MainProvider>().chartStart;
        end = context.read<MainProvider>().chartEnd;
        lineChartDataType = context.read<MainProvider>().lineChartDataType;
        scale = context.read<MainProvider>().chartScale;

        lineFilter.addAll(context.read<MainProvider>().lineFilter);
        if (context.read<MainProvider>().lineTagFilter != null) {
          tagFilter = [];
          tagFilter!.addAll(context.read<MainProvider>().lineTagFilter!);
        }
        break;
      case ChartType.pie:
        start = context.read<MainProvider>().chartStart;
        end = context.read<MainProvider>().chartEnd;
        lineChartDataType = context.read<MainProvider>().pieChartDataType;
        scale = context.read<MainProvider>().chartScale;

        lineFilter.addAll(context.read<MainProvider>().pieFilter);
        if (context.read<MainProvider>().pieTagFilter != null) {
          tagFilter = [];
          tagFilter!.addAll(context.read<MainProvider>().pieTagFilter!);
        }
        break;
      case ChartType.stack:
        start = context.read<MainProvider>().chartStart;
        end = context.read<MainProvider>().chartEnd;
        lineChartDataType = context.read<MainProvider>().stackChartDataType;
        scale = context.read<MainProvider>().chartScale;

        lineFilter.addAll(context.read<MainProvider>().stackFilter);
        if (context.read<MainProvider>().stackTagFilter != null) {
          tagFilter = [];
          tagFilter!.addAll(context.read<MainProvider>().stackTagFilter!);
        }
        break;
      case ChartType.list:
        start = context.read<MainProvider>().chartStart;
        end = context.read<MainProvider>().chartEnd;
        scale = context.read<MainProvider>().chartScale;

        if (context.read<MainProvider>().listTagFilter != null) {
          tagFilter = [];
          tagFilter!.addAll(context.read<MainProvider>().listTagFilter!);
        }
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider provider, _) {
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

          ///data source
          if (widget.type != ChartType.list)
            cardBackground([
              Row(
                children: [
                  Text(
                    '${S.of(context).dataType} : ',
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.type == ChartType.stack)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        ChartDataType.inOut.text(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        child: DropdownButton<ChartDataType>(
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: lineChartDataType,
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            for (final element in ChartDataType.values)
                              DropdownMenuItem<ChartDataType>(
                                value: element,
                                alignment: AlignmentDirectional.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        element.text(context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (v) {
                            setState(() {
                              if (v != lineChartDataType) {
                                lineFilter = [];
                                switch (v!) {
                                  case ChartDataType.inOut:
                                    lineFilter = [0, 1];
                                    break;
                                  case ChartDataType.category:
                                    for (var element in provider.categoryList) {
                                      lineFilter.add(element.id!);
                                    }
                                    lineFilter.add(-1);
                                    break;
                                  // case ChartDataType.tag:
                                  //   for (var element in provider.tagList) {
                                  //     lineFilter.add(element.id!);
                                  //   }
                                  //   lineFilter.add(-1);
                                  //   break;
                                }
                              }
                              lineChartDataType = v!;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 16),
              filter(provider),
            ]),

          const SizedBox(height: 8),
          cardBackground([
            Row(
              children: [
                Text(
                  '${S.of(context).filter} : ',
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 4,
                children: [
                  for (final element in provider.tagList)
                    ChoiceChip(
                        selected: tagFilter?.contains(element.id) ?? true,
                        selectedColor: element.color,
                        side: BorderSide(color: element.color),
                        backgroundColor: element.color.withOpacity(0.2),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              element.name,
                              style: const TextStyle(
                                color: Colors.white,
                                shadows: [Shadow(blurRadius: 4)],
                              ),
                            ),
                          ],
                        ),
                        onSelected: (v) {
                          setTagFilter(element.id!);
                        }),
                  ChoiceChip(
                      selected: tagFilter?.contains(-1) ?? true,
                      selectedColor: Colors.black54,
                      side: BorderSide(
                          color: tagFilter?.contains(-1) ?? true
                              ? Colors.transparent
                              : Colors.black54),
                      backgroundColor: Colors.black12,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).noTag,
                            style: const TextStyle(
                                color: Colors.white, shadows: [Shadow(blurRadius: 4)]),
                          )
                        ],
                      ),
                      onSelected: (v) {
                        setTagFilter(-1);
                      }),
                ],
              ),
            )
          ]),
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

              switch (widget.type) {
                case ChartType.line:
                  await provider.setLineChartTime(
                    start: start ?? DateTime.now(),
                    end: end ?? DateTime.now(),
                    type: lineChartDataType,
                    scale: scale,
                    filter: lineFilter,
                    tagFilter: tagFilter,
                  );
                  if (!context.mounted) return;
                  provider.drawLineChart(context);
                  break;
                case ChartType.pie:
                  await provider.setPieChartTime(
                    start: start ?? DateTime.now(),
                    end: end ?? DateTime.now(),
                    type: lineChartDataType,
                    scale: scale,
                    filter: lineFilter,
                    tagFilter: tagFilter,
                  );
                  if (!context.mounted) return;
                  provider.drawPieChart(context);
                  break;
                case ChartType.stack:
                  await provider.setStackChartTime(
                    start: start ?? DateTime.now(),
                    end: end ?? DateTime.now(),
                    type: lineChartDataType,
                    scale: scale,
                    filter: lineFilter,
                    tagFilter: tagFilter,
                  );
                  if (!context.mounted) return;
                  provider.drawStackChart(context);
                  break;
                case ChartType.list:
                  await provider.setListChartTime(
                    start: start ?? DateTime.now(),
                    end: end ?? DateTime.now(),
                    scale: scale,
                    tagFilter: tagFilter,
                  );
                  if (!context.mounted) return;
                  provider.drawListChart(context);
                  break;
              }

              Navigator.pop(context);
            },
            child: Text(
              S.of(context).ok,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    });
  }

  Widget filter(MainProvider provider) {
    switch (lineChartDataType) {
      case ChartDataType.inOut:
        return SizedBox(
          width: double.maxFinite,
          child: Wrap(
            spacing: 4,
            children: [
              ChoiceChip(
                  selected: lineFilter.contains(0),
                  selectedColor: Colors.blueAccent,
                  side: BorderSide(
                      color: lineFilter.contains(0) ? Colors.transparent : Colors.blueAccent),
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).income,
                        style: const TextStyle(color: Colors.white, shadows: [
                          Shadow(blurRadius: 4),
                        ]),
                      ),
                    ],
                  ),
                  onSelected: (v) {
                    setState(() {
                      if (lineFilter.contains(0)) {
                        lineFilter.removeWhere((element) => element == 0);
                      } else {
                        lineFilter.add(0);
                      }
                    });
                  }),
              ChoiceChip(
                  selected: lineFilter.contains(1),
                  selectedColor: Colors.redAccent,
                  side: BorderSide(
                      color: lineFilter.contains(1) ? Colors.transparent : Colors.redAccent),
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.of(context).expenditure,
                        style: const TextStyle(color: Colors.white, shadows: [
                          Shadow(blurRadius: 4),
                        ]),
                      )
                    ],
                  ),
                  onSelected: (v) {
                    setState(() {
                      if (lineFilter.contains(1)) {
                        lineFilter.removeWhere((element) => element == 1);
                      } else {
                        lineFilter.add(1);
                      }
                    });
                  }),
            ],
          ),
        );
      case ChartDataType.category:
        return Column(
          children: [
            Text(
              S.of(context).income,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 4,
                children: [
                  for (final element in provider.categoryIncomeList)
                    ChoiceChip(
                        selected: lineFilter.contains(element.id),
                        selectedColor: element.iconColor,
                        side: BorderSide(color: element.iconColor),
                        backgroundColor: element.iconColor.withOpacity(0.2),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[element.icon],
                              color: Colors.white,
                              shadows: const [
                                Shadow(blurRadius: 4),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              element.name,
                              style: const TextStyle(color: Colors.white, shadows: [
                                Shadow(blurRadius: 4),
                              ]),
                            )
                          ],
                        ),
                        onSelected: (v) {
                          setState(() {
                            if (lineFilter.contains(element.id)) {
                              lineFilter.removeWhere((e) => e == element.id);
                            } else {
                              lineFilter.add(element.id!);
                            }
                          });
                        }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).expenditure,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 4,
                children: [
                  for (final element in provider.categoryExpenditureList)
                    ChoiceChip(
                        selected: lineFilter.contains(element.id),
                        selectedColor: element.iconColor,
                        side: BorderSide(color: element.iconColor),
                        backgroundColor: element.iconColor.withOpacity(0.2),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[element.icon],
                              color: Colors.white,
                              shadows: const [
                                Shadow(blurRadius: 4),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              element.name,
                              style: const TextStyle(color: Colors.white, shadows: [
                                Shadow(blurRadius: 4),
                              ]),
                            )
                          ],
                        ),
                        onSelected: (v) {
                          setState(() {
                            if (lineFilter.contains(element.id)) {
                              lineFilter.removeWhere((e) => e == element.id);
                            } else {
                              lineFilter.add(element.id!);
                            }
                          });
                        }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).unCategory,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite,
              child: Wrap(
                spacing: 4,
                children: [
                  ChoiceChip(
                      selected: lineFilter.contains(-1),
                      selectedColor: Colors.black54,
                      side: BorderSide(
                          color: lineFilter.contains(-1) ? Colors.transparent : Colors.black54),
                      backgroundColor: Colors.black12,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            S.of(context).unCategory,
                            style: const TextStyle(color: Colors.white, shadows: [
                              Shadow(blurRadius: 4),
                            ]),
                          )
                        ],
                      ),
                      onSelected: (v) {
                        setState(() {
                          if (lineFilter.contains(-1)) {
                            lineFilter.removeWhere((e) => e == -1);
                          } else {
                            lineFilter.add(-1);
                          }
                        });
                      }),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      // case ChartDataType.tag:
      //   return const SizedBox();
    }
  }

  void setTagFilter(int id) {
    if (tagFilter == null) {
      tagFilter = [];
      if (id != 0) {
        for (var element in context.read<MainProvider>().tagList) {
          if (element.id != id) {
            tagFilter!.add(element.id!);
          }
        }
        if (id != -1) {
          tagFilter!.add(-1);
        }
      }
    } else {
      if (id != 0) {
        if (tagFilter!.contains(id)) {
          tagFilter!.removeWhere((element) => element == id);
        } else {
          tagFilter!.add(id);
        }
      } else {
        tagFilter = null;
      }
    }
    setState(() {});
  }

  Widget cardBackground(List<Widget> child) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.backgroundColorLight, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: child,
      ),
    );
  }
}
