// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockWithAccessAdapter extends TypeAdapter<StockWithAccess> {
  @override
  final int typeId = 0;

  @override
  StockWithAccess read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockWithAccess(
      symbol: fields[0] as String,
      name: fields[2] as String,
      currency: fields[3] as String,
      exchange: fields[4] as String,
      micCode: fields[5] as String,
      country: fields[6] as String,
      type: fields[7] as String,
      figiCode: fields[8] as String,
      access: fields[9] as Access?,
    );
  }

  @override
  void write(BinaryWriter writer, StockWithAccess obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.exchange)
      ..writeByte(5)
      ..write(obj.micCode)
      ..writeByte(6)
      ..write(obj.country)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.figiCode)
      ..writeByte(9)
      ..write(obj.access);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockWithAccessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
