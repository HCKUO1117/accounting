import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/res/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  MultiSelectController controller = MultiSelectController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider provider, _) {
      return Column(
        children: [
          Text(
            S.of(context).category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 16),
          Text(S.of(context).income),
          Wrap(
            spacing: 4,
            children: [
              ChoiceChip(
                  selected: provider.incomeCategoryFilter == null,
                  selectedColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  backgroundColor: AppColors.backgroundColor,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(S.of(context).all)],
                  ),
                  onSelected: (v) {
                    provider.setIncomeFilter(0);
                  }),
              for (final element in provider.categoryIncomeList)
                ChoiceChip(
                    selected: provider.incomeCategoryFilter?.contains(element.id) ?? true,
                    selectedColor: element.iconColor,
                    side: BorderSide(color: element.iconColor),
                    backgroundColor: element.iconColor.withOpacity(0.2),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icons[element.icon]),
                        const SizedBox(width: 8),
                        Text(element.name)
                      ],
                    ),
                    onSelected: (v) {
                      provider.setIncomeFilter(element.id!);
                    }),
              ChoiceChip(
                  selected: provider.incomeCategoryFilter?.contains(-1) ?? true,
                  selectedColor: Colors.black54,
                  side: BorderSide(
                      color: provider.incomeCategoryFilter?.contains(-1) ?? true
                          ? Colors.transparent
                          : Colors.black54),
                  backgroundColor: Colors.black12,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.help_outline),
                      const SizedBox(width: 8),
                      Text(S.of(context).unCategory)
                    ],
                  ),
                  onSelected: (v) {
                    provider.setIncomeFilter(-1);
                  }),
            ],
          ),
          Text(S.of(context).expenditure),
          Wrap(
            spacing: 4,
            children: [
              ChoiceChip(
                  selected: provider.expenditureCategoryFilter == null,
                  selectedColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  backgroundColor: AppColors.backgroundColor,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(S.of(context).all)],
                  ),
                  onSelected: (v) {
                    provider.setExpenditureFilter(0);
                  }),
              for (final element in provider.categoryExpenditureList)
                ChoiceChip(
                    selected: provider.expenditureCategoryFilter?.contains(element.id) ?? true,
                    selectedColor: element.iconColor,
                    side: BorderSide(color: element.iconColor),
                    backgroundColor: element.iconColor.withOpacity(0.2),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icons[element.icon]),
                        const SizedBox(width: 8),
                        Text(element.name)
                      ],
                    ),
                    onSelected: (v) {
                      provider.setExpenditureFilter(element.id!);
                    }),
              ChoiceChip(
                  selected: provider.expenditureCategoryFilter?.contains(-1) ?? true,
                  selectedColor: Colors.black54,
                  side: BorderSide(
                      color: provider.expenditureCategoryFilter?.contains(-1) ?? true
                          ? Colors.transparent
                          : Colors.black54),
                  backgroundColor: Colors.black12,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.help_outline),
                      const SizedBox(width: 8),
                      Text(S.of(context).unCategory)
                    ],
                  ),
                  onSelected: (v) {
                    provider.setExpenditureFilter(-1);
                  }),
            ],
          ),
          Text(
            S.of(context).tag,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 4,
            children: [
              ChoiceChip(
                  selected: provider.dashBoardTagFilter == null,
                  selectedColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  backgroundColor: AppColors.backgroundColor,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(S.of(context).all)],
                  ),
                  onSelected: (v) {
                    provider.setTagFilter(0);
                  }),
              for (final element in provider.tagList)
                ChoiceChip(
                    selected: provider.dashBoardTagFilter?.contains(element.id) ?? true,
                    selectedColor: element.color,
                    side: BorderSide(color: element.color),
                    backgroundColor: element.color.withOpacity(0.2),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text(element.name)],
                    ),
                    onSelected: (v) {
                      provider.setTagFilter(element.id!);
                    }),
              ChoiceChip(
                  selected: provider.dashBoardTagFilter?.contains(-1) ?? true,
                  selectedColor: Colors.black54,
                  side: BorderSide(
                      color: provider.dashBoardTagFilter?.contains(-1) ?? true
                          ? Colors.transparent
                          : Colors.black54),
                  backgroundColor: Colors.black12,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(S.of(context).noTag)],
                  ),
                  onSelected: (v) {
                    provider.setTagFilter(-1);
                  }),
            ],
          )
        ],
      );
    });
  }
}
