import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = MainProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: mainProvider),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: ScrollConfiguration(
            behavior: NoGlow(),
            child: const MainPage(),
          )),
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
