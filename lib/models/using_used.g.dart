// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'using_used.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsingAndUsedItemAdapter extends TypeAdapter<UsingAndUsedItem> {
  @override
  final int typeId = 9;

  @override
  UsingAndUsedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsingAndUsedItem(
      id: fields[0] as String,
      libraryItemId: fields[1] as String,
      location: fields[2] as int,
      status: fields[8] as String,
      finishedOn: fields[5] as DateTime,
      lastScrollPosition: fields[6] as double,
      lastUsed: fields[4] as DateTime,
      notes: fields[7] as Notes,
      startedReading: fields[3] as DateTime,
      timesOpened: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UsingAndUsedItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.libraryItemId)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.startedReading)
      ..writeByte(4)
      ..write(obj.lastUsed)
      ..writeByte(5)
      ..write(obj.finishedOn)
      ..writeByte(6)
      ..write(obj.lastScrollPosition)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.timesOpened);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsingAndUsedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UsingAndUsedListAdapter extends TypeAdapter<UsingAndUsedList> {
  @override
  final int typeId = 10;

  @override
  UsingAndUsedList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsingAndUsedList(
      items: (fields[0] as List)?.cast<UsingAndUsedItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, UsingAndUsedList obj) {
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
      other is UsingAndUsedListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsingAndUsedItem _$UsingAndUsedItemFromJson(Map<String, dynamic> json) {
  return UsingAndUsedItem(
    id: json['id'] as String,
    libraryItemId: json['libraryItemId'] as String,
    location: json['location'] as int,
    startedReading: json['startedReading'] == null
        ? null
        : DateTime.parse(json['startedReading'] as String),
    lastUsed: json['lastUsed'] == null
        ? null
        : DateTime.parse(json['lastUsed'] as String),
    finishedOn: json['finishedOn'] == null
        ? null
        : DateTime.parse(json['finishedOn'] as String),
    lastScrollPosition: json['lastScrollPosition'] as double,
    notes: json['notes'] == null? null : Notes.fromJson(json['notes']),
    status: json['status'] as String,
    timesOpened: json['edition'] as int,
  );
}

Map<String, dynamic> _$UsingAndUsedItemToJson(UsingAndUsedItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'libraryItemId': instance.libraryItemId,
      'location': instance.location,
      'startedReading': instance.startedReading?.toIso8601String(),
      'lastUsed': instance.lastUsed?.toIso8601String(),
      'finishedOn': instance.finishedOn?.toIso8601String(),
      'lastScrollPosition': instance.lastScrollPosition,
      'status': instance.status,
      'timesOpened': instance.timesOpened,
    };
