import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/iap.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/res/constants.dart';
import 'package:accounting/screens/member/export_excel_page.dart';
import 'package:accounting/screens/member/feedback_page.dart';
import 'package:accounting/screens/member/google_drive_page.dart';
import 'package:accounting/screens/member/notification_page.dart';
import 'package:accounting/screens/member/remove_ad_page.dart';
import 'package:accounting/utils/my_banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainProvider,IAP>(
      builder: (BuildContext context, MainProvider provider,IAP iap, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            title: Text(
              S.of(context).setting,
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
              if(!(iap.isSubscription ?? false)) const AdBanner(large: true),
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
}
