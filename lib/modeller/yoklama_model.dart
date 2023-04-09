import 'package:hive/hive.dart';
import 'kisi_model.dart';
part 'yoklama_model.g.dart';

@HiveType(typeId: 2)
class YoklamaModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  KisiModel? kisiModel;
  @HiveField(2)
  String? katilimDurumu;
  @HiveField(3)
  String? teskilatID;
  @HiveField(4)
  String? toplantiID;

  YoklamaModel(
      {required this.id,
      required this.teskilatID,
      required this.toplantiID,
      required this.katilimDurumu,
      required this.kisiModel});
}
