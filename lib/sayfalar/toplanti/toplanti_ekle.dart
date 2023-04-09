import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:toplantid/modeller/kisi_model.dart';
import 'package:toplantid/modeller/toplanti_model.dart';
import 'package:toplantid/modeller/yenikonu.dart';
import 'package:toplantid/modeller/yoklama_model.dart';
import 'package:toplantid/sabit/byk_textfild.dart';
import 'package:toplantid/sabit/icerik_textfild.dart';
import 'package:toplantid/sabit/textfild.dart';
import 'package:toplantid/sayfalar/anasayfa.dart';
import 'package:uuid/uuid.dart';
import '../../modeller/grup_model.dart';
import '../../sabit/renk.dart';

// ignore: must_be_immutable
class ToplantiEkleSayfasi extends StatefulWidget {
  String teskilatID;
  ToplantiEkleSayfasi({super.key, required this.teskilatID});

  @override
  State<ToplantiEkleSayfasi> createState() => _ToplantiEkleSayfasiState();
}

class _ToplantiEkleSayfasiState extends State<ToplantiEkleSayfasi> {
//? Box
  var boxTeskilat = Hive.box<GrupModel>("grupDB");
  var boxToplantilar = Hive.box<ToplantiModel>("toplantiDB");
  var boxYoklama = Hive.box<YoklamaModel>("yoklamaDB");

  var anaKonuController = TextEditingController();
  List<ToplantiModel> listToplantiModel = [];
  List<YeniKonuModel> listYeniKonu = [];
  List<YoklamaModel> listYoklama = [];
  List<KisiModel> listKisiler = [];
  List<bool> listBool = [];
  List<bool> checkboxValue = [];
  // Toplantı modellerinde toplantılar olacak
  // Toplantımodellerin içerisinde bulunan List<YeniKonuModel>
  // içerisinde de eklenen yeni konular bulunacak.

  //Controller
  var konu = TextEditingController();
  var icerik = TextEditingController();

  late String toplantiID = const Uuid().v1();

  int degisken = 0;
  bool yoklamaKartbool = false;

  // Swith
  bool _switch = false;

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

//G,İ,M,B
  @override
  void initState() {
    super.initState();
    _switch = false;
    for (var element in boxToplantilar.values) {
      if (element.mahalleID == widget.teskilatID) {
        listToplantiModel.add(element);
      } else {}
    }
    for (var element in boxTeskilat.values) {
      if (element.id == widget.teskilatID) {
        listKisiler = element.kisimodel;
      } else {}
    }
    yoklanacaklar();
  }

  kisilerInitState() {
    for (var element in boxTeskilat.values) {
      if (element.id == widget.teskilatID) {
        listKisiler = element.kisimodel;
      }
    }
  }

  yoklanacaklar() async {
    kisilerInitState();
    for (var kisiler in listKisiler) {
      var id = const Uuid().v1();

      var guncelleme = YoklamaModel(
          id: id,
          teskilatID: widget.teskilatID,
          toplantiID: toplantiID,
          katilimDurumu: 'Geldi',
          kisiModel: kisiler);
      listYoklama.add(guncelleme);
    }
  }

  arttirma() {
    if (degisken < 3) {
      degisken = degisken + 1;
    } else {
      degisken = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return Scaffold(
      appBar: appbar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnaKonular(context),
              KonularList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: const Text(
                        'Konu Ekleme',
                        style:
                            TextStyle(fontSize: 22, color: Renkler.sabitRenk),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text('Vazgeç'),
                          onPressed: () {
                            Get.back();
                            _switch = false;
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Kaydet'),
                          onPressed: () async {
                            if (_switch == false) {
                              konuKaydet();
                            } else {
                              hatirlaticilikonuKaydet(tarih);
                              _switch = false;
                            }
                          },
                        ),
                      ],
                      content: Column(
                        children: [
                          AsTextFild(
                              textEditingController: konu, label: 'Konu'),
                          AsTextFildIcerik(
                              textEditingController: icerik, label: 'İçerik'),
                          hatirlaticiSayfasi(setState)
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        backgroundColor: Renkler.sabitRenk,
        child: const Icon(Icons.add),
      ),
    );
  }

  Row hatirlaticiSayfasi(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Hatırlatıcı Kur'),
        Switch(
            value: _switch,
            onChanged: (value) {
              setState(() {
                _switch = value;

                _switch == true ? _selectDate(context) : null;
              });
            })
      ],
    );
  }

