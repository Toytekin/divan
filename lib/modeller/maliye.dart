import 'package:hive/hive.dart';
part 'maliye.g.dart';

@HiveType(typeId: 7)
class MaliyeModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  double toplamBorc;

  @HiveField(2)
  double verilenPara;

  @HiveField(3)
  DateTime? dateTime;
  @HiveField(4)
  String adSoyad;

  MaliyeModel(
      this.id, this.toplamBorc, this.verilenPara, this.dateTime, this.adSoyad);
}
