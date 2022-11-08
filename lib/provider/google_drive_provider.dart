import 'dart:convert';

import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/fixed_income_db.dart';
import 'package:accounting/db/fixed_income_model.dart';
import 'package:accounting/db/record_tag_db.dart';
import 'package:accounting/db/record_tag_model.dart';
import 'package:accounting/db/tag_db.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/utils/google_drive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleDriveProvider with ChangeNotifier {
  bool loading = false;

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
      loading = true;
      notifyListeners();

      await getFileData();

      isLogin = true;

      loading = false;
      notifyListeners();
    }
  }

  Future<void> getFileData() async {
    try {
      var client = GoogleAuthClient(await googleSignInAccount!.authHeaders);
      var driveApi = drive.DriveApi(client);
      drive.FileList list = await driveApi.files.list($fields: 'files(createdTime,id,name)');

      if (list.files == null || list.files!.isEmpty) {
        return;
      }

      if (list.files!.indexWhere((element) => element.name == 'accountingData.act') == -1) {
        id = null;
        lastSaveTime = null;

        return;
      }

      drive.File file = list.files!.firstWhere((element) => element.name == 'accountingData.act');
      id = file.id!;

      lastSaveTime = file.createdTime!.toLocal();
    } catch (_) {}
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

  Future<void> uploadFile(
    BuildContext context, {
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    loading = true;
    notifyListeners();
    if (googleSignInAccount != null) {
      try {
        final authHeaders = await googleSignInAccount!.authHeaders;
        final authenticateClient = GoogleAuthClient(
          authHeaders,
        );
        final driveApi = drive.DriveApi(authenticateClient);

        Map<String, dynamic> dataMap = await changeDBtoString();

        String content = jsonEncode(dataMap);
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
          lastSaveTime = result.createdTime!.toLocal();
        } else {
          drive.File result = await driveApi.files.create(
            driveFile,
            uploadMedia: media,
            $fields: 'createdTime,id,name',
          );

          await driveApi.files.delete(id!);

          id = result.id;
          lastSaveTime = result.createdTime!.toLocal();
        }
        onSuccess.call();
      } catch (e) {
        onError.call(e.toString());
      }
    }

    loading = false;
    notifyListeners();
  }

  String text = '';

  Future<void> downloadGoogleDriveFile({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    if (id == null) return;
    loading = true;
    notifyListeners();
    try {
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

      jsonDecode(text);

      List<AccountingModel> accountingList = [];
      for (var element in jsonDecode(text)['accounting'] as List<dynamic>) {
        accountingList.add(AccountingModel.fromJson(element));
      }

      List<CategoryModel> categoryList = [];
      for (var element in jsonDecode(text)['category'] as List<dynamic>) {
        categoryList.add(CategoryModel.fromJson(element));
      }

      List<FixedIncomeModel> fixIncomeList = [];
      for (var element in jsonDecode(text)['fixIncome'] as List<dynamic>) {
        fixIncomeList.add(FixedIncomeModel.fromJson(element));
      }
      List<RecordTagModel> recordTagList = [];
      for (var element in jsonDecode(text)['recordTag'] as List<dynamic>) {
        recordTagList.add(RecordTagModel.fromJson(element));
      }
      List<TagModel> tagList = [];
      for (var element in jsonDecode(text)['tag'] as List<dynamic>) {
        tagList.add(TagModel.fromJson(element));
      }

      await AccountingDB.deleteDatabase();
      for (var element in accountingList) {
        AccountingDB.insertData(element);
      }
      await CategoryDB.deleteDatabase();
      for (var element in categoryList) {
        CategoryDB.insertData(element);
      }
      await FixedIncomeDB.deleteDatabase();
      for (var element in fixIncomeList) {
        FixedIncomeDB.insertData(element);
      }
      await RecordTagDB.deleteDatabase();
      for (var element in recordTagList) {
        RecordTagDB.insertData(element);
      }
      await TagDB.deleteDatabase();
      for (var element in tagList) {
        TagDB.insertData(element);
      }
      onSuccess.call();
    } catch (e) {
      print(e);
      onError.call(e.toString());
    }

    loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> changeDBtoString() async {
    Map<String, dynamic> allData = {};
    List<AccountingModel> accountingList = await AccountingDB.displayAllData();
    List<CategoryModel> categoryList = await CategoryDB.displayAllData();
    List<FixedIncomeModel> fixIncomeList = await FixedIncomeDB.displayAllData();
    List<RecordTagModel> recordTagList = await RecordTagDB.displayAllData();
    List<TagModel> tagList = await TagDB.displayAllData();

    allData.addAll({
      'accounting': List.generate(accountingList.length, (index) => accountingList[index].toMap()),
      'category': List.generate(categoryList.length, (index) => categoryList[index].toMap()),
      'fixIncome': List.generate(fixIncomeList.length, (index) => fixIncomeList[index].toMap()),
      'recordTag': List.generate(recordTagList.length, (index) => recordTagList[index].toMap()),
      'tag': List.generate(tagList.length, (index) => tagList[index].toMap()),
    });

    return allData;
  }
}
