// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryItemAdapter extends TypeAdapter<LibraryItem> {
  @override
  final int typeId = 3;

  @override
  LibraryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryItem(
      id: fields[0] as String,
      type: fields[1] as String,
      addedOn: fields[4] as DateTime,
      author: fields[3] as String,
      coverImageUrl: fields[6] as String,
      title: fields[7] as String,
      edition: fields[2] as String,
      category: fields[5] as String,
      itemUrl: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.edition)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.addedOn)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.coverImageUrl)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.itemUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LibraryAdapter extends TypeAdapter<Library> {
  @override
  final int typeId = 4;

  @override
  Library read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Library(
      items: (fields[0] as List)?.cast<LibraryItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Library obj) {
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
      other is LibraryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryItem _$LibraryItemFromJson(Map<String, dynamic> json) {
  return LibraryItem(
    id: json['id'].toString(),
    type: json['type'] as String,
    addedOn: json['addedOn'] == null
        ? null
        : DateTime.parse(json['addedOn'] as String),
    author: json['author'] as String,
    coverImageUrl: json['coverImageUrl'] as String,
    title: json['title'] as String,
    edition: json['edition'] as String,
    category: json['category'] as String,
    itemUrl: json['itemUrl'] as String,
  );
}

Map<String, dynamic> _$LibraryItemToJson(LibraryItem instance) =>
    <String, dynamic>{
      //'id': instance.id,
      'type': instance.type,
      'edition': instance.edition,
      'author': instance.author,
      'addedOn': instance.addedOn?.toIso8601String(),
      'category': instance.category,
      'coverImageUrl': instance.coverImageUrl,
      'title': instance.title,
      'itemUrl': instance.itemUrl,
    };
