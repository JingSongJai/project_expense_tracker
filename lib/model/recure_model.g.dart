// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recure_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecureModelAdapter extends TypeAdapter<RecureModel> {
  @override
  final int typeId = 3;

  @override
  RecureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecureModel(
      uuid: fields[0] as int,
      title: fields[1] as String,
      category: fields[2] as String,
      startDate: fields[3] as DateTime,
      endDate: fields[4] as DateTime,
      frequency: fields[5] as String,
      isRemind: fields[6] as bool,
      amount: fields[7] as double,
      isPaused: fields[8] as bool,
      total: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RecureModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.isRemind)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.isPaused)
      ..writeByte(9)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
