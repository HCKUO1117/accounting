import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/dashboard/add_recode_page.dart';
import 'package:accounting/screens/widget/accounting_title.dart';
import 'package:flutter/material.dart';

class AccountingListPage extends StatefulWidget {
  final List<AccountingModel> list;
  final double topPadding;
  final int id;

  const AccountingListPage({
    Key? key,
    required this.list,
    required this.topPadding,
    required this.id,
  }) : super(key: key);

  @override
  State<AccountingListPage> createState() => _AccountingListPageState();
}

class _AccountingListPageState extends State<AccountingListPage> {
  List<AccountingModel> list = [];

  @override
  void initState() {
    getList();

    super.initState();
  }

  Future<void> getList() async {
    list = await AccountingDB.queryData(queryType: QueryType.category, query: ['${widget.id}']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
        ),
        body: list.isEmpty
            ? Center(
                child: Text(
                  S.of(context).noRecord,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return AccountingTitle(
                      model: list[index],
                      onTap: () async {
                        await showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(top: widget.topPadding),
                            child: AddRecodePage(
                              model: list[index],
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        getList();
                      });
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 4,
                  );
                },
                itemCount: widget.list.length,
              ),
      ),
    );
  }
}
