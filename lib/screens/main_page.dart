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
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: _tabController, children: const [
        DashBoardScreen(),
        ChartScreen(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        elevation: 5,
        icons: const [
          Icons.dashboard_outlined,
          Icons.pie_chart_outline_outlined,
          Icons.bookmarks_outlined,
          Icons.price_change_outlined,
          Icons.person_outline
        ],
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
    );
  }
}
