import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/icon_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/res/icons.dart';
import 'package:accounting/screens/widget/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChooseIconPage extends StatefulWidget {
  final String selectedIcon;

  const ChooseIconPage({Key? key, required this.selectedIcon}) : super(key: key);

  @override
  State<ChooseIconPage> createState() => _ChooseIconPageState();
}

class _ChooseIconPageState extends State<ChooseIconPage> {
  final GlobalKey _key = GlobalKey();
  IconProvider iconProvider = IconProvider();

  final controller = AutoScrollController();
  bool first = true;

  @override
  void initState() {
    iconProvider.fetch(iconName: widget.selectedIcon);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final height = _key.currentContext?.size?.height;
      if (height != null) {
        try {
          int index =
              iconProvider.list.indexWhere((element) => element.name == iconProvider.selected);
          controller.jumpTo(index / 5.round() * height -
              (MediaQuery.of(context).size.height / 2 -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  56 +
                  height / 2));
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: iconProvider,
      child: Consumer(
        builder: (context, IconProvider provider, _) {
          if (!first) {
            try {
              int index =
                  iconProvider.list.indexWhere((element) => element.name == iconProvider.selected);
              controller.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
            } catch (_) {}
          }
          first = false;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              title: Text(S.of(context).selectIcon),
              actions: [
                Icon(icons[provider.selected]),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(provider.selected);
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                )
              ],
            ),
            body: Scrollbar(
              thumbVisibility: true,
              thickness: 5,
              interactive: true,
              radius: const Radius.circular(10),
              controller: controller,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: provider.list.length,
                controller: controller,
                itemBuilder: (context, index) {
                  return AutoScrollTag(
                    key: index == 0 ? _key : ValueKey(index),
                    controller: controller,
                    index: index,
                    child: Bouncing(
                      onPress: () {
                        provider.setIcon(provider.list[index].name);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: provider.selected == provider.list[index].name
                              ? Colors.black54
                              : null,
                        ),
                        child: Icon(
                          provider.list[index].iconData,
                          color:
                              provider.selected == provider.list[index].name ? Colors.white : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
