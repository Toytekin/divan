import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sabit/renk.dart';
import 'anasayfa.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final String _title = 'My Meeting App';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: ListView(
          children: [
            Bosluk(context),
            Yazi(context),
            Bosluk(context),
            Lottie.asset('assets/lotti/lotti.json',
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.width / 1.5),
            Bosluk(context),
            GirisButonu(context)
          ],
        )),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ElevatedButton GirisButonu(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Renkler.sabitRenk,
          minimumSize: Size(MediaQuery.of(context).size.width / 2,
              MediaQuery.of(context).size.width / 8)),
      child: const Text(
        'Giriş',
        style: TextStyle(fontSize: 22, color: Renkler.scafoldRenk),
      ),
      onPressed: () {
        setState(() {
          Get.to(const AnaSayfa());
        });
      },
    );
  }

  // ignore: non_constant_identifier_names
  Text Yazi(BuildContext context) {
    return Text(
      _title,
      style: GoogleFonts.lobster(
          fontSize: MediaQuery.of(context).size.width / 7,
          color: Renkler.sabitRenk),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox Bosluk(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 5,
    );
  }
}
