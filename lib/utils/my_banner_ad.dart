import 'package:accounting/provider/iap.dart';
import 'package:accounting/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AdBanner extends StatefulWidget {
  final bool large;

  const AdBanner({Key? key, required this.large}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? myBanner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    if (myBanner != null) {
      myBanner!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox();
    return Consumer(builder: (BuildContext context, IAP iap, _) {
      if (iap.isSubscription == true) {
        return const SizedBox();
      }

      if (myBanner == null) {
        return const SizedBox(
          height: 50,
        );
      }
      return SizedBox(
        height: widget.large ? 250 : 50,
        child: Column(
          children: [Expanded(child: AdWidget(ad: myBanner!))],
        ),
      );
    });
  }

  Future<void> _loadAd() async {
    var iap = context.read<IAP>();
    if (iap.isSubscription == true) {
      return;
    }

    if (widget.large) {
      myBanner = BannerAd(
        adUnitId: Constants.testingMode ? Constants.testBannerId : Constants.bannerId,
        size: AdSize.mediumRectangle,
        request: const AdRequest(),
        listener: const BannerAdListener(),
      );
    } else {
      final AnchoredAdaptiveBannerAdSize? size =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
              MediaQuery.of(context).size.width.toInt());
      if (size == null) {
        return;
      }
      myBanner = BannerAd(
        adUnitId: Constants.testingMode ? Constants.testBannerId : Constants.bannerId,
        size: size,
        request: const AdRequest(),
        listener: const BannerAdListener(),
      );
    }
    setState(() {});
    if (myBanner != null) {
      myBanner!.load();
    }
  }
}
