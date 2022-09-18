import 'package:accounting/screens/category/category_screen.dart';
import 'package:accounting/screens/chart/chart_screen.dart';
import 'package:accounting/screens/dashboard/dashboard_screen.dart';
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
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          DashBoardScreen(),
          ChartScreen(),
          CategoryScreen(),
        ],
      ),
      floatingActionButton: _bottomNavIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
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
            Icons.person_outline
          ],
          gapWidth: _bottomNavIndex == 0 ? null : 0,
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
