import 'package:elib/models/library_item.dart';
import 'package:flutter/cupertino.dart';

class LibraryShelf{
  final String type;
  final List<LibraryItem> items;

  LibraryShelf({@required this.type, @required this.items}): assert(type != null && type != '' && items != null && items.length > 0);
}