import 'package:accounting/db/tag_db.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class AddTagPage extends StatefulWidget {
  final TagModel? model;

  const AddTagPage({Key? key, this.model}) : super(key: key);

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  final TextEditingController _editingController = TextEditingController();
  String? errorText;

  Color iconPickerColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  late Color iconColor;

  @override
  void initState() {
    iconColor = iconPickerColor;
    if (widget.model != null) {
      _editingController.text = widget.model!.name;
      iconPickerColor = widget.model!.color;
      iconColor = widget.model!.color;
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
              S.of(context).tag,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 32),
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
                  await TagDB.insertData(
                    TagModel(
                      color: iconColor,
                      name: _editingController.text,
                    ),
                  );
                } else {
                  await TagDB.updateData(
                    TagModel(
                      color: iconColor,
                      name: _editingController.text,
                    ),
                  );
                }
                if (!mounted) return;
                context.read<MainProvider>().getTagList();
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
