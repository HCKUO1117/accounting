import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/icons.dart';
import 'package:accounting/screens/widget/custom_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> with TickerProviderStateMixin {
  MultiSelectController controller = MultiSelectController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider provider, _) {
      return Column(
        children: [
          Text(
            S.of(context).category,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
              color: Colors.orangeAccent,
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).income,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  provider.setIncomeFilter(0);
                },
                child: Text(S.of(context).selectAll),
              ),
            ],
          ),
          Column(
            children: [
              // CustomChip(
              //   name: S.of(context).all,
              //   isSelected: provider.incomeCategoryFilter == null,
              //   onSelect: () {
              //     provider.setIncomeFilter(0);
              //   },
              // ),
              // ChoiceChip(
              //     selected: provider.incomeCategoryFilter == null,
              //     selectedColor: Colors.orange,
              //     side: const BorderSide(color: Colors.orange),
              //     backgroundColor: AppColors.backgroundColor,
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [Text(S.of(context).all)],
              //     ),
              //     onSelected: (v) {
              //       provider.setIncomeFilter(0);
              //     }),
              for (final element in provider.categoryIncomeList)
                CustomChip(
                  name: element.name,
                  icon: icons[element.icon],
                  color: element.iconColor,
                  isSelected: provider.incomeCategoryFilter?.contains(element.id) ?? true,
                  onSelect: () {
                    provider.setIncomeFilter(element.id!);
                  },
                ),
              // ChoiceChip(
              //     selected: provider.incomeCategoryFilter?.contains(element.id) ?? true,
              //     selectedColor: element.iconColor,
              //     side: BorderSide(color: element.iconColor),
              //     backgroundColor: element.iconColor.withOpacity(0.2),
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(icons[element.icon]),
              //         const SizedBox(width: 8),
              //         Text(element.name)
              //       ],
              //     ),
              //     onSelected: (v) {
              //       provider.setIncomeFilter(element.id!);
              //     }),
              CustomChip(
                name: S.of(context).unCategory,
                icon: Icons.help_outline,
                color: Colors.black54,
                isSelected: provider.incomeCategoryFilter?.contains(-1) ?? true,
                onSelect: () {
                  provider.setIncomeFilter(-1);
                },
              ),
              // ChoiceChip(
              //     selected: provider.incomeCategoryFilter?.contains(-1) ?? true,
              //     selectedColor: Colors.black54,
              //     side: BorderSide(
              //         color: provider.incomeCategoryFilter?.contains(-1) ?? true
              //             ? Colors.transparent
              //             : Colors.black54),
              //     backgroundColor: Colors.black12,
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         const Icon(Icons.help_outline),
              //         const SizedBox(width: 8),
              //         Text(S.of(context).unCategory)
              //       ],
              //     ),
              //     onSelected: (v) {
              //       provider.setIncomeFilter(-1);
              //     }),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).expenditure,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                  onPressed: () {
                    provider.setExpenditureFilter(0);
                  },
                  child: Text(S.of(context).selectAll))
            ],
          ),
          Column(
            children: [
              // ChoiceChip(
              //     selected: provider.expenditureCategoryFilter == null,
              //     selectedColor: Colors.orange,
              //     side: const BorderSide(color: Colors.orange),
              //     backgroundColor: AppColors.backgroundColor,
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [Text(S.of(context).all)],
              //     ),
              //     onSelected: (v) {
              //       provider.setExpenditureFilter(0);
              //     }),
              for (final element in provider.categoryExpenditureList)
                CustomChip(
                  name: element.name,
                  icon: icons[element.icon],
                  color: element.iconColor,
                  isSelected: provider.expenditureCategoryFilter?.contains(element.id) ?? true,
                  onSelect: () {
                    provider.setExpenditureFilter(element.id!);
                  },
                ),
              // ChoiceChip(
              //     selected: provider.expenditureCategoryFilter?.contains(element.id) ?? true,
              //     selectedColor: element.iconColor,
              //     side: BorderSide(color: element.iconColor),
              //     backgroundColor: element.iconColor.withOpacity(0.2),
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(icons[element.icon]),
              //         const SizedBox(width: 8),
              //         Text(element.name)
              //       ],
              //     ),
              //     onSelected: (v) {
              //       provider.setExpenditureFilter(element.id!);
              //     }),
              CustomChip(
                name: S.of(context).unCategory,
                icon: Icons.help_outline,
                color: Colors.black54,
                isSelected: provider.expenditureCategoryFilter?.contains(-1) ?? true,
                onSelect: () {
                  provider.setExpenditureFilter(-1);
                },
              ),
              // ChoiceChip(
              //     selected: provider.expenditureCategoryFilter?.contains(-1) ?? true,
              //     selectedColor: Colors.black54,
              //     side: BorderSide(
              //         color: provider.expenditureCategoryFilter?.contains(-1) ?? true
              //             ? Colors.transparent
              //             : Colors.black54),
              //     backgroundColor: Colors.black12,
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         const Icon(Icons.help_outline),
              //         const SizedBox(width: 8),
              //         Text(S.of(context).unCategory)
              //       ],
              //     ),
              //     onSelected: (v) {
              //       provider.setExpenditureFilter(-1);
              //     }),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            S.of(context).tag,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
              color: Colors.orangeAccent,
            ),
          ),
          const Divider(),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: () {
                  provider.setTagFilter(0);
                },
                child: Text(S.of(context).selectAll),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ChoiceChip(
              //     selected: provider.dashBoardTagFilter == null,
              //     selectedColor: Colors.orange,
              //     side: const BorderSide(color: Colors.orange),
              //     backgroundColor: AppColors.backgroundColor,
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [Text(S.of(context).all)],
              //     ),
              //     onSelected: (v) {
              //       provider.setTagFilter(0);
              //     }),
              for (final element in provider.tagList)
                CustomChip(
                  name: element.name,
                  color: element.color,
                  isSelected: provider.dashBoardTagFilter?.contains(element.id) ?? true,
                  onSelect: () {
                    provider.setTagFilter(element.id!);
                  },
                ),
              // ChoiceChip(
              //     selected: provider.dashBoardTagFilter?.contains(element.id) ?? true,
              //     selectedColor: element.color,
              //     side: BorderSide(color: element.color),
              //     backgroundColor: element.color.withOpacity(0.2),
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [Text(element.name)],
              //     ),
              //     onSelected: (v) {
              //       provider.setTagFilter(element.id!);
              //     }),
              CustomChip(
                name: S.of(context).noTag,
                color: Colors.black54,
                isSelected: provider.dashBoardTagFilter?.contains(-1) ?? true,
                onSelect: () {
                  provider.setTagFilter(-1);
                },
              ),
              // ChoiceChip(
              //     selected: provider.dashBoardTagFilter?.contains(-1) ?? true,
              //     selectedColor: Colors.black54,
              //     side: BorderSide(
              //         color: provider.dashBoardTagFilter?.contains(-1) ?? true
              //             ? Colors.transparent
              //             : Colors.black54),
              //     backgroundColor: Colors.black12,
              //     label: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [Text(S.of(context).noTag)],
              //     ),
              //     onSelected: (v) {
              //       provider.setTagFilter(-1);
              //     }),
            ],
          )
        ],
      );
    });
  }
}
