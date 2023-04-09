import 'package:flutter/material.dart';
import 'package:toplantid/sabit/renk.dart';

// ignore: must_be_immutable
class AsTextFildIcerik extends StatelessWidget {
  TextEditingController textEditingController;
  String label;
  Color borderColors;

  AsTextFildIcerik(
      {super.key,
      required this.textEditingController,
      required this.label,
      this.borderColors = Renkler.sabitRenk});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        minLines: 8,
        maxLines: 10,
        controller: textEditingController,
        decoration: InputDecoration(
          label: Text(label),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: borderColors)),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: borderColors)),
        ),
      ),
    );
  }
}
