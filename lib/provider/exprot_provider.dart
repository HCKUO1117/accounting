import 'dart:io';

import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/record_tag_db.dart';
import 'package:accounting/db/record_tag_model.dart';
import 'package:accounting/db/tag_db.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/screens/member/export_excel_page.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_platform_interface.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ExportProvider with ChangeNotifier {
  ExportStatus exportStatus = ExportStatus.ready;

  Future<void> exportExcel(BuildContext context) async {
    exportStatus = ExportStatus.exporting;
    notifyListeners();

    List<AccountingModel> accountingList = await AccountingDB.displayAllData();
    List<CategoryModel> categories = await CategoryDB.displayAllData();
    List<TagModel> tags = await TagDB.displayAllData();

    final excel = Excel.createExcel();
    final accountingSheet = excel[excel.getDefaultSheet()!];

    accountingList.sort((a, b) => b.date.compareTo(a.date));

    for (int i = 0; i < accountingList.length; i++) {
      accountingSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i)).value =
          DateFormat('yyyy/MM/dd HH:mm:ss').format(accountingList[i].date);

      if (categories.indexWhere((element) => element.id == accountingList[i].category) != -1) {
        accountingSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i)).value =
            categories.firstWhere((element) => element.id == accountingList[i].category).name;
      } else {
        accountingSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i)).value =
            S.of(context).unCategory;
      }

      accountingSheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i)).value =
          accountingList[i].amount;

      List<RecordTagModel> recordTags = await RecordTagDB.queryData(
        queryType: RecordTagType.record,
        query: [accountingList[i].id!],
      );

      String tag = '';
      for (var element in recordTags) {
        if (tags.indexWhere((e) => e.id == element.tagId) != -1) {
          tag += ',${tags.firstWhere((e) => e.id == element.tagId).name}';
        }
      }

      accountingSheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i)).value = tag;

      accountingSheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i)).value =
          accountingList[i].note;
    }

    var fileBytes = excel.save(fileName: 'accountingData.xlsx');

    var directory = await getApplicationSupportDirectory();

    File(join("${directory.path}/accountingData.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
    await MediaStorePlatform.instance.saveFile(
      tempFilePath: "${directory.path}/accountingData.xlsx",
      fileName: 'accountingData.xlsx',
      dirType: DirType.download,
      dirName: DirName.download,
      relativePath: '',
    );

    exportStatus = ExportStatus.finish;
    notifyListeners();
  }
}
