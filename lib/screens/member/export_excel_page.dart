import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/exprot_provider.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

enum ExportStatus {
  ready,
  exporting,
  finish,
}

class ExportExcelPage extends StatefulWidget {
  const ExportExcelPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExportExcelPage> createState() => _ExportExcelPageState();
}

class _ExportExcelPageState extends State<ExportExcelPage> {
  ExportProvider provider = ExportProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<ExportProvider>(
        builder: (BuildContext context, ExportProvider provider, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.transparent,
            ),
            child: content(provider),
          );
        },
      ),
    );
  }

  Widget content(ExportProvider provider) {
    switch (provider.exportStatus) {
      case ExportStatus.ready:
        return Column(
          children: [
            const SizedBox(height: 32),
            Text(S.of(context).exportInfo),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () async {
                provider.exportExcel(context);
              },
              child: Text(
                S.of(context).startExport,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      case ExportStatus.exporting:
        return Column(
          children: [
            Text(S.of(context).exporting),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        );
      case ExportStatus.finish:
        return Column(
          children: [
            Text(S.of(context).finishExport),
            const SizedBox(height: 16),
            Text(
              S.of(context).finishExportInfo,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () async {
                Share.shareFiles(['/storage/emulated/0/Download/accountingData.xlsx']);
              },
              child: Text(
                S.of(context).share,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
    }
  }
}
