import 'package:accounting/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddRecodePage extends StatefulWidget {
  const AddRecodePage({Key? key}) : super(key: key);

  @override
  State<AddRecodePage> createState() => _AddRecodePageState();
}

class _AddRecodePageState extends State<AddRecodePage> {
  List<bool> _selectedIndex = [true, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 32),
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
        ],
      ),
    );
  }
}
