// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yoklama_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YoklamaModelAdapter extends TypeAdapter<YoklamaModel> {
  @override
  final int typeId = 2;

  @override
  YoklamaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YoklamaModel(
      id: fields[0] as String?,
      teskilatID: fields[3] as String?,
      toplantiID: fields[4] as String?,
      katilimDurumu: fields[2] as String?,
      kisiModel: fields[1] as KisiModel?,
    );
  }

  @override
  void write(BinaryWriter writer, YoklamaModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.kisiModel)
      ..writeByte(2)
      ..write(obj.katilimDurumu)
      ..writeByte(3)
      ..write(obj.teskilatID)
      ..writeByte(4)
      ..write(obj.toplantiID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YoklamaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
