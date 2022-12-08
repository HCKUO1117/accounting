import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/iap.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/app_widget_splash.dart';
import 'package:accounting/screens/member/export_excel_page.dart';
import 'package:accounting/screens/member/feedback_page.dart';
import 'package:accounting/screens/member/google_drive_page.dart';
import 'package:accounting/screens/member/notification_page.dart';
import 'package:accounting/screens/member/remove_ad_page.dart';
import 'package:accounting/screens/widget/yes_no_dialog.dart';
import 'package:accounting/utils/my_banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  String version = '';

  @override
  void initState() {
    loadAd();
    Future.microtask(() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        version = 'v${packageInfo.version}';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            title: Text(
              S.of(context).more,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
          body: ListView(
            children: [
              settingTitle(
                title: S.of(context).backup,
                icon: Icons.backup_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleDrivePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              settingTitle(
                title: S.of(context).notification,
                icon: Icons.notifications_none_sharp,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              settingTitle(
                title: S.of(context).exportExcel,
                icon: Icons.description_outlined,
                onTap: () async {
                  var iap = context.read<IAP>();
                  if (iap.isSubscription != true) {
                    if (interstitialAd != null) {
                      await interstitialAd!.show();
                    }
                    loadAd();
                  }

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      scrollable: true,
                      content: const ExportExcelPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              settingTitle(
                title: S.of(context).feedback,
                icon: Icons.chat_outlined,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedBackPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              settingTitle(
                title: S.of(context).widgets,
                icon: Icons.widgets_outlined,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => YesNoDialog(
                      content: S.of(context).appWidgetShow,
                      otherContents: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Image.asset(
                          'assets/images/accounting_app_widget.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showAppWidgetTutorial2();
                      },
                      confirmText: S.of(context).showMeNow,
                    ),
                  );
                },
              ),
              const Divider(),
              settingTitle(
                title: S.of(context).removeAd,
                icon: Icons.web_asset_off_outlined,
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RemoveAdPage(),
                    ),
                  );
                },
              ),
              const Divider(),
              const SizedBox(height: 32),
              const AdBanner(large: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    version,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget settingTitle({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  InterstitialAd? interstitialAd;

  Future<void> loadAd() async {
    await InterstitialAd.load(
        adUnitId:
            Constants.testingMode ? Constants.testInterstitialAdId : Constants.interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
    if (interstitialAd == null) return;
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('%ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
    );
  }

  Future<void> _showAppWidgetTutorial2() async {
    await showDialog(
      context: context,
      builder: (context) => const AppWidgetSplash(),
    );
  }
}
