import 'dart:io';

import 'package:elib/models/library_item.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class DeleteItem extends StatefulWidget{
  var item; //'LibraryItem', 'ItemToUse', 'UsingAndUsedItem'
  final int type; //0, 1, 2

  DeleteItem({@required this.item, @required this.type});

  @override
  State<StatefulWidget> createState() {
    return _DeleteItemState();
  }

}

class _DeleteItemState extends State<DeleteItem>{
  bool loading = false;

  @override
  void initState(){
    super.initState();
  }

  void _info(){
    String msg = "Press and hold to delete Item.";
    Alert(context: context, style: myStorage.alertStyle, type: AlertType.info, title: "Delete", desc: msg, ).show();
  }

  Future<void> _delete() async {

    setState(() => loading = true);
    try{
      switch(widget.type){
        case 0: {
          LibraryItem lItem = widget.item;
          bool hasDeleted = await myStorage.removeFromLocalLibrary(item: lItem);
          print("has deleted: $hasDeleted");
          if(hasDeleted){
            if(lItem.itemUrl != null){
              List<String> paths = lItem.itemUrl.split('/');
              String path = paths[0] + '/' + paths[1] + '/' + paths[2];
              Directory pathDir = Directory(path);
              bool itExists = await pathDir.exists();
              if(itExists) await pathDir.delete(recursive: true);
            }
          }
          break;
        }
        case 1: {
          await myStorage.removeFromToUseStore(item: widget.item);
          break;
        }
        default: {
          await myStorage.removeUsingAndUseStore(item: widget.item);
          break;
        }
      }
      setState(() => loading = false);
    }catch(ex){
      print("DeleteItem: Delete: 5: $ex");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _info,
      onLongPress: _delete,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Color(0xffc40b0b),
          border: Border.all(color: Color(0xffc40b0b), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: loading? SpinKitFadingCircle(size: 25, color: Colors.white,) : Icon(FeatherIcons.trash, size: 23, color: Colors.white,),
        ),
      ),
    );
  }

}