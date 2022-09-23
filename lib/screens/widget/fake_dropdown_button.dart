import 'package:accounting/db/category_model.dart';
import 'package:accounting/screens/widget/category_title.dart';
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
              Expanded(
                child: Text(
                  hint,
                  style: const TextStyle(color: Colors.black38,fontSize: 16,),
                ),
              )
            else
              Expanded(child: CategoryTitle(model: model!),),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.arrow_drop_down,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
