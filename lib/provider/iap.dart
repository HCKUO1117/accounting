import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

const String _kSubscriptionId = 'com.hc.accounting_month';
const List<String> _kProductIds = <String>[
  _kSubscriptionId,
];

class IAP extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> products = <ProductDetails>[];
  List<PurchaseDetails> purchases = <PurchaseDetails>[];
  List<String> _consumables = <String>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  bool? isSubscription;

  Future<void> initIAP() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      print('get purchase down');
      _subscription.cancel();
    }, onError: (Object error) {
      print('get purchase error :' + error.toString());
      // handle error here.
    });
    await initStoreInfo();
    await getPurchases();
    notifyListeners();
  }

  Future<void> getPurchases()async {
    print('check');
    purchases = [];
    InAppPurchaseAndroidPlatformAddition androidPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    QueryPurchaseDetailsResponse queryPurchaseDetailsResponse =  await androidPlatformAddition.queryPastPurchases();
    purchases = queryPurchaseDetailsResponse.pastPurchases;
    try{
      if(purchases.isNotEmpty && purchases.indexWhere((element) => element.productID == _kSubscriptionId) != -1){
        if( purchases.firstWhere((element) => element.productID == _kSubscriptionId).status == PurchaseStatus.purchased){
          isSubscription = true;
          print('get purchase status' + purchases.toString());
          notifyListeners();
          return;
        }
        isSubscription = false;
      }
      isSubscription = false;
      print('get purchase status' + purchases.toString());
      notifyListeners();
    }catch (e){
      print(e);
    }
  }


  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = isAvailable;
      products = <ProductDetails>[];
      purchases = <PurchaseDetails>[];
      _notFoundIds = <String>[];
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }
    print(123);

    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //   _inAppPurchase
    //       .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    // }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }
    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = null;
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      purchases = <PurchaseDetails>[];
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = <String>[];
      _purchasePending = false;
      _loading = false;
      notifyListeners();
      return;
    }
    // final List<String> consumables = await ConsumableStore.load();
    _isAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _consumables = <String>[];
    _purchasePending = false;
    _loading = false;
    notifyListeners();

  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void showPendingUI() {
    _purchasePending = true;
    notifyListeners();
  }

  void handleError(IAPError error) {
    _purchasePending = false;
    notifyListeners();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
  }

  void handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> subscription() async {
    late PurchaseParam purchaseParam;
    if (products.indexWhere((element) => element.id == _kSubscriptionId) !=
        -1) {
      purchaseParam = PurchaseParam(
        productDetails:
        products.firstWhere((element) => element.id == _kSubscriptionId),
        applicationUserName: null,
      );
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
    notifyListeners();
  }

  void periodCheckSubscription(){
    getPurchases();
    Timer(const Duration(seconds: 10), (){
      periodCheckSubscription();
    });
  }
}
