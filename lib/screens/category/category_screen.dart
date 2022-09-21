import 'package:accounting/generated/l10n.dart';
import 'package:accounting/screens/category/income_category_page.dart';
import 'package:flutter/material.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          category(),
          tag(),
        ],
      ),
    );
  }

  Widget category() {
    return Container(
      color: Colors.orangeAccent.shade200.withOpacity(0.2),
      child: ListView(
        children: [
          Row(
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
                                child:Text(
                                    S.of(context).income,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                              )
                            ],
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
                                child:  Text(
                                    S.of(context).expenditure,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget tag() {
    return Container(
      color: Colors.orangeAccent.shade200.withOpacity(0.2),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [Text(S.of(context).tag)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
