import 'package:accounting/db/category_db.dart';
import 'package:accounting/db/category_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/icons.dart';
import 'package:accounting/screens/category/choose_icon_page.dart';
import 'package:accounting/screens/widget/bouncing_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class AddCategoryPage extends StatefulWidget {
  final CategoryModel? model;
  final CategoryType type;

  const AddCategoryPage({Key? key, required this.type, this.model}) : super(key: key);

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _editingController = TextEditingController();
  String? errorText;

  Color iconPickerColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  late Color iconColor;
  String iconString = icons.keys.toList()[math.Random().nextInt(icons.length)];

  @override
  void initState() {
    iconColor = iconPickerColor;
    if (widget.model != null) {
      _editingController.text = widget.model!.name;
      iconPickerColor = widget.model!.iconColor;
      iconString = widget.model!.icon;
      iconColor = widget.model!.iconColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              widget.type == CategoryType.income ? S.of(context).income : S.of(context).expenditure,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
                color: Colors.orangeAccent,
              ),
            ),
            // Stack(
            //   alignment: Alignment.centerRight,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //
            //       ],
            //     ),
            //     IconButton(
            //       onPressed: () async {
            //         if (_editingController.text.isEmpty) {
            //           setState(() {
            //             errorText = S.of(context).pleaseEnterName;
            //           });
            //           return;
            //         }
            //         if (widget.model == null) {
            //           await CategoryDB.insertData(
            //             CategoryModel(
            //               type: widget.type,
            //               icon: iconString,
            //               iconColor: iconColor,
            //               name: _editingController.text,
            //             ),
            //           );
            //         } else {
            //           await CategoryDB.updateData(
            //             CategoryModel(
            //               type: widget.type,
            //               icon: iconString,
            //               iconColor: iconColor,
            //               name: _editingController.text,
            //             ),
            //           );
            //         }
            //         if (!mounted) return;
            //         context.read<MainProvider>().getCategoryList();
            //         Navigator.pop(context);
            //       },
            //       icon: const Icon(
            //         Icons.check,
            //         color: Colors.green,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 32),
            Row(
              children: [
                Text(
                  '${S.of(context).icon} : ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                const SizedBox(width: 8),
                Bouncing(
                  child: Icon(
                    icons[iconString],
                  ),
                  onPress: () async {
                    String? icon = await Navigator.of(context).push(
                      MaterialPageRoute<String>(
                        builder: (context) => const ChooseIconPage(),
                      ),
                    );
                    if (icon != null) {
                      setState(() {
                        iconString = icon;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '${S.of(context).color} : ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    iconPickerColor = iconColor;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: iconPickerColor,
                            onColorChanged: (color) {
                              setState(() {
                                iconPickerColor = color;
                              });
                            },
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              setState(() {
                                iconColor = iconPickerColor;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _editingController,
                    decoration: InputDecoration(
                      errorText: errorText,
                      labelText: S.of(context).categoryName,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () async {
                if (_editingController.text.isEmpty) {
                  setState(() {
                    errorText = S.of(context).pleaseEnterName;
                  });
                  return;
                }
                if (widget.model == null) {
                  await CategoryDB.insertData(
                    CategoryModel(
                      type: widget.type,
                      icon: iconString,
                      iconColor: iconColor,
                      name: _editingController.text,
                    ),
                  );
                } else {
                  await CategoryDB.updateData(
                    CategoryModel(
                      type: widget.type,
                      icon: iconString,
                      iconColor: iconColor,
                      name: _editingController.text,
                    ),
                  );
                }
                if (!mounted) return;
                context.read<MainProvider>().getCategoryList();
                Navigator.pop(context);
              },
              child: Text(
                S.of(context).save,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
