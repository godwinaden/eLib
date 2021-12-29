// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_use.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemToUseAdapter extends TypeAdapter<ItemToUse> {
  @override
  final int typeId = 5;

  @override
  ItemToUse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemToUse(
      id: fields[0] as String,
      libraryItemId: fields[1] as String,
      status: fields[4] as String,
      location: fields[2] as int,
      selectedOn: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ItemToUse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.libraryItemId)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.selectedOn)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemToUseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ToUseListAdapter extends TypeAdapter<ToUseList> {
  @override
  final int typeId = 6;

  @override
  ToUseList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToUseList(
      items: (fields[0] as List)?.cast<ItemToUse>(),
    );
  }

  @override
  void write(BinaryWriter writer, ToUseList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToUseListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemToUse _$ItemToUseFromJson(Map<String, dynamic> json) {
  return ItemToUse(
    id: json['id'] as String,
    libraryItemId: json['libraryItemId'] as String,
    status: json['status'] as String,
    location: json['location'] as int,
    selectedOn: json['selectedOn'] == null
        ? null
        : DateTime.parse(json['selectedOn'] as String),
  );
}

Map<String, dynamic> _$ItemToUseToJson(ItemToUse instance) => <String, dynamic>{
      'id': instance.id,
      'libraryItemId': instance.libraryItemId,
      'location': instance.location,
      'selectedOn': instance.selectedOn?.toIso8601String(),
      'status': instance.status,
    };
