import 'package:flutter/material.dart';

class IncomeCategoryPage extends StatefulWidget {
  final String tag;

  const IncomeCategoryPage({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  State<IncomeCategoryPage> createState() => _IncomeCategoryPageState();
}

class _IncomeCategoryPageState extends State<IncomeCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tag,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
      ),
    );
  }
}
