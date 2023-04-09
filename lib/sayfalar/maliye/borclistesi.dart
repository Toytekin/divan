import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:toplantid/modeller/maliye_tumborc.dart';
import 'package:toplantid/sabit/renk.dart';
import 'package:toplantid/sayfalar/maliye/grafik.dart';
import 'package:toplantid/sayfalar/maliye/maliye.dart';

// ignore: must_be_immutable
class TumBorclar extends StatefulWidget {
  String kisiID;
  TumBorclar({super.key, required this.kisiID});

  @override
  State<TumBorclar> createState() => _TumBorclarState();
}

class _TumBorclarState extends State<TumBorclar> {
  List<TumOdemelerMaliyeModel> listTumodemeler = [];
  List<double> odemelerDouble = [];
  List<DateTime> odemelerDoubleTarih = [];

  Map<DateTime, double> veriler = {};

  var boxTumborclar = Hive.box<TumOdemelerMaliyeModel>("tummaliyeDB");

  @override
  void initState() {
    super.initState();
    for (var element in boxTumborclar.values) {
      if (element.kisiID == widget.kisiID) {
        listTumodemeler.add(element);
        odemelerDouble.add(element.verilenPara);
        odemelerDoubleTarih.add(element.dateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
          child: Column(
            children: [
              sabityazilar(),
              Expanded(
                child: ListView.builder(
                  itemCount: listTumodemeler.length,
                  itemBuilder: (context, index) {
                    var veri = listTumodemeler[index];
                    return Card(
                      color: borcDurum(veri)
                          ? Colors.green
                          : const Color.fromARGB(111, 244, 67, 54),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(tarihDegistirme(veri.dateTime)),
                          Text(veri.kalanPara.toString()),
                          Text(veri.verilenPara.toString()),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  tarihDegistirme(DateTime date) {
    var tarih = DateFormat.yMMMd('tr').format(date).toString();
    return tarih;
  }

  bool borcDurum(TumOdemelerMaliyeModel tumOdemelerMaliyeModel) {
    if (tumOdemelerMaliyeModel.kalanPara < 0) {
      return true;
    } else {
      return false;
    }
  }

  Container sabityazilar() {
    return Container(
      color: Renkler.sabitRenk,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SabitYaziText(yazi: 'TARİH'),
            SabitYaziText(yazi: 'KALAN BORÇ'),
            SabitYaziText(yazi: 'ALINAN PARA'),
          ],
        ),
      ),
    );
  }
}
