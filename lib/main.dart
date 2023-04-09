import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toplantid/modeller/maliye.dart';
import 'package:toplantid/modeller/maliye_tumborc.dart';
import 'package:toplantid/modeller/note_model.dart';
import 'package:toplantid/modeller/yenikonu.dart';
import 'package:toplantid/sabit/renk.dart';
import 'package:toplantid/sayfalar/anasayfa.dart';
import 'modeller/grup_model.dart';
import 'modeller/kisi_model.dart';
import 'modeller/toplanti_model.dart';
import 'modeller/yoklama_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(GrupModelAdapter());
  Hive.registerAdapter(KisiModelAdapter());
  Hive.registerAdapter(ToplantiModelAdapter());
  Hive.registerAdapter(YoklamaModelAdapter());
  Hive.registerAdapter(YeniKonuModelAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(MaliyeModelAdapter());
  Hive.registerAdapter(TumOdemelerMaliyeModelAdapter());

  await Hive.openBox<KisiModel>('kisiDB');
  await Hive.openBox<ToplantiModel>('toplantiDB');
  await Hive.openBox<GrupModel>('grupDB');
  await Hive.openBox<YoklamaModel>('yoklamaDB');
  await Hive.openBox<YeniKonuModel>('yenikonuDB');
  await Hive.openBox<NoteModel>('noteDB');
  await Hive.openBox<MaliyeModel>('maliyeDB');
  await Hive.openBox<MaliyeModel>('maliyeDB');
  await Hive.openBox<TumOdemelerMaliyeModel>('tummaliyeDB');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Renkler.sabitRenk,
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Renkler.scafoldRenk,
          appBarTheme: const AppBarTheme(
              backgroundColor: Renkler.sabitRenk, elevation: 0)),
      title: 'Material App',
      home: const AnaSayfa(),
    );
  }
}
