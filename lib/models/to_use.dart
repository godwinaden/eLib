import 'dart:convert';

import 'package:elib/models/library_item.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'to_use.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class ItemToUse extends HiveObject{

  @HiveField(0)
  String id;

  @HiveField(1)
  String libraryItemId;

  @HiveField(2)
  int location; // 1 - 'Online'  | 2 - 'Offline'

  @HiveField(3)
  DateTime selectedOn;

  @HiveField(4)
  String status;

  ItemToUse({
    this.id,
    this.libraryItemId,
    this.status,
    this.location,
    this.selectedOn,
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
          if(item.id == null && tabData.limitedLibrary.items.length >0) item = tabData.limitedLibrary.items.firstWhere((element) => element.id == libraryItemId);
          break;
        }
      }
    } catch (ex) {
      print("ToUse: GetItem: $ex");
    }
    return item;
  }

  factory ItemToUse.fromJson(Map<String, dynamic> json) => _$ItemToUseFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToUseToJson(this);
}

@HiveType(typeId: 6)
class ToUseList extends HiveObject{

  @HiveField(0)
  List<ItemToUse> items;

  ToUseList({this.items});

  factory ToUseList.fromJson(List<dynamic> json) {
    return ToUseList(
        items: json
            .map((e) => ItemToUse.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}