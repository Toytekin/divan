import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toplantid/modeller/toplanti_model.dart';
import 'package:toplantid/pdf/deneeme.dart';
import 'package:toplantid/sabit/renk.dart';
import 'package:toplantid/sayfalar/toplanti/konudetay.dart';

import '../../modeller/yenikonu.dart';

// ignore: must_be_immutable
class ToplantiDetaySayfasi extends StatefulWidget {
  ToplantiModel toplantiModel;
  ToplantiDetaySayfasi({super.key, required this.toplantiModel});

  @override
  State<ToplantiDetaySayfasi> createState() => _ToplantiDetaySayfasiState();
}

class _ToplantiDetaySayfasiState extends State<ToplantiDetaySayfasi> {
  List<YeniKonuModel> yenikonularList = [];
  List<String> gelenList = [];
  List<String> izinliList = [];
  List<String> mazeretsizList = [];
  List<String> bilinmiyorList = [];
  List<String> pdfListesi = [];

  @override
  void initState() {
    super.initState();
    yenikonularList = widget.toplantiModel.yeniKonuVeIcerik;
    yoklamaKontrol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //  actions: [widget.toplantiModel. == null?  const SizedBox(): IconButton(onPressed: () { }, icon: const Icon(Icons.check))],
          title: Text(widget.toplantiModel.toplantiKonu),
          actions: [
            IconButton(
                onPressed: () {
                  pdfYap();
                },
                icon: const Icon(Icons.picture_as_pdf))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              yoklama(),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.toplantiModel.yeniKonuVeIcerik.length,
                  itemBuilder: (context, index) {
                    var oankiveri =
                        widget.toplantiModel.yeniKonuVeIcerik[index];
                    return InkWell(
                      onTap: () {
                        Get.to(KonuDetaySayfasi(yeniKonuModel: oankiveri));
                      },
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(oankiveri.konu),
                          trailing: oankiveri.dateTime == null
                              ? null
                              : const Icon(
                                  Icons.alarm,
                                  size: 28,
                                  color: Renkler.sabitRenk,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  InkWell yoklama() {
    return InkWell(
      onTap: () {
        yoklmaGoster();
      },
      child: Card(
          elevation: 3,
          // ignore: prefer_const_literals_to_create_immutables
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 20),
                    const Text('Yoklama'),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            gelenList.length.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.green),
                          ),
                          const Text('-'),
                          Text(
                            izinliList.length.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.orange),
                          ),
                          const Text('-'),
                          Text(
                            mazeretsizList.length.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  void yoklmaGoster() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Renkler.sabitRenk,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Gelenler',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: gelenList.length,
                    itemBuilder: (context, index) {
                      return Text(
                        gelenList[index],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'İzinliler',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: izinliList.length,
                    itemBuilder: (context, index) {
                      return Text(izinliList[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Mazeretsizler',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  width: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: mazeretsizList.length,
                    itemBuilder: (context, index) {
                      return Text(mazeretsizList[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18));
                    },
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void yoklamaKontrol() {
    for (var element in widget.toplantiModel.yoklamaModel) {
      if (element.katilimDurumu == 'Geldi') {
        gelenList.add(element.kisiModel!.adSoyad);
      } else if (element.katilimDurumu == 'İzinli') {
        izinliList.add(element.kisiModel!.adSoyad);
      } else if (element.katilimDurumu == 'Mazeretsiz') {
        mazeretsizList.add(element.kisiModel!.adSoyad);
      } else {
        bilinmiyorList.add(element.kisiModel!.adSoyad);
      }
    }
  }

  void pdfYap() {
    List<String> hersey = [];
    List<bool> kk = [];

    for (var element in yenikonularList) {
      hersey.add(element.konu);
      kk.add(true);
      hersey.add(element.icerik);
      kk.add(false);
    }

    PDFyapDeneme.createpdf(hersey, kk);
  }
}
