// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maliye.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaliyeModelAdapter extends TypeAdapter<MaliyeModel> {
  @override
  final int typeId = 7;

  @override
  MaliyeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MaliyeModel(
      fields[0] as String,
      fields[1] as double,
      fields[2] as double,
      fields[3] as DateTime?,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MaliyeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.toplamBorc)
      ..writeByte(2)
      ..write(obj.verilenPara)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.adSoyad);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaliyeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
