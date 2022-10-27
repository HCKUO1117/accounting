import 'package:accounting/generated/l10n.dart';
import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String content;
  final VoidCallback? onTap;
  final String? confirmText;
  final String? title;

  const YesNoDialog({
    Key? key,
    required this.content,
    this.onTap,
    this.confirmText, this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      title: title != null ? Text(title!) : null,
      content: Text(content),
      actions: [
        TextButton(
          child: Text(S.of(context).cancel,style: Theme.of(context).textTheme.button,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: onTap ??
              () {
                Navigator.of(context).pop(true);
              },
          child: Text(confirmText ?? S.of(context).ok,style: Theme.of(context).textTheme.button,),
        ),
      ],
    );
  }
}
