import 'dart:io';

import 'package:hive/hive.dart';
part 'file.g.dart';

@HiveType(typeId : 12)
class LibraryFile extends HiveObject{
  @HiveField(0)
  String libraryItemID;

  @HiveField(1)
  File file;

  LibraryFile({
    this.libraryItemID,
    this.file,
  });
}