import 'package:flutter/material.dart';
import 'package:toplantid/sabit/renk.dart';

// ignore: must_be_immutable
class AsTextFild extends StatelessWidget {
  TextEditingController textEditingController;
  String label;
  Color borderColors;
  int minLines;
  int maxLines;

  AsTextFild(
      {super.key,
      required this.textEditingController,
      required this.label,
      this.borderColors = Renkler.sabitRenk,
      this.minLines = 2,
      this.maxLines = 4});

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: minLines,
      maxLines: maxLines,
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(label),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: borderColors)),
        border: OutlineInputBorder(borderSide: BorderSide(color: borderColors)),
      ),
    );
  }
}
