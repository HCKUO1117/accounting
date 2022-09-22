import 'package:accounting/db/category_model.dart';
import 'package:flutter/material.dart';

class FakeDropDownButton extends StatelessWidget {
  final String hint;
  final CategoryModel? model;
  final VoidCallback onTap;

  const FakeDropDownButton({
    Key? key,
    required this.hint,
    this.model,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.orangeAccent),
        ),
        child: Row(
          children: [
            if (model == null)
              Text(
                hint,
                style: const TextStyle(color: Colors.black38),
              ),
            const Spacer(),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.orange,
            )
          ],
        ),
      ),
    );
  }
}
