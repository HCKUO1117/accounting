import 'package:accounting/db/accounting_db.dart';
import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/category/add_category_page.dart';
import 'package:accounting/screens/widget/category_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCategoryPage extends StatefulWidget {
  final String tag;
  final String title;

  const IncomeCategoryPage({
    Key? key,
    required this.tag,
    required this.title,
  }) : super(key: key);

  @override
  State<IncomeCategoryPage> createState() => _IncomeCategoryPageState();
}

class _IncomeCategoryPageState extends State<IncomeCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            widget.title,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        body: Consumer<MainProvider>(
          builder: (BuildContext context, MainProvider provider, _) {
            List<CategoryModel> list = widget.tag == 'categoryIncome'
                ? provider.categoryIncomeList
                : provider.categoryExpenditureList;
            return Column(
              children: [
                Expanded(
                  child: ReorderableListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    onReorder: (int oldIndex, int newIndex) async {
                      if (widget.tag == 'categoryIncome') {
                        final CategoryModel m = provider.categoryIncomeList[oldIndex];

                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        setState(() {
                          provider.categoryIncomeList.removeAt(oldIndex);
                          provider.categoryIncomeList.insert(newIndex, m);
                        });
                        for (int i = 0; i < provider.categoryIncomeList.length; i++) {
                          CategoryModel model = provider.categoryIncomeList[i];
                          model.sort = i;
                          await CategoryDB.updateData(model);
                        }
                      } else {
                        final CategoryModel m = provider.categoryExpenditureList[oldIndex];

                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        setState(() {
                          provider.categoryExpenditureList.removeAt(oldIndex);
                          provider.categoryExpenditureList.insert(newIndex, m);
                        });
                        for (int i = 0; i < provider.categoryExpenditureList.length; i++) {
                          CategoryModel model = provider.categoryExpenditureList[i];
                          model.sort = i;
                          await CategoryDB.updateData(model);
                        }
                      }
                    },
                    children: [
                      for (int i = 0;
                          i <
                              (widget.tag == 'categoryIncome'
                                  ? provider.categoryIncomeList.length
                                  : provider.categoryExpenditureList.length);
                          i++)
                        Column(
                          key: Key(i.toString()),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CategoryTitle(
                                    key: Key(list[i].id.toString()),
                                    model: list[i],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        scrollable: true,
                                        content: AddCategoryPage(
                                          type: widget.tag == 'categoryIncome'
                                              ? CategoryType.income
                                              : CategoryType.expenditure,
                                          model: list[i],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black54,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    List<AccountingModel> l = await AccountingDB.queryData(
                                        queryType: QueryType.category, query: ['${list[i].id!}']);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(S.of(context).notify),
                                        content: Text(S.of(context).deleteCheck +
                                            (l.isNotEmpty
                                                ? '\n(${S.of(context).toUnCategory})'
                                                : '')),
                                        actions: [
                                          if(l.isNotEmpty)
                                            TextButton(
                                              onPressed: () {
                                                //TODO 顯示未分類列表
                                              },
                                              child: Text(
                                                S.of(context).showRecord,
                                                style: const TextStyle(color: Colors.black54),
                                              ),
                                            ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              S.of(context).cancel,
                                              style: const TextStyle(color: Colors.black54),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await CategoryDB.deleteData(list[i].id!);
                                              for (var element in l) {
                                                AccountingDB.updateData(element..category = -1);
                                              }
                                              provider.getCategoryList();
                                              Navigator.pop(context);
                                            },
                                            child: Text(S.of(context).ok),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            if (i + 1 !=
                                (widget.tag == 'categoryIncome'
                                    ? provider.categoryIncomeList.length
                                    : provider.categoryExpenditureList.length))
                              const Divider()
                          ],
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        scrollable: true,
                        content: AddCategoryPage(
                          type: widget.tag == 'categoryIncome'
                              ? CategoryType.income
                              : CategoryType.expenditure,
                        ),
                      ),
                    );
                    // showModalBottomSheet(
                    //   shape: const RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.only(
                    //       topRight: Radius.circular(20),
                    //       topLeft: Radius.circular(20),
                    //     ),
                    //   ),
                    //   isScrollControlled: true,
                    //   context: context,
                    //   builder: (context) => SingleChildScrollView(
                    //     child: AnimatedPadding(
                    //       duration: const Duration(milliseconds: 150),
                    //       curve: Curves.easeOut,
                    //       padding: EdgeInsets.only(
                    //           bottom: MediaQuery.of(context).viewInsets.bottom),
                    //       child: const AddCategoryPage(type: CategoryType.expenditure),
                    //     ),
                    //   ),
                    // );
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 16),
                // ListView.separated(
                //   padding: const EdgeInsets.all(16),
                //   physics: const NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     return CategoryTitle(model: list[index]);
                //   },
                //   separatorBuilder: (context, index) {
                //     return const Divider();
                //   },
                //   itemCount: list.length,
                // )
              ],
            );
          },
        ),
      ),
    );
  }
}
