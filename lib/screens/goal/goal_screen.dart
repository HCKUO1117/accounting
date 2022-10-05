import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/goal/add_goal_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
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
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, b) {
              return [
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  stretch: true,
                  expandedHeight: 200,
                  backgroundColor: AppColors.backgroundColor,
                  title: Text(
                    S.of(context).goal,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    background: provider.goalType == -1
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
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      provider.setGoal(
                                        -1,
                                        0,
                                        date: null,
                                        start: null,
                                      );
                                    },
                                    icon: const Icon(Icons.delete_outline_outlined),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(S.of(context).eachMonth),
                                ],
                              )
                            ],
                          ),
                  ),
                ),
              ];
            },
            body: Container(),
          ),
        ),
      );
    });
  }
}
