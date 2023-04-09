import 'package:hive/hive.dart';
part 'kisi_model.g.dart';

@HiveType(typeId: 1)
class KisiModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String adSoyad;
  @HiveField(2)
  String telefon;
  @HiveField(3)
  String gorev;

  KisiModel(
    this.id,
    this.adSoyad,
    this.gorev,
    this.telefon,
  );
}
