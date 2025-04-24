// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gerd_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GerdRecordModelAdapter extends TypeAdapter<GerdRecordModel> {
  @override
  final int typeId = 0;

  @override
  GerdRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GerdRecordModel(
      date: fields[0] as String,
      symptoms: (fields[1] as List).cast<String>(),
      status: fields[2] as String,
      notes: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GerdRecordModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.symptoms)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GerdRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
