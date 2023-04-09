import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toplantid/modeller/maliye.dart';
import 'package:toplantid/modeller/maliye_tumborc.dart';
import 'package:toplantid/sabit/renk.dart';
import 'package:toplantid/sayfalar/maliye/borclistesi.dart';
import 'package:uuid/uuid.dart';
import '../../sabit/sayilar_txtfild.dart';
import '../../sabit/textfild.dart';
import '../../services/nitification_serevis.dart';

class MaliyeSayfasi extends StatefulWidget {
  const MaliyeSayfasi({super.key});

  @override
  State<MaliyeSayfasi> createState() => _MaliyeSayfasiState();
}

class _MaliyeSayfasiState extends State<MaliyeSayfasi> {
  //
  var boxMaliye = Hive.box<MaliyeModel>("maliyeDB");
  var boxTumborclar = Hive.box<TumOdemelerMaliyeModel>("tummaliyeDB");

  List<MaliyeModel> listMaliye = [];

  //! Controller

  var ad = TextEditingController();
  var borc = TextEditingController();
  var verilenPara = TextEditingController();

  // ignore: non_constant_identifier_names
  DateTime suanki_tarih = DateTime.now();

  @override
  void initState() {
    super.initState();
    listeyeEkle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('M a l i y e',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          children: [
            sabitYazilar(),
            Container(
                height: Get.height - (Get.width / 2.4),
                width: Get.width,
                color: Colors.white,
                // ignore: unnecessary_null_comparison
                child: listMaliye.length != null
                    ? ListView.builder(
                        itemCount: listMaliye.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              ad.text = listMaliye[index].adSoyad;
                              verilenPara.text = 0.toString();
                              borc.text =
                                  listMaliye[index].toplamBorc.toString();

                              guncelle(listMaliye[index].id);
                            },
                            onLongPress: () {
                              silVeGrafikle(listMaliye[index]);
                            },
                            child: Card(
                              child: SizedBox(
                                height: 30,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(listMaliye[index].adSoyad),
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(listMaliye[index]
                                            .toplamBorc
                                            .toString()),
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(listMaliye[index]
                                            .verilenPara
                                            .toString()),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kişi Ekleme',
                          style:
                              TextStyle(fontSize: 22, color: Renkler.sabitRenk),
                        ),
                        Text(
                          tarihDegistirme(suanki_tarih),
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text('Kaydet'),
                        onPressed: () async {
                          kisiKaydet();
                        },
                      )
                    ],
                    content: alertDiyalogTextfild(),
                  ));
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  SingleChildScrollView alertDiyalogTextfild() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AsTextFild(
            textEditingController: ad,
            label: 'AD Soyad',
          ),
          const SizedBox(height: 10),
          SayiTextfild(
            textEditingController: borc,
            label: 'Tüm Borcu',
          ),
          const SizedBox(height: 10),
          SayiTextfild(
            textEditingController: verilenPara,
            label: 'Alınan Para',
          ),
        ],
      ),
    );
  }

  Container sabitYazilar() {
    return Container(
      height: Get.width / 6,
      width: Get.width,
      color: Renkler.sabitRenk,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SabitYaziText(yazi: 'Ad Soyad'),
          SabitYaziText(yazi: 'Toplam Borç'),
          SabitYaziText(yazi: 'Verilen Para')
        ],
      ),
    );
  }

  tarihDegistirme(DateTime date) {
    var tarih = DateFormat.yMMMd('tr').format(date).toString();
    return tarih;
  }

  Future<void> kisiKaydet() async {
    if (ad.text.isNotEmpty &&
        borc.text.isNotEmpty &&
        verilenPara.text.isNotEmpty) {
      var kisiid = const Uuid().v1();
      var eklenecekKisi = MaliyeModel(kisiid, double.parse(borc.text),
          double.parse(verilenPara.text), suanki_tarih, ad.text.toString());
      await boxMaliye.put(kisiid, eklenecekKisi);

      var odemeID = const Uuid().v1();
      var eklenenOdeme = TumOdemelerMaliyeModel(
          kisiid,
          odemeID,
          double.parse(verilenPara.text),
          double.parse(borc.text),
          suanki_tarih);
      await boxTumborclar.put(odemeID, eklenenOdeme);

      clear();
      listeyeEkle();
      setState(() {});
      Get.back();
    } else {
      Get.snackbar('Uyarı', 'Tüm alanların Doldurulduğuna Emin Ol');
    }
  }

  listeyeEkle() {
    listMaliye.clear();
    for (var element in boxMaliye.values) {
      listMaliye.add(element);
    }
  }

  void clear() {
    ad.clear();
    verilenPara.clear();
    borc.clear();
  }

  void guncelle(String id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Guncelleme',
                    style: TextStyle(fontSize: 22, color: Renkler.sabitRenk),
                  ),
                  Text(
                    tarihDegistirme(suanki_tarih),
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Kaydet'),
                  onPressed: () async {
                    kisiGuncelle(id);
                  },
                )
              ],
              content: guncellalertDiyalogTextfild(),
            ));
  }

  SingleChildScrollView guncellalertDiyalogTextfild() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AsTextFild(
            textEditingController: ad,
            label: 'AD Soyad',
          ),
          const SizedBox(height: 10),
          SayiTextfild(
            textEditingController: borc,
            label: 'Tüm Borcu',
          ),
          const SizedBox(height: 10),
          SayiTextfild(
            textEditingController: verilenPara,
            label: 'Alınan Para',
          ),
        ],
      ),
    );
  }

  Future<void> kisiGuncelle(String id) async {
    if (ad.text.isNotEmpty &&
        borc.text.isNotEmpty &&
        verilenPara.text.isNotEmpty) {
      double kalanborc = double.parse(borc.text) - int.parse(verilenPara.text);
      var eklenecekKisi = MaliyeModel(id, kalanborc,
          double.parse(verilenPara.text), suanki_tarih, ad.text.toString());
      boxMaliye.put(id, eklenecekKisi);

      var odemeID = const Uuid().v1();
      var eklenenOdeme = TumOdemelerMaliyeModel(
          id, odemeID, double.parse(verilenPara.text), kalanborc, suanki_tarih);
      await boxTumborclar.put(odemeID, eklenenOdeme);

      clear();
      listeyeEkle();
      setState(() {});
      Get.back();
    } else {
      Get.snackbar('Uyarı', 'Tüm alanların Doldurulduğuna Emin Ol');
    }
  }

  void silVeGrafikle(MaliyeModel gelenKisi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(gelenKisi.adSoyad),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Sil'),
              onPressed: () async {
                boxMaliye.delete(gelenKisi.id);
                listeyeEkle();
                setState(() {});
                Get.back();
              },
            ),
            ElevatedButton(
              child: const Text('Tüm Ödemeler'),
              onPressed: () async {
                Get.to(TumBorclar(kisiID: gelenKisi.id));
              },
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotti/grafik.json',
                width: Get.size.width * 0.6,
                height: Get.size.width * 0.6,
              ),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class SabitYaziText extends StatelessWidget {
  String yazi;

  SabitYaziText({super.key, required this.yazi});
  @override
  Widget build(BuildContext context) {
    return Text(
      yazi,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
