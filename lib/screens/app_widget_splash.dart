import 'package:accounting/app.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AppWidgetSplash extends StatefulWidget {
  const AppWidgetSplash({Key? key}) : super(key: key);

  @override
  State<AppWidgetSplash> createState() => _AppWidgetSplashState();
}

class _AppWidgetSplashState extends State<AppWidgetSplash> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<String> images = Constants.appWidgetsEN;

    switch(App.of(context)?.locale?.languageCode){
      case 'en':
        images = Constants.appWidgetsEN;
        break;
      case 'zh':
        images = Constants.appWidgetsTW;
        break;
      case 'ko':
        images = Constants.appWidgetsKO;
        break;
      case 'ja':
        images = Constants.appWidgetsJA;
        break;
      case 'ru':
        images = Constants.appWidgetsRU;
        break;
      case 'hi':
        images = Constants.appWidgetsHI;
        break;
      case 'vi':
        images = Constants.appWidgetsVI;
        break;
      case 'th':
        images = Constants.appWidgetsTH;
        break;
      case 'es':
        images = Constants.appWidgetsES;
        break;
    }


    return SafeArea(
      child: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              for (var element in images)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        element,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                )
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentPage != 2)
                  SmoothPageIndicator(
                    controller: pageController, // PageController
                    count: images.length,
                    effect: const WormEffect(
                        dotColor: Colors.white,
                        activeDotColor: Colors.orangeAccent), // your preferred effect
                    onDotClicked: (index) {},
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      S.of(context).understand,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
