import 'package:hive/hive.dart';
import 'package:toplantid/db/base.dart';
import 'package:toplantid/modeller/grup_model.dart';
import 'package:toplantid/modeller/kisi_model.dart';
import 'package:uuid/uuid.dart';

class HiveDB extends BaseDB {
  var boxTeskilat = Hive.box<GrupModel>("grupDB");

  @override
  Future<void> grupKayit(String id, String mahalleAdi, String resimYolu,
      List<KisiModel> kisiler) async {
    var eklenecekTeskilat = GrupModel(id, mahalleAdi, resimYolu, kisiler);
    await boxTeskilat.put(id, eklenecekTeskilat);
  }
}
