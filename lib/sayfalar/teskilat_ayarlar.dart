import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:toplantid/modeller/grup_model.dart';
import 'package:toplantid/sayfalar/teskilat_toplantilar.dart';
import '../modeller/kisi_model.dart';
import '../sabit/renk.dart';
import '../sabit/textfild.dart';
import 'anasayfa.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class TeskilatAyarlar extends StatefulWidget {
  GrupModel grupModel;
  TeskilatAyarlar({super.key, required this.grupModel});

  @override
  State<TeskilatAyarlar> createState() => _TeskilatAyarlarState();
}

class _TeskilatAyarlarState extends State<TeskilatAyarlar> {
  //? Controller
  var adSoyadController = TextEditingController();
  var telefonController = TextEditingController();
  var gorevController = TextEditingController();
  //? IMAGEPİCER DEĞİŞKENLERİ
  final ImagePicker _picker = ImagePicker();
  String? resimDosyasi;
  String? _resimYolu;
  final String _defaultImage = 'assets/image/ron.png';

  //? DEĞİŞKENLER
  var mahalleAdiController = TextEditingController();

  //? Box
  var boxTeskilat = Hive.box<GrupModel>("grupDB");
  var boxKisiler = Hive.box<KisiModel>("kisiDB");
  List<KisiModel> listem = [];
  List<GrupModel> teskilatListem = [];

  late GrupModel grupModel;

