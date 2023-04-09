import 'package:hive/hive.dart';
import 'kisi_model.dart';
part 'grup_model.g.dart';

@HiveType(typeId: 3)
class GrupModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? url;
  @HiveField(2)
  String grupAdi;
  @HiveField(3)
  List<KisiModel> kisimodel;

  GrupModel(this.id, this.grupAdi, this.url, this.kisimodel);
}
