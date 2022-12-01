import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/home_widget_provider.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/goal/add_fixed_income_page.dart';
import 'package:accounting/screens/goal/add_goal_page.dart';
import 'package:accounting/screens/widget/fixed_income_title.dart';
import 'package:accounting/utils/my_banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatefulWidget {
  final double topPadding;

  const GoalScreen({
    Key? key,
    required this.topPadding,
  }) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> with TickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  bool expand = true;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
    context.read<MainProvider>().getFixedIncomeList();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (!expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              S.of(context).inAndOut,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),
            ),
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      expand = !expand;
                      _runExpandCheck();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.backgroundColor,
                    child: Row(
                      children: [
                        Text(
                          S.of(context).budget,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'RobotoMono', color: Colors.orange),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FadeTransition(
                            opacity: Tween(begin: 1.0, end: 0.0).animate(expandController),
                            child: Text(
                              provider.goalNum == -1 ? '' : provider.goalNum.toString(),
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: -0.5).animate(expandController),
                          child: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.orange,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizeTransition(
                  axisAlignment: 1.0,
                  sizeFactor: animation,
                  child: Container(
                    color: AppColors.backgroundColor,
                    width: double.maxFinite,
                    child: provider.goalNum == -1
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(S.of(context).noBudget),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    useRootNavigator: false,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20)),
                                      scrollable: true,
                                      content: const AddGoalPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  S.of(context).clickSetBudget,
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : Column(
                            children: [
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    S.of(context).eachMonth,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'RobotoMono',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    provider.goalNum.toString(),
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              Row(
                                children: [
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        useRootNavigator: false,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                          scrollable: true,
                                          content: const AddGoalPage(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(S.of(context).notify),
                                          content: Text(S.of(context).deleteCheck),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                S.of(context).cancel,
                                                style: const TextStyle(color: Colors.black54),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                provider.setGoal(-1);
                                                context.read<HomeWidgetProvider>().sendAndUpdate();
                                                Navigator.pop(context, true);
                                              },
                                              child: Text(S.of(context).ok),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
                const AdBanner(large: false),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).fixedIncome,
                        style: const TextStyle(fontSize: 20, fontFamily: 'RobotoMono'),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              scrollable: true,
                              content: Text(S.of(context).fixedInfo),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(S.of(context).ok),
                                )
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.help_outline),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: provider.fixedIncomeList.isEmpty
                      ? Center(
                          child: Text(
                            S.of(context).noRecord,
                            style: const TextStyle(color: Colors.orange),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (index == provider.fixedIncomeList.length) {
                              return const SizedBox(height: 50);
                            }

                            return FixedIncomeTitle(
                              model: provider.fixedIncomeList[index],
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
                                    child: AddFixedIncomePage(
                                      model: provider.fixedIncomeList[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 4);
                          },
                          itemCount: provider.fixedIncomeList.length + 1,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