  @override
  void initState() {
    super.initState();
    listem = widget.grupModel.kisimodel;
    mahalleAdiController.text = widget.grupModel.grupAdi;
    for (var element in boxTeskilat.values) {
      teskilatListem.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
                              Get.to(TeskilatToplantilar(
                                  grupModel: widget.grupModel));
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
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            '${widget.grupModel.grupAdi} silinsin mi?',
                            style: const TextStyle(
                                fontSize: 22, color: Renkler.sabitRenk),
                          ),
                          actions: [
                            ElevatedButton(
                              child: const Text('SİL'),
                              onPressed: () async {
                                await boxTeskilat.delete(widget.grupModel.id);
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const AnaSayfa(),
                                    ),
                                    (route) => false);
                              },
                            ),
                            ElevatedButton(
                              child: const Text('VAZGEÇ'),
                              onPressed: () async {
                                Get.back();
                              },
                            )
                          ],
                        ));
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {
                kaydetmeIslemi();
              },
              icon: const Icon(Icons.save))
        ],
        title: Text(widget.grupModel.grupAdi),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          //! RESİM
          SizedBox(
            height: Get.height / 6,
            child: row(context),
          ),
          if (listem.isEmpty) lotti() else Listem()
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text(
                        'Kişi Ekleme',
                        style:
                            TextStyle(fontSize: 22, color: Renkler.sabitRenk),
                      ),
                      actions: [
                        ElevatedButton(
                          child: const Text('Kaydet'),
                          onPressed: () async {
                            await kisiEkleme();
                          },
                        )
                      ],
                      content: alertDiyalogTextfild(),
                    ));
          },
          backgroundColor: Renkler.sabitRenk,
          child: const Icon(Icons.person_add)),
    );
  }

  Row row(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            PickedFile? image =
                await _picker.getImage(source: ImageSource.gallery);

            setState(() {
              resimDosyasi = image?.path;
              _resimYolu = image?.path;
              debugPrint(_resimYolu);
            });
          },
          child: CircularProfileAvatar('',
              elevation: 5,
              backgroundColor: Colors.transparent,
              borderColor: Renkler.sabitRenk,
              child: widget.grupModel.url == null
                  ? Image.asset(
                      _defaultImage,
                      fit: BoxFit.cover,
                    )
                  : Image.file(File(widget.grupModel.url!))),
        ),
        MahalleAdi(context),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox MahalleAdi(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 4,
      child: Center(
          child: AsTextFild(
              textEditingController: mahalleAdiController,
              label: 'Grup Adınız')),
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

  // ignore: non_constant_identifier_names
  SizedBox Listem() {
    return SizedBox(
      height: Get.height * 0.65,
      child: ListView.builder(
        itemCount: listem.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(listem[index].id),
            background: Container(
              color: Renkler.sabitRenk,
              child: const Icon(
                Icons.delete,
                color: Renkler.scafoldRenk,
              ),
            ),
            onDismissed: (direction) async {
              //!*************************************************
              var deger = widget.grupModel;
              listem.removeAt(index);

              var guncelleme =
                  GrupModel(deger.id, deger.grupAdi, deger.url, listem);
              grupModel = guncelleme;

              await boxTeskilat.put(deger.id, guncelleme);
            },
            child: Card(
              elevation: 5,
              child: ListTile(
                onLongPress: () {
                  var kisiModel = listem[index];
                  adSoyadController.text = kisiModel.adSoyad;
                  telefonController.text = kisiModel.telefon;
                  gorevController.text = kisiModel.gorev;
                  kisiGuncelle(listem[index], index);
                },
                title: Text(
                  listem[index].adSoyad,
                  style: const TextStyle(color: Renkler.yaziRenk),
                ),
                subtitle: Text(
                  listem[index].gorev,
                  style: const TextStyle(color: Renkler.yaziRenk),
                ),
                //! ************************** A R A M A
                trailing: IconButton(
                    onPressed: () {
                      aramaIslem('tel:${listem[index].telefon}');
                    },
                    icon: const Icon(Icons.call, color: Renkler.yaziRenk)),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> kisiEkleme() async {
    if (adSoyadController.text.isNotEmpty &&
        telefonController.text.isNotEmpty) {
      var kisiID = widget.grupModel.id;
      var eklenecekKisi = KisiModel(kisiID, adSoyadController.text.toString(),
          gorevController.text, telefonController.text.toString());
      await boxKisiler.put(kisiID, eklenecekKisi);
      listem.add(eklenecekKisi);

      setState(() {});
      Get.back();
      clearController();
    } else {
      Get.snackbar(
          'Dikkat ', 'Tüm doldurduğuna emin olduktan sonra tekrar dene.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(milliseconds: 2000),
          colorText: Renkler.sabitRenk,
          backgroundColor: Renkler.scafoldRenk);
    }
  }

  SingleChildScrollView alertDiyalogTextfild() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AsTextFild(
            textEditingController: adSoyadController,
            label: 'AD Soyad',
          ),
          const SizedBox(height: 10),
          AsTextFild(
            textEditingController: telefonController,
            label: 'Telefon No',
          ),
          const SizedBox(height: 10),
          AsTextFild(
            textEditingController: gorevController,
            label: 'Görev',
          ),
        ],
      ),
    );
  }

  void clearController() {
    adSoyadController.clear();
    telefonController.clear();
    gorevController.clear();
  }

  Future<void> kaydetmeIslemi() async {
    if (mahalleAdiController.text.isNotEmpty && listem.isNotEmpty) {
      var teskilatID = widget.grupModel.id;

      var eklenecekTeskilat = GrupModel(teskilatID,
          mahalleAdiController.text.toString(), resimDosyasi, listem);

      await boxTeskilat.put(teskilatID, eklenecekTeskilat);
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const AnaSayfa(),
            ),
            (route) => false);
      });
    } else {
      setState(() {
        Get.snackbar('Dikkat ',
            'Mahalle adını girdiğine ve en az bir katılımcı eklediğine emin olduktan sonra tekrar dene.',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(milliseconds: 2000),
            colorText: Renkler.sabitRenk,
            backgroundColor: Renkler.scafoldRenk);
      });
    }
  }

  Future<void> aramaIslem(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunchUrl(Uri(scheme: 'tel', path: url))) {
      // ignore: deprecated_member_use
      launch(url);
    } else {
      Get.snackbar('Hate', 'Geçersiz Telefon Numarası Girdiniz');
    }
  }

  void kisiGuncelle(KisiModel kisiModel, int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Güncelleme',
                style: TextStyle(fontSize: 22, color: Renkler.sabitRenk),
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Kaydet'),
                  onPressed: () {
                    kisiGuncelleme(kisiModel, index);
                  },
                )
              ],
              content: alertDiyalogTextfild(),
            ));
  }

  Future<void> kisiGuncelleme(KisiModel kisiModel, int index) async {
    if (adSoyadController.text.isNotEmpty &&
        telefonController.text.isNotEmpty) {
      var deger = widget.grupModel;
      listem.removeAt(index);

      var guncelleme = GrupModel(deger.id, deger.grupAdi, deger.url, listem);
      grupModel = guncelleme;

      await boxTeskilat.put(deger.id, guncelleme);
      kisiEkleme();
    } else {
      Get.snackbar(
          'Dikkat ', 'Tüm doldurduğuna emin olduktan sonra tekrar dene.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(milliseconds: 2000),
          colorText: Renkler.sabitRenk,
          backgroundColor: Renkler.scafoldRenk);
    }
  }
}
