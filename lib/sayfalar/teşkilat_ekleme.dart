import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:toplantid/db/hive_db.dart';
import 'package:toplantid/modeller/maliye.dart';
import 'package:toplantid/sabit/byk_textfild.dart';
import 'package:toplantid/sabit/sayilar_txtfild.dart';
import 'package:toplantid/sayfalar/anasayfa.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../modeller/grup_model.dart';
import '../modeller/kisi_model.dart';
import '../sabit/renk.dart';
import '../sabit/textfild.dart';

class TeskilatEklemeSayfasi extends StatefulWidget {
  const TeskilatEklemeSayfasi({super.key});

  @override
  State<TeskilatEklemeSayfasi> createState() => _TeskilatEklemeSayfasiState();
}

class _TeskilatEklemeSayfasiState extends State<TeskilatEklemeSayfasi> {
  final String _defaultImage = 'assets/image/ron.png';

  var mahalleAdiController = TextEditingController();
  var adSoyadController = TextEditingController();
  var telefonController = TextEditingController();
  var gorevController = TextEditingController();

  var boxKisiler = Hive.box<KisiModel>("kisiDB");
  var boxTeskilat = Hive.box<GrupModel>("grupDB");
  var boxMaliye = Hive.box<MaliyeModel>("maliyeDB");

  List<KisiModel> listem = [];
  List<KisiModel> yeniEklenenListem = [];
//? IMAGEPİCER DEĞİŞKENLERİ
  final ImagePicker _picker = ImagePicker();
  String? resimDosyasi;
  String? _resimYolu;

  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  void clearController() {
    adSoyadController.clear();
    telefonController.clear();
    gorevController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      appBar: appbarim(context),
      body: Column(
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
                      style: TextStyle(fontSize: 22, color: Renkler.sabitRenk),
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
        child: const Icon(Icons.person_add),
      ),
    );
  }
//! ********************************************

  // ignore: non_constant_identifier_names
  SizedBox Listem() {
    return SizedBox(
      height: Get.height * 0.65,
      child: ListView.builder(
        itemCount: listem.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              color: Renkler.sabitRenk,
              child: const Icon(
                Icons.delete,
                color: Renkler.scafoldRenk,
              ),
            ),
            key: Key(index.toString()),
            onDismissed: (direction) {
              //!*************************************************
              yeniEklenenListem.removeAt(index);
            },
            child: Card(
              elevation: 5,
              child: ListTile(
                title: Text(
                  listem[index].adSoyad,
                  style: const TextStyle(color: Renkler.yaziRenk),
                ),
                subtitle: Text(
                  listem[index].gorev,
                  style: const TextStyle(color: Renkler.yaziRenk),
                ),
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

  Center lotti() {
    return Center(
      child: Lottie.asset(
        'assets/lotti/emty.json',
        width: Get.size.width * 0.6,
        height: Get.size.width * 0.6,
      ),
    );
  }

  AppBar appbarim(BuildContext context) {
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
      title: const Text('Teşkilat Ekleme Sayfasi'),
      actions: [
        IconButton(
            onPressed: () {
              teskilatKaydetme();
              clearController();
              mahalleAdiController.clear();
            },
            icon: const Icon(
              Icons.save,
              size: 30,
            ))
      ],
    );
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
          SayiTextfild(
            textEditingController: telefonController,
            label: 'Telefon No',
          ),
          const SizedBox(height: 10),
          BykTextFild(
            textEditingController: gorevController,
            label: 'Görev',
          ),
        ],
      ),
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
              child: resimDosyasi == null
                  ? Image.asset(
                      _defaultImage,
                      fit: BoxFit.cover,
                    )
                  : Image.file(File(resimDosyasi!))),
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

  Future<void> kisiEkleme() async {
    if (adSoyadController.text.isNotEmpty &&
        telefonController.text.isNotEmpty) {
      var kisiID = const Uuid().v1();
      var eklenecekKisi = KisiModel(kisiID, adSoyadController.text.toString(),
          gorevController.text, telefonController.text.toString());
      await boxKisiler.put(kisiID, eklenecekKisi);
      listem.add(eklenecekKisi);
      setState(() {
        Navigator.of(context).pop();
        clearController();
      });
    } else {
      Get.snackbar(
          'Dikkat ', 'Tüm doldurduğuna emin olduktan sonra tekrar dene.',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(milliseconds: 2000),
          colorText: Renkler.sabitRenk,
          backgroundColor: Renkler.scafoldRenk);
    }
  }

  // void kisileriCek() {
  //   for (var element in boxKisiler.values) {
  //     listem.add(element);
  //   }
  // }

  Future<void> teskilatKaydetme() async {
    if (mahalleAdiController.text.isNotEmpty && listem.isNotEmpty) {
      var teskilatID = const Uuid().v1();

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
}
