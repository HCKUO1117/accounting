import 'dart:convert';
import 'dart:io';

import 'package:accounting/generated/l10n.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/category/category_screen.dart';
import 'package:accounting/screens/chart/chart_screen.dart';
import 'package:accounting/screens/dashboard/add_recode_page.dart';
import 'package:accounting/screens/dashboard/dashboard_screen.dart';
import 'package:accounting/screens/goal/add_fixed_income_page.dart';
import 'package:accounting/screens/goal/goal_screen.dart';
import 'package:accounting/screens/member/member_screen.dart';
import 'package:accounting/screens/widget/yes_no_dialog.dart';
import 'package:accounting/utils/firebase_remote_config.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Future<void>.microtask(() async {
      await _showAnnouncement();
      await _checkVersion();
      await _showUpdateInfo();
    });
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
          CategoryScreen(topPadding: MediaQuery.of(context).padding.top,),
          GoalScreen(topPadding: MediaQuery.of(context).padding.top,),
          const MemberScreen(),
        ],
      ),
      floatingActionButton: _bottomNavIndex == 0 || _bottomNavIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                final double padding = MediaQuery.of(context).padding.top;
                if(_bottomNavIndex == 0){
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
                }
                if(_bottomNavIndex == 3){
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
                      child: const AddFixedIncomePage(),
                    ),
                  );
                }
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
            Icons.more_outlined
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

  Future<void> _checkVersion() async {
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String nowVersion = packageInfo.version;
    final String newVersion =
    FirebaseRemoteConfig.instance.config!.getString('app_version');
    debugPrint('currentVersion : $nowVersion');
    debugPrint('newVersion : $newVersion');
    final List<String> nowVersions = nowVersion.split('.');
    final List<String> newVersions = newVersion.split('.');

    if (nowVersion.isNotEmpty && newVersion.isNotEmpty) {
      if (int.parse(newVersions[0]) > int.parse(nowVersions[0])) {
        _showUpdateDialog(packageInfo);
      } else {
        if (int.parse(newVersions[1]) > int.parse(nowVersions[1])) {
          _showUpdateDialog(packageInfo);
        } else {
          if (int.parse(newVersions[2]) > int.parse(nowVersions[2])) {
            _showUpdateDialog(packageInfo);
          }
        }
      }
    }
  }

  Future<void> _showUpdateInfo() async {
    final String previousVersion =
    Preferences.getString(Constants.previousVersion, '0');
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String nowVersion = packageInfo.version;
    debugPrint(previousVersion);
    if (previousVersion == '0') {
      Preferences.setString(Constants.previousVersion, nowVersion);
      return;
    }

    final String defaultLocale = Platform.localeName;
    String languageCode = 'en';
    if (defaultLocale.length > 1) {
      String first = defaultLocale.substring(0, 2);
      languageCode = first.toUpperCase() == 'ZH' ? 'zh':'en';
    }
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    final String info =
    FirebaseRemoteConfig.instance.config!.getString('update_info_$languageCode');
    if (nowVersion != previousVersion) {
      Preferences.setString(Constants.previousVersion, nowVersion);
      showDialog(
        context: context,
        builder: (context) => YesNoDialog(
          title: S.of(context).updateInfo,
          content: info,
          confirmText: S.of(context).ok,
        ),
      );
    }
  }

  void _showUpdateDialog(PackageInfo packageInfo) {
    String url = 'market://details?id=${packageInfo.packageName}';
    //const String iOSAppId = '';
    if (Platform.isAndroid) {
      url = 'market://details?id=${packageInfo.packageName}';
    } else if (Platform.isIOS || Platform.isMacOS) {
      //url = 'itms-apps://itunes.apple.com/tw/app/apple-store/$iOSAppId?mt=8';
    }
    showDialog(
      context: context,
      builder: (context) => YesNoDialog(
        title: S.of(context).update,
        content: S.of(context).newVersion,
        onTap: () {
          launchUrl(Uri.parse(url));
        },
        confirmText: S.of(context).update,
      ),
    );
  }

  Future<void> _showAnnouncement() async {
    final String defaultLocale = Platform.localeName;
    String languageCode = 'en';
    if (defaultLocale.length > 1) {
      String first = defaultLocale.substring(0, 2);
      languageCode = first.toUpperCase() == 'ZH' ? 'zh':'en';
    }
    String param = Constants.announcementText;
    param += languageCode;
    await FirebaseRemoteConfig.instance.fetchAndActivate();
    var announcement = FirebaseRemoteConfig.instance.config!.getString(param);
    if (announcement.isEmpty) {
      return;
    }
    bool show = json.decode(announcement)['show'];
    String title = json.decode(announcement)['title'];
    String content = json.decode(announcement)['content'];
    if (!show) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => YesNoDialog(
        title: title,
        content: content,
      ),
    );
  }
}
