import 'package:elib/components/shelf.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/library_shelf.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AutomatedList extends StatelessWidget{
  final List<LibraryItem> items;
  final Color color;
  final int location;

  List<String> types = [];
  List<LibraryShelf> shelves = [];

  AutomatedList({@required this.items, this.color: Colors.white, this.location: 2}): assert(items != null && items.length > 0)
  {
    try{
      getDistinctTypes();
      getTypeItems();
    } catch (ex) {
      print("Display Errors: $ex");
    }
  }

  void getTypeItems(){
    List<LibraryItem> typeItems = [];
    if(items!=null && items.length>0){
      types.forEach((String ele) {
        items.forEach((LibraryItem item) {
          if(item.type != null && item.type.toLowerCase() == ele.toLowerCase()) typeItems.add(item);
        });
        shelves.add(new LibraryShelf(type: ele, items: typeItems));
        typeItems = [];
      });
    }
  }

  void getDistinctTypes(){
    items.forEach((LibraryItem item) {
      if(!checkIfTypeExist(type: item.type)) types.add(item.type);
    });
    types.sort();
  }

  bool checkIfTypeExist({@required String type}){
    bool status = false;
    if(types.length>=1){
      types.forEach((String ele) {
        if(ele != null && type != null && ele.toLowerCase() == type.toLowerCase()) status = true;
      });
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: shelves.map((LibraryShelf shelf) => Shelf(shelf: shelf, color: color, location: location,)).toList(),
      ),
    );
  }
}