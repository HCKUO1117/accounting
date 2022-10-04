import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/utils/utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({Key? key}) : super(key: key);

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  late List<String> items;
  int selectedValue = 0;
  DateTime? goalDate;

  TextEditingController amount = TextEditingController();

  String? errorText;

  @override
  Widget build(BuildContext context) {
    items = [
      S.of(context).eachMonth,
      S.of(context).longBefore,
    ];
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          S.of(context).setTarget,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(height: 32),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: const [
                Expanded(
                  child: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: [
              for (int i = 0; i < items.length; i++)
                DropdownMenuItem<int>(
                  value: i,
                  child: Text(
                    items[i],
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
            value: selectedValue,
            onChanged: (value) async {
              if (value == 0) {
                goalDate = null;
              }
              if (value == 1) {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime(
                    DateTime.now().year + 100,
                    12,
                    31,
                  ),
                );
                if (date == null) return;
                goalDate = date;
              }
              setState(() {
                selectedValue = value as int;
              });
            },
            iconSize: 14,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
            ),
            itemHeight: 40,
            itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownPadding: null,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
          ),
        ),
        const SizedBox(height: 16),
        if (goalDate != null) ...[
          Text(
            Utils.toDateString(goalDate!, format: 'yyyy/MM/dd'),
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'RobotoMono',
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).before,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
        const SizedBox(height: 16),

        Row(
          children: [
            Text(
              '${S.of(context).save1}:',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'RobotoMono',
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: amount,
                  style: const TextStyle(
                    color: Colors.orange,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    errorText: errorText,
                    border: InputBorder.none,
                    hintText: S.of(context).amount,
                  ),
                ),
              ),
            ),
          ],
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
          ),
          onPressed: () async {
            if (amount.text.isEmpty) {
              setState(() {
                errorText = S.of(context).pleaseEnterName;
              });
              return;
            }


          },
          child: Text(
            S.of(context).save,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