  // ignore: non_constant_identifier_names
  SingleChildScrollView AnaKonular(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          BykTextFild(textEditingController: anaKonuController, label: 'Konu'),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Yoklama(context)],
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  TextButton Yoklama(BuildContext context) {
    return TextButton.icon(
        onPressed: () {
          //  debugPrint(DateFormat.yMMMd('tr').format(DateTime.now()));
          // Get.to(YoklamaSayfasi(
          //   toplatiID: toplantiID,
          //   teskilatID: widget.teskilatID,
          // ));
          yoklamaDiyalog();
        },
        icon: const Icon(Icons.person),
        label: const Text('Yoklama'));
  }

  Future<dynamic> yoklamaKisiler(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: ListView.builder(
                  itemCount: listYoklama.length,
                  itemBuilder: (context, index) {
                    checkboxValue = List<bool>.generate(
                        listKisiler.length, (counter) => false);

                    return Card(
                        elevation: 5,
                        child: ListTile(
                          title: Text(listYoklama[index].kisiModel!.adSoyad),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CheckboxListTile(
                                  value: checkboxValue[index], //add this
                                  onChanged: (newValue) {})
                            ],
                          ),
                        ));
                  },
                ),
              );
            },
          );
        });
  }

  // ignore: non_constant_identifier_names
  Expanded KonularList() {
    return Expanded(
      flex: 3,
      child: SizedBox(
        child: listYeniKonu.isEmpty
            ? const SizedBox()
            : ListView.builder(
                itemCount: listYeniKonu.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    color: Renkler.sabitRenk,
                    child: ListTile(
                      onLongPress: () {
                        konu.text = listYeniKonu[index].konu;
                        icerik.text = listYeniKonu[index].icerik;

                        duzenle(listYeniKonu[index], index);
                        //yeniKonuDuzenle(listYeniKonu[index], index);
                      },
                      title: Text(
                        listYeniKonu[index].konu,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: listYeniKonu[index].dateTime == null
                          ? null
                          : const Icon(
                              Icons.alarm,
                              size: 28,
                              color: Colors.white,
                            ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text(
                        'Kaydedilmeden devam edilsin mi?',
                        style:
                            TextStyle(fontSize: 22, color: Renkler.sabitRenk),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text('Evet'),
                          onPressed: () async {
                            // ignore: use_build_context_synchronously
                            Get.to(const AnaSayfa());
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Hayır'),
                          onPressed: () async {
                            Get.back();
                          },
                        )
                      ],
                    ));
          },
          icon: const Icon(Icons.arrow_back)),
      automaticallyImplyLeading: false,
      title: const Text('Toplantı Ekleme'),
      actions: [
        IconButton(
            onPressed: () {
              if (anaKonuController.text.isNotEmpty && listYoklama.isNotEmpty) {
                kaydedilsinmi();
              } else {
                Get.snackbar('Uyarı', 'Lütfen Ana Konu başlığını gir');
              }
            },
            icon: const Icon(
              Icons.save,
              color: Color.fromARGB(255, 103, 236, 108),
              size: 28,
            ))
      ],
    );
  }

  void konuKaydet() {
    if (konu.text.isNotEmpty && icerik.text.isNotEmpty) {
      String konuId = const Uuid().v1();
      var eklenecekKonu = YeniKonuModel(
          gorevYapildimi: false,
          mahalleID: toplantiID,
          id: konuId,
          konu: konu.text.toString(),
          icerik: icerik.text.toString());
      listYeniKonu.add(eklenecekKonu);
      Get.back();
      konu.clear();
      icerik.clear();
      setState(() {});
      debugPrint('Direk kayıt yapıldı');
    } else {
      Get.snackbar('Uyarı', 'Tüm Alanların Dolu Olduğuna Emin ol !');
    }
  }

  void hatirlaticilikonuKaydet(DateTime dateTime) {
    if (konu.text.isNotEmpty && icerik.text.isNotEmpty) {
      String konuId = const Uuid().v1();
      var eklenecekKonu = YeniKonuModel(
          gorevYapildimi: true,
          dateTime: dateTime,
          mahalleID: toplantiID,
          id: konuId,
          konu: konu.text.toString(),
          icerik: icerik.text.toString());
      listYeniKonu.add(eklenecekKonu);
      Get.back();
      konu.clear();
      icerik.clear();
      setState(() {});
      debugPrint('HATIRLATMA kayıt yapıldı');
    } else {
      Get.snackbar('Uyarı', 'Tüm Alanların Dolu Olduğuna Emin ol !');
    }
  }

  Future<void> toplantiyiKaydetme() async {
    String tarih = DateFormat.yMMMd('tr').format(DateTime.now()).toString();
    var toplati = ToplantiModel(toplantiID, anaKonuController.text.toString(),
        listYoklama, listYeniKonu, widget.teskilatID, tarih);
    await boxToplantilar.put(toplantiID, toplati);
  }

  Future<void> yoklamaAlma(YoklamaModel yoklamaModel) async {
    String katilimDurumu = 'Geldi';
    arttirma();
    switch (degisken) {
      case 0:
        katilimDurumu = 'Geldi';
        yoklamaKartbool = false;

        break;
      case 1:
        katilimDurumu = 'İzinli';
        yoklamaKartbool = false;

        break;
      case 2:
        katilimDurumu = 'Mazeretsiz';
        yoklamaKartbool = true;

        break;

      default:
    }

    var guncelleme = YoklamaModel(
        id: yoklamaModel.id,
        teskilatID: yoklamaModel.teskilatID,
        toplantiID: yoklamaModel.toplantiID,
        katilimDurumu: katilimDurumu,
        kisiModel: yoklamaModel.kisiModel);

    listYoklama[listYoklama
        .indexWhere((element) => element.id == guncelleme.id)] = guncelleme;
  }

  void yoklamaDiyalog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 300.0, // Change as per your requirement
            width: 300.0,
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return ListView.builder(
                  itemCount: listYoklama.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: listYoklama[index].katilimDurumu.toString() !=
                              'Mazeretsiz'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          yoklamaAlma(listYoklama[index]);
                          setState(() {});
                        },
                        title: Text(listYoklama[index].kisiModel!.adSoyad),
                        trailing:
                            Text(listYoklama[index].katilimDurumu.toString()),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void kaydedilsinmi() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          iconColor: Colors.red,
          icon: Icon(
            Icons.warning,
            size: Get.height / 10,
          ),
          actions: [
            ElevatedButton(
              child: const Text('Vazgeç'),
              onPressed: () {
                Get.back();
              },
            ),
            ElevatedButton(
              child: const Text('Kaydet'),
              onPressed: () {
                toplantiyiKaydetme();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const AnaSayfa(),
                    ),
                    (route) => false);
              },
            )
          ],
          title: const Text('Uyarı'),
          content: const Text(
              'Kaydettikden sonra güncelleme yapamayacaksın. Kaydedilsin mi?'),
        );
      },
    );
  }

  void yeniKonuDuzenle(YeniKonuModel yeniKonuModel, int index) {
    if (konu.text.isNotEmpty && icerik.text.isNotEmpty) {
      listYeniKonu.removeAt(index);

      var guncelleme = YeniKonuModel(
          gorevYapildimi: false,
          mahalleID: toplantiID,
          id: yeniKonuModel.id,
          konu: konu.text,
          icerik: icerik.text);
      listYeniKonu.add(guncelleme);
      Get.back();
      konu.clear();
      icerik.clear();

      setState(() {});
    } else {
      Get.snackbar(
          'Dikkat ', 'Tüm doldurduğuna emin olduktan sonra tekrar dene.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(milliseconds: 2000),
          colorText: Renkler.sabitRenk,
          backgroundColor: Renkler.scafoldRenk);
    }
  }

  void duzenle(YeniKonuModel yeniKonuModel, int index) {
    showDialog(
        context: context,
        builder: (context) => ListView(
              children: [
                AlertDialog(
                  title: const Text(
                    'Konu Ekleme',
                    style: TextStyle(fontSize: 22, color: Renkler.sabitRenk),
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text('Vazgeç'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Kaydet'),
                      onPressed: () async {
                        yeniKonuDuzenle(yeniKonuModel, index);
                      },
                    ),
                  ],
                  content: Column(
                    children: [
                      AsTextFild(textEditingController: konu, label: 'Konu'),
                      AsTextFildIcerik(
                          textEditingController: icerik, label: 'İçerik'),
                    ],
                  ),
                )
              ],
            ));
  }

  bool zamanKarsilastirma(DateTime simdikiZaman, DateTime noteZaman) {
    return simdikiZaman.year > noteZaman.year ||
        simdikiZaman.month > noteZaman.month ||
        simdikiZaman.day > noteZaman.day ||
        simdikiZaman.year == noteZaman.year &&
            simdikiZaman.month == noteZaman.month &&
            simdikiZaman.day == noteZaman.day;
  }

  tarihDegistirme(DateTime date) {
    var tarih = DateFormat.yMMMd('tr').format(date).toString();
    return tarih;
  }

//
}
