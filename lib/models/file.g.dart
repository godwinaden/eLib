// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibraryFileAdapter extends TypeAdapter<LibraryFile> {
  @override
  final int typeId = 12;

  @override
  LibraryFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LibraryFile(
      libraryItemID: fields[0] as String,
      file: fields[1] as File,
    );
  }

  @override
  void write(BinaryWriter writer, LibraryFile obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.libraryItemID)
      ..writeByte(1)
      ..write(obj.file);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibraryFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
