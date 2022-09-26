import 'package:accounting/screens/category/category_screen.dart';
import 'package:accounting/screens/chart/chart_screen.dart';
import 'package:accounting/screens/dashboard/add_recode_page.dart';
import 'package:accounting/screens/dashboard/dashboard_screen.dart';
import 'package:accounting/screens/goal/goal_screen.dart';
import 'package:accounting/screens/member/member_screen.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _bottomNavIndex = 0;

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          DashBoardScreen(
            topPadding: MediaQuery.of(context).padding.top,
          ),
          const ChartScreen(),
          const CategoryScreen(),
          const GoalScreen(),
          const MemberScreen(),
        ],
      ),
      floatingActionButton: _bottomNavIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                final double padding = MediaQuery.of(context).padding.top;
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
                    padding: EdgeInsets.only(top: padding),
                    child: const AddRecodePage(),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Container(
        color: _bottomNavIndex == 2
            ? Colors.orangeAccent.shade200.withOpacity(0.2)
            : Colors.white,
        child: AnimatedBottomNavigationBar(
          elevation: 10,
          icons: const [
            Icons.dashboard_outlined,
            Icons.pie_chart_outline_outlined,
            Icons.label_outline,
            Icons.account_balance_wallet_outlined,
            Icons.settings_outlined
          ],
          // gapWidth: _bottomNavIndex == 0 ? null : 0,
          activeColor: Colors.orange,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.end,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 0,
          onTap: (index) {
            setState(() => _bottomNavIndex = index);
            _tabController!.animateTo(index);
          },
          //other params
        ),
      ),
    );
  }
}
