import 'dart:async';
import 'dart:io';

import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/tag_db.dart';
import 'package:accounting/provider/home_widget_provider.dart';
import 'package:accounting/provider/iap.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/main_page.dart';
import 'package:accounting/utils/app_open_ad_manager.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static _AppState? of(BuildContext context) => context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  MainProvider mainProvider = MainProvider();
  IAP iap = IAP();
  HomeWidgetProvider homeWidgetProvider = HomeWidgetProvider();

  Locale? locale;

  final String defaultLocale = Platform.localeName;

  final List<Locale>? systemLocales = WidgetsBinding.instance.window.locales;

  // Future<void> setLocale(Locale value) async {
  //   setState(() {
  //     locale = value;
  //   });
  //   await Preferences.setString('languageCode', value.languageCode);
  //   await Preferences.setString('countryCode', value.countryCode ?? '');
  // }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    Future<void>.microtask(() async {
      AppOpenAdManager appOpenAdManager = AppOpenAdManager();
      appOpenAdManager.loadAd();
      _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      _appLifecycleReactor.listenToAppStateChanges(context, iap);
      await Preferences.init();
      await CategoryDB.initDataBase();
      await AccountingDB.initDataBase();
      await TagDB.initDataBase();
      if (defaultLocale.length > 1) {
        String first = defaultLocale.substring(0, 2);
        String last = defaultLocale.substring(defaultLocale.length - 2, defaultLocale.length);
        setState(() {
          locale = Locale(first, last == 'TW' ? 'TW' : '');
        });
        // Preferences.setString('languageCode', first);
        // if (last == 'TW') {
        //   Preferences.setString('countryCode', last);
        // }
      }
      // String languageCode = Preferences.getString('languageCode', '');
      // String countryCode = Preferences.getString('countryCode', '');
      // setState(() {
      //   if (languageCode.isNotEmpty) {
      //     locale = Locale(languageCode, countryCode);
      //   } else {
      //     if (defaultLocale.length > 1) {
      //       String first = defaultLocale.substring(0, 2);
      //       String last = defaultLocale.substring(defaultLocale.length - 2, defaultLocale.length);
      //       locale = Locale(first, last == 'TW' ? 'TW' : '');
      //       Preferences.setString('languageCode', first);
      //       if (last == 'TW') {
      //         Preferences.setString('countryCode', last);
      //       }
      //     }
      //   }
      // });
      await mainProvider.setDefaultDB();
      await mainProvider.getCategoryList();
      await mainProvider.getFixedIncomeList();
      mainProvider.checkInsertData();
      await iap.initIAP();
      iap.periodCheckSubscription();
      await HomeWidget.registerBackgroundCallback(backgroundCallback);
      homeWidgetProvider.startBackgroundUpdate();
      homeWidgetProvider.sendAndUpdate();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mainProvider),
        ChangeNotifierProvider.value(value: iap),
        ChangeNotifierProvider.value(value: homeWidgetProvider),
      ],
      child: MaterialApp(
        title: '',
        navigatorKey: App.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.orange,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
            )),
        home: ScrollConfiguration(
          behavior: NoGlow(),
          child: const MainPage(),
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('zh', 'TW'),
        ],
        locale: locale ?? const Locale('en', ''),
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}

class NoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
