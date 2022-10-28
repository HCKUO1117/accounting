import 'package:flutter/material.dart';

class RoundTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final double textSize;
  final int? minLine;
  final double? verticalPadding;
  final bool? enable;
  final Function(String)? onChange;

  const RoundTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.textSize = 24,
    this.minLine,
    this.verticalPadding,
    this.enable, this.onChange,
  }) : super(key: key);

  @override
  _RoundTextFieldState createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enable,
      controller: widget.controller,
      minLines: widget.minLine,
      maxLines: null,
      style: TextStyle(fontSize: widget.textSize,color: Theme.of(context).textTheme.bodyText1!.color),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
            vertical: widget.verticalPadding ?? 20, horizontal: 16),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        labelText: widget.hintText,
        border: InputBorder.none,
        floatingLabelStyle: const TextStyle(
          fontSize: 18.0,
          color: Colors.grey,
        ),
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          fontSize: widget.textSize,
          color: Colors.grey,
        ),
      ),
      onChanged: widget.onChange,
    );
  }
}
