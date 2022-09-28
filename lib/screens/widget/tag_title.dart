import 'package:accounting/db/category_model.dart';
import 'package:accounting/db/tag_model.dart';
import 'package:accounting/res/icons.dart';
import 'package:flutter/material.dart';

class TagTitle extends StatelessWidget {
  final TagModel model;

  const TagTitle({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: model.color,
            ),
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              model.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black45,fontSize: 16,fontFamily: 'RobotoMono',),
            ),
          )
        ],
      ),
    );
  }
}
