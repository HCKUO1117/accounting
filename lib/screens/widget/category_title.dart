import 'package:accounting/db/category_model.dart';
import 'package:accounting/res/icons.dart';
import 'package:flutter/material.dart';

class CategoryTitle extends StatelessWidget {
  final CategoryModel model;

  const CategoryTitle({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: model.iconColor,
            ),
            child: Icon(
              icons[model.icon],
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              model.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black45),
            ),
          )
        ],
      ),
    );
  }
}
