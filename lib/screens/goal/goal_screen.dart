import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/goal/add_goal_page.dart';
import 'package:accounting/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

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
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider provider, _) {
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
          child: SingleChildScrollView(
            child: Column(
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
                          S.of(context).goal,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'RobotoMono', color: Colors.orange),
                        ),
                        const Spacer(),
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
                    child: provider.goalType == -1
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(S.of(context).noTarget),
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
                                  S.of(context).clickSetTarget,
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : Column(
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  const SizedBox(width: 16),
                                  if (provider.goalType == 0)
                                    Text(
                                      S.of(context).eachMonth,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'RobotoMono',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (provider.goalType == 1)
                                    Text(
                                      '${Utils.toDateString(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            provider.goalStartTimeStamp),
                                      )} ~ ${Utils.toDateString(
                                        DateTime.fromMillisecondsSinceEpoch(provider.goalTimeStamp),
                                      )}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 16),
                                  Text(
                                    '${S.of(context).save1} : ',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'RobotoMono',
                                    ),
                                  ),
                                  Text(
                                    provider.goalNum.toString(),
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
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
                                                provider.setGoal(
                                                  -1,
                                                  0,
                                                  date: null,
                                                  start: null,
                                                );
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
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
