// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yenikonu.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YeniKonuModelAdapter extends TypeAdapter<YeniKonuModel> {
  @override
  final int typeId = 5;

  @override
  YeniKonuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YeniKonuModel(
      id: fields[0] as String,
      konu: fields[1] as String,
      icerik: fields[2] as String,
      mahalleID: fields[4] as String,
      dateTime: fields[3] as DateTime?,
      gorevYapildimi: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, YeniKonuModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.konu)
      ..writeByte(2)
      ..write(obj.icerik)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.mahalleID)
      ..writeByte(5)
      ..write(obj.gorevYapildimi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YeniKonuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
