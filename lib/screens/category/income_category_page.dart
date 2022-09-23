import 'package:accounting/db/category_model.dart';
import 'package:accounting/provider/main_provider.dart';
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
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CategoryTitle(model: list[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: list.length,
            );
          },
        ),
      ),
    );
  }
}
