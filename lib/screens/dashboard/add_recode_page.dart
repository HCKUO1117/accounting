import 'package:accounting/db/accounting_model.dart';
import 'package:accounting/generated/l10n.dart';
import 'package:accounting/screens/widget/fake_dropdown_button.dart';
import 'package:flutter/material.dart';

class AddRecodePage extends StatefulWidget {
  final AccountingModel? model;

  const AddRecodePage({Key? key, this.model}) : super(key: key);

  @override
  State<AddRecodePage> createState() => _AddRecodePageState();
}

class _AddRecodePageState extends State<AddRecodePage> {
  final List<bool> _selectedIndex = [true, false];

  final TextEditingController amount = TextEditingController();
  final TextEditingController note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(widget.model == null ? S.of(context).add : S.of(context).edit),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            )
          ],
        ),
        body: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _selectedIndex.length; i++) {
                      _selectedIndex[i] = i == index;
                    }
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.orange,
                selectedColor: Colors.white,
                fillColor: Colors.orange.shade400,
                color: Colors.black54,
                constraints: BoxConstraints(
                  minHeight: 40.0,
                  minWidth: MediaQuery.of(context).size.width / 2 - 32,
                ),
                isSelected: _selectedIndex,
                children: [
                  Text(S.of(context).income),
                  Text(S.of(context).expenditure),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.book_outlined),
                  Text(
                    '${S.of(context).category} : ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FakeDropDownButton(
                      hint: S.of(context).category,
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (context) => Container(),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.local_offer_outlined),
                  Text(
                    '${S.of(context).tag} : ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(Icons.add),
                        Text(S.of(context).add),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.monetization_on_outlined),
                  Text(
                    '${S.of(context).amount} : ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: amount,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: S.of(context).amount,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.edit_note_outlined),
                  Text(
                    '${S.of(context).note} : ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: note,
                      decoration: InputDecoration(
                        hintText: S.of(context).note,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: () {},
                child: Text(
                  S.of(context).save,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
