// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grup_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrupModelAdapter extends TypeAdapter<GrupModel> {
  @override
  final int typeId = 3;

  @override
  GrupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrupModel(
      fields[0] as String,
      fields[2] as String,
      fields[1] as String?,
      (fields[3] as List).cast<KisiModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, GrupModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.grupAdi)
      ..writeByte(3)
      ..write(obj.kisimodel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
