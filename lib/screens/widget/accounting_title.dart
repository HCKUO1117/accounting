import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/widget/category_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountingTitle extends StatelessWidget {
  final AccountingModel model;
  final VoidCallback onTap;

  const AccountingTitle({
    Key? key,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('yyyy/MM/dd HH:mm').format(model.date),
                    style: const TextStyle(color: Colors.black38),
                  ),
                ),
                Text(
                  model.amount < 0
                      ? S.of(context).expenditure
                      : S.of(context).income,
                  style: TextStyle(
                    color:
                        model.amount < 0 ? Colors.redAccent : Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: CategoryTitle(
                    model: context.read<MainProvider>().categoryList.firstWhere(
                          (element) => element.id == model.category,
                        ),
                  ),
                ),
                Text(
                  model.amount.toString(),
                  style: TextStyle(
                    color:
                        model.amount < 0 ? Colors.redAccent : Colors.blueAccent,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            if (model.note.isNotEmpty)
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      model.note,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.black38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            const Divider(),
            Wrap(
              children: [
                for (var element in model.tags)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: context
                            .read<MainProvider>()
                            .tagList
                            .firstWhere((e) => e.id == element)
                            .color,
                        borderRadius: BorderRadius.circular(20)),
                    width: 15,
                    height: 15,
                  )
              ],
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
