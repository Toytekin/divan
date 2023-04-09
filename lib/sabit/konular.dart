import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplantid/sabit/renk.dart';

// ignore: must_be_immutable
class AsKonular extends StatelessWidget {
  String label;

  Function() onTap;

  AsKonular({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: (Get.width * 0.3) / 4,
          width: Get.width * 0.4,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              border: Border.all(
                color: Renkler.sabitRenk,
                width: 1,
              ),
              color: Renkler.scafoldRenk),
          child: Center(
              child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
        ),
      ),
    );
  }
}
