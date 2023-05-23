import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String name;
  final IconData? icon;
  final Color? color;
  final bool isSelected;
  final Function() onSelect;

  const CustomChip({
    Key? key,
    required this.name,
    this.icon,
    this.color,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [

            if (icon != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: color,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
              )
            else if (icon == null && color != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: color,
                ),
                width: 20,
                height: 20,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (v) {
                onSelect.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
