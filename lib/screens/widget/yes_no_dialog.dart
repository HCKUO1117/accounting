import 'package:accounting/generated/l10n.dart';
import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String content;
  final VoidCallback? onTap;
  final String? confirmText;
  final String? title;
  final Widget? otherContents;
  final bool side;

  const YesNoDialog({
    Key? key,
    required this.content,
    this.onTap,
    this.confirmText,
    this.title,
    this.otherContents,
    this.side = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      title: title != null ? Text(title!) : null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: side ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(content),
          if (otherContents != null) otherContents!,
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            S.of(context).cancel,
            style: const TextStyle(color: Colors.grey),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: onTap ??
              () {
                Navigator.of(context).pop(true);
              },
          child: Text(
            confirmText ?? S.of(context).ok,
            style: const TextStyle(color: Colors.orange),
          ),
        ),
      ],
    );
  }
}
