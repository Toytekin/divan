import 'package:hive/hive.dart';
part 'yenikonu.g.dart';

@HiveType(typeId: 5)
class YeniKonuModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  String konu;
  @HiveField(2)
  String icerik;

  @HiveField(3)
  DateTime? dateTime;
  @HiveField(4)
  String mahalleID;
  @HiveField(5)
  bool gorevYapildimi;

  YeniKonuModel(
      {required this.id,
      required this.konu,
      required this.icerik,
      required this.mahalleID,
      this.dateTime,
      required this.gorevYapildimi});
}
