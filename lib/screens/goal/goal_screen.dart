import 'package:accounting/generated/l10n.dart';
import 'package:accounting/res/app_color.dart';
import 'package:flutter/material.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                expandedHeight: MediaQuery.of(context).size.height / 3,
                backgroundColor: AppColors.backgroundColor,
                title: Text(S.of(context).goal),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: Container(),
                ),
              ),
            ];
          },
          body: Container(),
        ),
      ),
    );
  }
}
