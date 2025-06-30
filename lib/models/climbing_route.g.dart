// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climbing_route.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClimbingRouteAdapter extends TypeAdapter<ClimbingRoute> {
  @override
  final int typeId = 0;

  @override
  ClimbingRoute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClimbingRoute(
      name: fields[0] as String,
      location: fields[1] as String,
      rockType: fields[2] as String,
      complexity: fields[3] as String?,
      height: fields[4] as String?,
      description: fields[5] as String?,
      imagePath: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ClimbingRoute obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.rockType)
      ..writeByte(3)
      ..write(obj.complexity)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClimbingRouteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
