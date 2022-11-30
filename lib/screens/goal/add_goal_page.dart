import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/home_widget_provider.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/utils/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({Key? key}) : super(key: key);

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  TextEditingController amount = TextEditingController();

  String? errorText;

  @override
  void initState() {
    final MainProvider mainProvider = context.read<MainProvider>();
    amount.text = mainProvider.goalNum == -1 ? '' : mainProvider.goalNum.toString();
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
              S.of(context).setBudget,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              S.of(context).eachMonth,
              style: const TextStyle(
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
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
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
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
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              onPressed: () async {
                if (amount.text.isEmpty) {
                  ShowToast.showToast(S.of(context).notFillAmount);
                  return;
                  // setState(() {
                  //   errorText = S.of(context).pleaseEnterName;
                  // });
                  // return;
                }
                try {
                  double.parse(amount.text);
                } catch (e) {
                  ShowToast.showToast(S.of(context).amountFormatError);
                  return;
                }
                await context.read<MainProvider>().setGoal(
                      double.parse(amount.text),
                    );
                if (!mounted) return;
                context.read<HomeWidgetProvider>().sendAndUpdate();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).addSuccess),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
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
