import 'package:hive/hive.dart';
import 'package:toplantid/modeller/yenikonu.dart';
import 'package:toplantid/modeller/yoklama_model.dart';
part 'toplanti_model.g.dart';

@HiveType(typeId: 4)
class ToplantiModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String toplantiKonu;
  @HiveField(2)
  String tarih;
  @HiveField(3)
  List<YoklamaModel> yoklamaModel;

  @HiveField(4)
  List<YeniKonuModel> yeniKonuVeIcerik;

  @HiveField(6)
  String mahalleID;

  ToplantiModel(this.id, this.toplantiKonu, this.yoklamaModel,
      this.yeniKonuVeIcerik, this.mahalleID, this.tarih);
}
