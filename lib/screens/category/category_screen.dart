import 'package:accounting/db/category_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/category/add_category_page.dart';
import 'package:accounting/screens/category/add_tag_page.dart';
import 'package:accounting/screens/category/income_category_page.dart';
import 'package:accounting/screens/widget/category_title.dart';
import 'package:accounting/screens/widget/tag_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    context.read<MainProvider>().getCategoryList();
    context.read<MainProvider>().getTagList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider mainProvider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(S.of(context).category),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: S.of(context).category,
                icon: const Icon(Icons.class_outlined),
              ),
              Tab(
                text: S.of(context).tag,
                icon: const Icon(Icons.local_offer_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            category(mainProvider),
            tag(mainProvider),
          ],
        ),
      );
    });
  }

  Widget category(MainProvider provider) {
    return Container(
      color: Colors.orangeAccent.shade200.withOpacity(0.2),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: 'categoryIncome',
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S.of(context).income,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => IncomeCategoryPage(
                                        tag: 'categoryIncome',
                                        title: S.of(context).income,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(S.of(context).expand),
                              ),
                            ],
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return CategoryTitle(model: provider.categoryIncomeList[index]);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: provider.categoryIncomeList.length,
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  scrollable: true,
                                  content: const AddCategoryPage(type: CategoryType.income),
                                ),
                              );
                              // showModalBottomSheet(
                              //   isScrollControlled: true,
                              //   shape: const RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.only(
                              //       topRight: Radius.circular(20),
                              //       topLeft: Radius.circular(20),
                              //     ),
                              //   ),
                              //   context: context,
                              //   builder: (context) => SingleChildScrollView(
                              //     child: AnimatedPadding(
                              //       duration: const Duration(milliseconds: 150),
                              //       curve: Curves.easeOut,
                              //       padding: EdgeInsets.only(
                              //           bottom: MediaQuery.of(context).viewInsets.bottom),
                              //       child: const AddCategoryPage(type: CategoryType.income),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Hero(
                  tag: 'categoryExpenditure',
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  S.of(context).expenditure,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => IncomeCategoryPage(
                                        tag: 'categoryExpenditure',
                                        title: S.of(context).expenditure,
                                      ),
                                    ),
                                  );
                                },
                                child: Text(S.of(context).expand),
                              )
                            ],
                          ),
                          ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return CategoryTitle(
                                    model: provider.categoryExpenditureList[index]);
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: provider.categoryExpenditureList.length),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  scrollable: true,
                                  content: const AddCategoryPage(type: CategoryType.expenditure),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tag(MainProvider provider) {
    return Container(
      color: Colors.orangeAccent.shade200.withOpacity(0.2),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).tag,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TagTitle(model: provider.tagList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemCount: provider.tagList.length),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            scrollable: true,
                            content: const AddTagPage()),
                      );
                      // showModalBottomSheet(
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.only(
                      //       topRight: Radius.circular(20),
                      //       topLeft: Radius.circular(20),
                      //     ),
                      //   ),
                      //   context: context,
                      //   isScrollControlled: true,
                      //   builder: (context) => SingleChildScrollView(
                      //     child: AnimatedPadding(
                      //       duration: const Duration(milliseconds: 150),
                      //       curve: Curves.easeOut,
                      //       padding:
                      //           EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      //       child: const AddTagPage(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
