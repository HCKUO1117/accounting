import 'dart:io';

import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/main_page.dart';
import 'package:accounting/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  Locale? _locale;

  final String defaultLocale = Platform.localeName;

  final List<Locale>? systemLocales = WidgetsBinding.instance.window.locales;

  Future<void> setLocale(Locale value) async {
    setState(() {
      _locale = value;
    });
    await Preferences.setString('languageCode', value.languageCode);
    await Preferences.setString('countryCode', value.countryCode ?? '');
  }

  @override
  void initState() {
    Future<void>.microtask(() async {
      await Preferences.init();
      String languageCode = Preferences.getString('languageCode', '');
      String countryCode = Preferences.getString('countryCode', '');
      setState(() {
        if (languageCode.isNotEmpty) {
          _locale = Locale(languageCode, countryCode);
        } else {
          if (defaultLocale.length > 1) {
            String first = defaultLocale.substring(0, 2);
            String last = defaultLocale.substring(
                defaultLocale.length - 2, defaultLocale.length);
            _locale = Locale(first, last == 'TW' ? 'TW' : '');
            Preferences.setString('languageCode', first);
            if (last == 'TW') {
              Preferences.setString('countryCode', last);
            }
          }
          // if (defaultLocale == 'zh_Hant_TW') {
          //   _locale = const Locale('zh','TW');
          //   Preferences.setString('languageCode', 'zh');
          //   Preferences.setString('countryCode', 'TW');
          // }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = MainProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mainProvider),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
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
        locale: _locale ?? const Locale('en', ''),
      ),
    );
  }
}

class NoGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
