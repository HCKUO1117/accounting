import 'dart:convert';

import 'package:accounting/utils/google_drive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveProvider with ChangeNotifier {
  ///login
  bool logingIn = false;
  bool isLogin = false;

  User? user;

  GoogleSignInAccount? googleSignInAccount;

  DateTime? lastSaveTime;

  String? id;

  Future<void> initializeFirebase({
    required BuildContext context,
  }) async {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
      googleSignInAccount = await googleSignIn.signIn();



      await getFileData();

      isLogin = true;
      notifyListeners();
    }
  }

  Future<void> getFileData() async {
    var client = GoogleAuthClient(await googleSignInAccount!.authHeaders);
    var driveApi = drive.DriveApi(client);

    try{
      drive.FileList list =
      await driveApi.files.list($fields: 'files(createdTime,id,name)');

      if (list.files == null || list.files!.isEmpty) {
        return;
      }

      if(list.files!.indexWhere((element) => element.name == 'accountingData.act') == -1) {
        id = null;
        lastSaveTime = null;

        return;
      }
      print(list.files?.length);

      drive.File file = list.files!.firstWhere((element) => element.name == 'accountingData.act');
      id = file.id!;

      lastSaveTime = file.createdTime;
    }catch(_){

    }


  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    logingIn = true;
    notifyListeners();

    FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);

    googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          Fluttertoast.showToast(msg: 'The account already exists with a different credential');
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          Fluttertoast.showToast(msg: 'Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        // handle the error here
        Fluttertoast.showToast(msg: 'Error occurred using Google Sign In. Try again.');
      }
    }
    await getFileData();
    if (user != null) {
      isLogin = true;

      print(user);
    }

    logingIn = false;
    notifyListeners();
    return user;
  }

  Future<void> signOut(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      isLogin = false;
      user = null;
      googleSignInAccount = null;
      lastSaveTime = null;
      id = null;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error signing out. Try again.',
      );
    }
    notifyListeners();
  }

  Future<void> uploadFile(BuildContext context) async {
    if (googleSignInAccount != null) {
      final authHeaders = await googleSignInAccount!.authHeaders;
      final authenticateClient = GoogleAuthClient(
        authHeaders,
      );
      final driveApi = drive.DriveApi(authenticateClient);

      String content =
          '都市代謝作用係指維持都市居民生活及生產所需提供之物質,這些物質在生產及消費行為 經轉換後再輸出或排放出都市的過程。近年來都市規模快速擴張,除加速其代謝作用物質的流 動量,而其所產生的線性代謝作用模式更對環境產生極大之影響。本研究以台北地區公共工程 (包括道路、橋樑、下水道、防洪、捷運工程)及建築工程等都市建設活動所產生的代謝作用物 質(包括砂石、水泥、瀝青等建材資源及廢棄土)為研究對象,分析近二十年來台北地區都市建 設代謝作用物質流動的趨勢。根據估算結果顯示台北地區都市建設代謝作用物質流動量主要以 砂石資源為主(佔91%),且每年約產生3000萬噸的棄土量,其中以公共工程所佔比例最大。能值 評估結果顯示,台北地區都市建設所使用之砂石、水泥、及瀝青,在總體生態經濟系統之貢獻 雖因都市工程建設逐漸完成而減少,但仍佔極重要之份量。其中,尤以水泥為最。此外,廢棄 土能值在廢棄物中之比例極高。為進一步探討台北地區都市開發建設行為對於自然、人文環境 的影響,本文並建立整合都市建設、代謝作用及自然作用的永續性指標。分析結果顯示目前台北地區資源使用結構仍以都市建設活動為主,但已趨於平緩,且建材資源的使用效率已有明顯 的提昇,不僅使每人擁有道路面積及污水下水道普及率提高,亦使淡水河嚴重污染程度降低。 另一方面,土壤大量流失使淡水河輸沙量增加。在廢棄土方面,每年所產生的棄土量高達3000 萬頓,約為台灣地區三分之一,且資源使用量亦高達1000萬頓,對地表是雙重的破壞,而回收 再利用或回填的比例相當低,僅有500萬噸左右。未來除積極開發多樣性的砂石料源,建立健全 的砂石資源市場供需調查機制,並有效的回收利用廢棄土,提高資源使用效率,解決砂石料源';
      final Stream<List<int>> mediaStream =
          Future.value(utf8.encode(content)).asStream().asBroadcastStream();

      var media = drive.Media(mediaStream, utf8.encode(content).length);
      var driveFile = drive.File();
      driveFile.name = "accountingData.act";
      driveFile.createdTime = DateTime.now();

      if (id == null) {
        drive.File result = await driveApi.files.create(
          driveFile,
          uploadMedia: media,
          $fields: 'createdTime,id,name',
        );
        id = result.id;
        lastSaveTime = result.createdTime;
      } else {
        drive.File result = await driveApi.files.create(
          driveFile,
          uploadMedia: media,
          $fields: 'createdTime,id,name',
        );

        await driveApi.files.delete(id!);

        id = result.id;
        lastSaveTime = result.createdTime;
      }
    }
    notifyListeners();
  }

  String text = '';

  Future<void> downloadGoogleDriveFile() async {
    if (id == null) return;
    var client = GoogleAuthClient(await googleSignInAccount!.authHeaders);
    var driveApi = drive.DriveApi(client);

    drive.Media file = await driveApi.files
        .get(id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

    List<int> bytes = [];
    // print(await file.stream.length);
    await file.stream.forEach((element) {
      bytes.addAll(element);
    });
    text = const Utf8Decoder().convert(bytes);

    notifyListeners();
  }
}
