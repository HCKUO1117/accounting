import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/tag_db.dart';
import 'package:accounting/db/tag_model.dart';
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

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
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
    return Consumer<MainProvider>(
        builder: (BuildContext context, MainProvider mainProvider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(S.of(context).category,style: const TextStyle(fontFamily: 'RobotoMono',),),
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
                    elevation: 5,
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
                              return CategoryTitle(
                                  model: provider.categoryIncomeList[index]);
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
                                  content: const AddCategoryPage(
                                      type: CategoryType.income),
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
                    elevation: 5,
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
                                  model:
                                      provider.categoryExpenditureList[index]);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: provider.categoryExpenditureList.length,
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
                                  content: const AddCategoryPage(
                                      type: CategoryType.expenditure),
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
          const SizedBox(height: 8),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (int oldIndex, int newIndex) async {
                        final TagModel m = provider.tagList[oldIndex];
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        setState(() {
                          provider.tagList.removeAt(oldIndex);
                          provider.tagList.insert(newIndex, m);
                        });
                        for (int i = 0; i < provider.tagList.length; i++) {
                          TagModel model = provider.tagList[i];
                          model.sort = i;
                          await TagDB.updateData(model);
                        }
                      },
                      children: [
                        for (int i = 0; i < provider.tagList.length; i++)
                          Column(
                            key: Key(i.toString()),
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TagTitle(
                                      key: Key(
                                          provider.tagList[i].id.toString()),
                                      model: provider.tagList[i],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          scrollable: true,
                                          content: AddTagPage(
                                            model: provider.tagList[i],
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
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(S.of(context).notify),
                                          content:
                                              Text(S.of(context).deleteCheck),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                S.of(context).cancel,
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await TagDB.deleteData(
                                                    provider.tagList[i].id!);
                                                provider.getTagList();
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
                              if (i + 1 != provider.tagList.length)
                                const Divider()
                            ],
                          )
                      ],
                    ),
                    // ListView.separated(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemBuilder: (context, index) {
                    //       return TagTitle(model: provider.tagList[index]);
                    //     },
                    //     separatorBuilder: (context, index) {
                    //       return const Divider();
                    //     },
                    //     itemCount: provider.tagList.length,),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              scrollable: true,
                              content: const AddTagPage(),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.white,
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
