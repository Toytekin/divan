// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:toplantid/modeller/grup_model.dart';
import 'package:toplantid/modeller/maliye.dart';
import 'package:toplantid/modeller/toplanti_model.dart';
import 'package:toplantid/sabit/renk.dart';
import 'package:toplantid/sayfalar/anasayfa.dart';
import 'package:toplantid/sayfalar/teskilat_ayarlar.dart';
import 'package:toplantid/sayfalar/toplanti/toplanti_detay.dart';
import 'package:toplantid/sayfalar/toplanti/toplanti_ekle.dart';

import '../modeller/kisi_model.dart';

// ignore: must_be_immutable
class TeskilatToplantilar extends StatefulWidget {
  GrupModel grupModel;
  TeskilatToplantilar({super.key, required this.grupModel});

  @override
  State<TeskilatToplantilar> createState() => _TeskilatToplantilarState();
}

class _TeskilatToplantilarState extends State<TeskilatToplantilar> {
  //? ----------------> BOX lar
  var boxTeskilat = Hive.box<GrupModel>("grupDB");
  var boxKisiler = Hive.box<KisiModel>("kisiDB");
  var boxToplantilar = Hive.box<ToplantiModel>("toplantiDB");

  List<GrupModel> teskilatListem = [];
  List<KisiModel> listem = [];
  List<ToplantiModel> listToplanti = [];
  List<MaliyeModel> listMaliye = [];

  //? ----------------> Değişkenler

  //

  @override
  void initState() {
    super.initState();
    for (var element in boxToplantilar.values) {
      if (element.mahalleID == widget.grupModel.id) {
        listToplanti.add(element);
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarim(),
      // ignore: unnecessary_null_comparison
      body: listToplanti.isEmpty
          ? lotti()
          : ListView.builder(
              itemCount: listToplanti.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(ToplantiDetaySayfasi(
                        toplantiModel: listToplanti[index]));
                  },
                  child: Card(
                    color: Renkler.scafoldRenk,
                    elevation: 2,
                    child: ListTile(
                      title: Text(listToplanti[index].toplantiKonu),
                      trailing: Text(listToplanti[index].tarih),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ToplantiEkleSayfasi(
            teskilatID: widget.grupModel.id,
          ));
        },
        backgroundColor: Renkler.sabitRenk,
        child: const Icon(Icons.add),
      ),
    );
  }

  Center lotti() {
    return Center(
      child: Lottie.asset(
        'assets/lotti/emty.json',
        width: Get.size.width * 0.6,
        height: Get.size.width * 0.6,
      ),
    );
  }

  AppBar appbarim() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.grupModel.grupAdi.toString()),
      leading: IconButton(
          onPressed: () {
            Get.to(const AnaSayfa());
          },
          icon: const Icon(Icons.arrow_back)),
      actions: [
        IconButton(
            onPressed: () {
              Get.to(TeskilatAyarlar(grupModel: widget.grupModel));
            },
            icon: const Icon(Icons.settings)),
      ],
    );
  }
}
