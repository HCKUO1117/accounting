import 'package:accounting/db/fixed_income_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class ChooseDayPage extends StatefulWidget {
  final FixedIncomeType type;
  final int month;
  final int day;
  final Function(int, int) onSave;

  const ChooseDayPage({
    Key? key,
    required this.type,
    required this.month,
    required this.day,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ChooseDayPage> createState() => _ChooseDayPageState();
}

class _ChooseDayPageState extends State<ChooseDayPage> {
  TextEditingController amount = TextEditingController();

  int currentDay = 1;
  int currentMonth = 1;

  String? errorText;

  @override
  void initState() {
    final MainProvider mainProvider = context.read<MainProvider>();
    amount.text = mainProvider.goalNum == -1 ? '' : mainProvider.goalNum.toString();
    currentDay = widget.day;
    currentMonth = widget.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              S.of(context).selectTime,
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
                  widget.type.text(context),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                if (widget.type == FixedIncomeType.eachYear) ...[
                  Expanded(
                    child: NumberPicker(
                      value: currentMonth,
                      minValue: 1,
                      maxValue: 12,
                      onChanged: (value) => setState(() => currentMonth = value),
                    ),
                  ),
                  const Text(
                    '/',
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
                Expanded(
                  child: NumberPicker(
                    value: currentDay,
                    minValue: widget.type.minDay,
                    maxValue: widget.type.maxDay,
                    onChanged: (value) => setState(() => currentDay = value),
                  ),
                ),
                if (widget.type == FixedIncomeType.eachDay)
                  Text(
                    S.of(context).oClock,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () async {
                widget.onSave(currentMonth, currentDay);
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
