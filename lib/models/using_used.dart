import 'dart:convert';

import 'package:elib/models/note.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'library_item.dart';
part 'using_used.g.dart';

@JsonSerializable()
@HiveType(typeId: 9)
class UsingAndUsedItem extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String libraryItemId;

  @HiveField(2)
  int location; // 1 - 'Online'  | 2 - 'Offline'

  @HiveField(3)
  DateTime startedReading;

  @HiveField(4)
  DateTime lastUsed;

  @HiveField(5)
  DateTime finishedOn;

  @HiveField(6)
  double lastScrollPosition;

  @HiveField(7)
  Notes notes;

  @HiveField(8)
  String status; //'Reading' | 'Read'

  @HiveField(9)
  int timesOpened;

  UsingAndUsedItem({
    this.id,
    this.libraryItemId,
    this.location,
    this.status,
    this.finishedOn,
    this.lastScrollPosition,
    this.lastUsed,
    this.notes,
    this.startedReading,
    this.timesOpened,
  });

  LibraryItem getItem(){
    LibraryItem item = LibraryItem();
    try{
      switch(location){
        case 1: {
          if(myStorage.libs.length > 0) item = myStorage.libs.values.where((_) => _.id == libraryItemId).first;
          break;
        }
        default: {
          //check if it exist in allLibrary
          if(tabData.allLibrary.items.length >0) item = tabData.allLibrary.items.firstWhere((element) => element.id == libraryItemId);
          if(item == null && tabData.limitedLibrary.items.length >0) item = tabData.limitedLibrary.items.firstWhere((element) => element.id == libraryItemId);
          break;
        }
      }
    } catch (ex) {
      print("ToUse: GetItem: $ex");
    }
    return item;
  }

  factory UsingAndUsedItem.fromJson(Map<String, dynamic> json) => _$UsingAndUsedItemFromJson(json);

  Map<String, dynamic> toJson() => _$UsingAndUsedItemToJson(this);
}

@HiveType(typeId: 10)
class UsingAndUsedList extends HiveObject{

  @HiveField(0)
  List<UsingAndUsedItem> items;

  UsingAndUsedList({this.items});

  factory UsingAndUsedList.fromJson(List<dynamic> json) {
    return UsingAndUsedList(
        items: json
            .map((e) => UsingAndUsedItem.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}