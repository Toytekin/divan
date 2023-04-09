import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:toplantid/sabit/renk.dart';
import 'package:toplantid/sayfalar/anasayfa.dart';

import '../../modeller/grup_model.dart';
import '../../modeller/toplanti_model.dart';
import '../../modeller/yenikonu.dart';
import '../../modeller/yoklama_model.dart';

// ignore: must_be_immutable
class KonuDetaySayfasi extends StatefulWidget {
  YeniKonuModel yeniKonuModel;
  KonuDetaySayfasi({super.key, required this.yeniKonuModel});

  @override
  State<KonuDetaySayfasi> createState() => _KonuDetaySayfasiState();
}

class _KonuDetaySayfasiState extends State<KonuDetaySayfasi> {
  //? Box
  var boxTeskilat = Hive.box<GrupModel>("grupDB");
  var boxToplantilar = Hive.box<ToplantiModel>("toplantiDB");
  var boxYoklama = Hive.box<YoklamaModel>("yoklamaDB");
  bool _check = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.yeniKonuModel.dateTime == null
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _check = !_check;
                      gorevYapildi();
                    });
                  },
                  icon: _check
                      ? Icon(
                          Icons.check_box,
                          size: Get.size.width / 13,
                        )
                      : Icon(
                          Icons.check_box,
                          size: Get.size.width / 13,
                          color: Colors.green,
                        ),
                )
        ],
        title: Text(widget.yeniKonuModel.konu),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.yeniKonuModel.dateTime != null
                    ? Text(
                        tarihDegistirme(
                          widget.yeniKonuModel.dateTime!,
                        ),
                        style: const TextStyle(
                            fontSize: 22, color: Renkler.sabitRenk),
                      )
                    : null,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.yeniKonuModel.icerik,
              style: const TextStyle(fontSize: 22),
            ),
          )
        ],
      ),
    );
  }

  tarihDegistirme(DateTime date) {
    var tarih = DateFormat.yMMMd('tr').format(date).toString();
    return tarih;
  }

  void gorevYapildi() {
    for (var toplanti in boxToplantilar.values) {
      for (var yeniKonu in toplanti.yeniKonuVeIcerik) {
        if (yeniKonu.id == widget.yeniKonuModel.id) {
          var db = widget.yeniKonuModel;
          var eklenecek = YeniKonuModel(
            id: db.id,
            konu: db.konu,
            icerik: db.icerik,
            mahalleID: db.mahalleID,
            gorevYapildimi: false,
          );

          toplanti.yeniKonuVeIcerik[toplanti.yeniKonuVeIcerik
              .indexWhere((element) => element.id == eklenecek.id)] = eklenecek;
          var guncelleme = ToplantiModel(
            toplanti.id,
            toplanti.toplantiKonu,
            toplanti.yoklamaModel,
            toplanti.yeniKonuVeIcerik,
            toplanti.mahalleID,
            toplanti.tarih,
          );

          boxToplantilar.put(toplanti.id, guncelleme);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AnaSayfa(),
              ),
              (route) => false);
        }
      }
    }
  }
}


//! ******************************* BUNLARI UNUTMA**************************************
// *********************
//********** SAĞ ÜST KISIMDA BULUNAN BUTONA TIKLAYINCA  DATETİME SIFIRLA *************************************
