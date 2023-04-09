//maliye_tumborc
import 'package:hive/hive.dart';
part 'maliye_tumborc.g.dart';

@HiveType(typeId: 8)
class TumOdemelerMaliyeModel {
  @HiveField(0)
  String kisiID;

  @HiveField(1)
  String odemeID;

  @HiveField(2)
  double verilenPara;
  @HiveField(3)
  double kalanPara;

  @HiveField(4)
  DateTime dateTime;

  TumOdemelerMaliyeModel(
    this.kisiID,
    this.odemeID,
    this.verilenPara,
    this.kalanPara,
    this.dateTime,
  );
}
