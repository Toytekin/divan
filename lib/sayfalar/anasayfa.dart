import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toplantid/modeller/note_model.dart';
import 'package:toplantid/modeller/toplanti_model.dart';
import 'package:toplantid/modeller/yenikonu.dart';
import 'package:toplantid/sabit/decoration.dart';
import 'package:toplantid/sayfalar/te%C5%9Fkilat_ekleme.dart';
import 'package:toplantid/sayfalar/teskilat_toplantilar.dart';
import 'package:toplantid/sayfalar/toplanti/toplanti_detay.dart';
import '../modeller/grup_model.dart';
import '../modeller/kisi_model.dart';
import '../sabit/renk.dart';
import '../sabit/textfild.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'maliye/maliye.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
// Controller
  var adSoyadController = TextEditingController();
  var telefonController = TextEditingController();
  var gorevController = TextEditingController();
  var noteBaslikController = TextEditingController();
  var noteDetayController = TextEditingController();
  //
  final String _titleAppBar1 = '   D İ V A N';
  final String _titleAppBar2 = 'Hatırlatıcı Kurdukların';

  var boxTeskilat = Hive.box<GrupModel>("grupDB");
  var boxKisiler = Hive.box<KisiModel>("kisiDB");
  var boxToplanti = Hive.box<ToplantiModel>("toplantiDB");

  List<GrupModel> teskilatListem = [];
  List<KisiModel> listem = [];
  List<YeniKonuModel> listAlarmlilar = [];

  final String _defaultImage = 'assets/image/ron.png';

  // Notların değişkenleri
  var boxNotlar = Hive.box<NoteModel>("noteDB");

  List<NoteModel> noteList = [];

  bool detayGosterGizle = true;

  // Tarih seçici
  // ignore: non_constant_identifier_names
  DateTime suanki_tarih = DateTime.now();

  DateTime tarih = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tarih,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != tarih) {
      setState(() {
        tarih = picked;
      });
    }
  }

  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    for (var element in boxTeskilat.values) {
      teskilatListem.add(element);
    }
    for (var element in boxKisiler.values) {
      listem.add(element);
    }

    notlariGetir();
    toplantiariGetir();
  }

  notlariGetir() {
    // noteList.clear();
    for (var not in boxNotlar.values) {
      noteList.add(not);
    }
  }

  toplantiariGetir() {
    for (var top in boxToplanti.values) {
      for (var element in top.yeniKonuVeIcerik) {
        if (element.dateTime != null) {
          listAlarmlilar.add(element);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Scaffold(
      appBar: AppBar(
        actions: [
          _currentIndex == 0
              ? IconButton(
                  onPressed: () {
                    Get.to(const MaliyeSayfasi());
                  },
                  icon: const Icon(Icons.attach_money))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      detayGosterGizle = !detayGosterGizle;
                    });
                  },
                  icon: detayGosterGizle
                      ? Icon(
                          Icons.list,
                          size: Get.size.width / 12,
                        )
                      : const Icon(Icons.arrow_downward))
        ],
        automaticallyImplyLeading: false,
        title: _currentIndex == 0
            ? Text(
                _titleAppBar1,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              )
            : Text(_titleAppBar2),
      ),
      // ignore: unnecessary_null_comparison
      body: _currentIndex == 0
          ? teskilatListem.isEmpty
              ? ListeBosLotti()
              : TeskilatListesi()
          : listAlarmlilar.isEmpty
              ? KisilerBos()
              : KisilerListesi(),
      floatingActionButton: _currentIndex == 0 ? floatingBtoom() : null,
      bottomNavigationBar: bottomappbar(),
    );
  }

  BottomNavyBar bottomappbar() {
    return BottomNavyBar(
      backgroundColor: Renkler.scafoldRenk,
      selectedIndex: _currentIndex,
      showElevation: false,
      itemCornerRadius: 5,
      curve: Curves.fastLinearToSlowEaseIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.home),
          title: const Text('Teşkilatlar'),
          activeColor: Renkler.sabitRenk,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.warning),
          title: const Text('UNUTMA'),
          activeColor: Renkler.sabitRenk,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  FloatingActionButton floatingBtoom() {
    return FloatingActionButton(
      onPressed: () {
        if (_currentIndex == 0) {
          Get.to(const TeskilatEklemeSayfasi());
        } else {
          null;
        }
      },
      backgroundColor: Renkler.sabitRenk,
      child: _currentIndex == 0
          ? const Icon(Icons.add)
          : const Icon(Icons.note_add),
    );
  }

  // ignore: non_constant_identifier_names
  ListView KisilerListesi() {
    return ListView.builder(
      itemCount: listAlarmlilar.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 3),
          decoration: zamanKarsilastirma(suanki_tarih,
                  listAlarmlilar[index].dateTime!, listAlarmlilar[index])
              ? RedDecor.redDekor
              : GreenDekor.greenDekor,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                //! **********************************
                listAlarmlilar[index].konu,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            trailing: listAlarmlilar[index].dateTime == null
                ? null
                : !detayGosterGizle
                    ? Text(
                        tarihAraligi(
                                suanki_tarih, listAlarmlilar[index].dateTime!)
                            .toString(),
                        // tarihDegistirme(listAlarmlilar[index].dateTime!),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      )
                    : Text(
                        tarihDegistirme(listAlarmlilar[index].dateTime!),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
            subtitle: detayGosterGizle
                ? Text(
                    listAlarmlilar[index].icerik,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 221, 221, 221)),
                  )
                : null,
            onTap: () {
              toplantiyaGit(listAlarmlilar[index]);
            },
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Center KisilerBos() {
    return const Center(
      child: Text('Hatırlatıcı Kurduğun Bir Toplantı Bulamadım'),
    );
  }

  // ignore: non_constant_identifier_names
  ListView TeskilatListesi() {
    return ListView.builder(
      itemCount: teskilatListem.length,
      itemBuilder: (context, index) {
        String? gelenresim = teskilatListem[index].url;

        return InkWell(
          onTap: () {
            Get.to(TeskilatToplantilar(grupModel: teskilatListem[index]));
          },
          child: Card(
            color: Renkler.scafoldRenk,
            elevation: 0,
            child: ListTile(
              title: Text(
                teskilatListem[index].grupAdi,
              ),
              leading: CircularProfileAvatar(
                '',
                backgroundColor: Renkler.scafoldRenk,
                radius: 30,
                child: gelenresim != null
                    ? Image.file(
                        File(
                          gelenresim,
                        ),
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        _defaultImage,
                        fit: BoxFit.fitHeight,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Center ListeBosLotti() {
    return Center(
      child: Lottie.asset(
        'assets/lotti/emty.json',
        width: Get.size.width * 0.6,
        height: Get.size.width * 0.6,
      ),
    );
  }

  void clearController() {
    adSoyadController.clear();
    telefonController.clear();
    gorevController.clear();
  }

  SingleChildScrollView alertDiyalogTextfild() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AsTextFild(
              textEditingController: noteBaslikController, label: 'Başlık'),
          const SizedBox(height: 10),
          AsTextFild(
            textEditingController: noteDetayController,
            label: 'Not',
            minLines: 8,
            maxLines: 10,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  _selectDate(context);
                },
                icon: const Icon(Icons.date_range),
              ),
            ],
          )
        ],
      ),
    );
  }

  bool zamanKarsilastirma(
      DateTime simdikiZaman, DateTime noteZaman, YeniKonuModel yeniKonuModel) {
    return simdikiZaman.year > noteZaman.year ||
        simdikiZaman.month > noteZaman.month ||
        simdikiZaman.day > noteZaman.day ||
        simdikiZaman.year == noteZaman.year &&
            simdikiZaman.month == noteZaman.month &&
            simdikiZaman.day == noteZaman.day ||
        yeniKonuModel.gorevYapildimi == false;
  }

  tarihDegistirme(DateTime dateTime) {
    var tarih = DateFormat.yMMMd('tr').format(dateTime).toString();
    return tarih;
  }

  toplantiyaGit(YeniKonuModel yeniKonuModel) {
    for (var element in boxToplanti.values) {
      if (element.id == yeniKonuModel.mahalleID) {
        Get.to(ToplantiDetaySayfasi(toplantiModel: element));
      }
    }
  }

  int tarihAraligi(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
