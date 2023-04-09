// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maliye_tumborc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TumOdemelerMaliyeModelAdapter
    extends TypeAdapter<TumOdemelerMaliyeModel> {
  @override
  final int typeId = 8;

  @override
  TumOdemelerMaliyeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TumOdemelerMaliyeModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as double,
      fields[3] as double,
      fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TumOdemelerMaliyeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.kisiID)
      ..writeByte(1)
      ..write(obj.odemeID)
      ..writeByte(2)
      ..write(obj.verilenPara)
      ..writeByte(3)
      ..write(obj.kalanPara)
      ..writeByte(4)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TumOdemelerMaliyeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
