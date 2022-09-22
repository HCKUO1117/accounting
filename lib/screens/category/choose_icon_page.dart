import 'package:accounting/provider/icon_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/res/icons.dart';
import 'package:accounting/screens/widget/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseIconPage extends StatefulWidget {
  const ChooseIconPage({Key? key}) : super(key: key);

  @override
  State<ChooseIconPage> createState() => _ChooseIconPageState();
}

class _ChooseIconPageState extends State<ChooseIconPage> {
  IconProvider iconProvider = IconProvider();

  @override
  void initState() {
    iconProvider.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: iconProvider,
      child: Consumer(
        builder: (context, IconProvider provider, _) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              title: const Text('Select Icon'),
              actions: [
                Icon(icons[provider.selected]),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(provider.selected);
                  },
                  icon: const Icon(Icons.check),
                )
              ],
            ),
            body: Scrollbar(
              isAlwaysShown: true,
              thickness: 5,
              interactive: true,
              radius: const Radius.circular(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: provider.list.length,
                itemBuilder: (context, index) {
                  return Bouncing(
                    onPress: () {
                      provider.setIcon(provider.list[index].name);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            provider.selected == provider.list[index].name ? Colors.black54 : null,
                      ),
                      child: Icon(
                        provider.list[index].iconData,
                        color: provider.selected == provider.list[index].name ? Colors.white : null,
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
