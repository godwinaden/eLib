import 'package:elib/models/library_item.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Translate.dart';
import 'library_item_component.dart';

class LibraryHorizontalList extends StatefulWidget{
  final int quantity;
  final int location; //1 = offline, 2 = online

  LibraryHorizontalList({this.location: 1, this.quantity: 10});

  @override
  State<StatefulWidget> createState() {
    return _LibraryHorizontalListState(quantity: quantity, location: location);
  }

}

class _LibraryHorizontalListState extends State<LibraryHorizontalList> {
  final int quantity;
  final int location;

  final TextStyle titleStyle = new TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.4,
    color: Colors.black38,
  ), mgsStyle = new TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.4,
    color: Colors.black38,
    fontFamily: "Lato-Italic"
  );

  _LibraryHorizontalListState({@required this.quantity, @required this.location});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: location==1?
      WatchBoxBuilder(
          box: myStorage.libs,
          builder: (context, box){
            List<LibraryItem> libs = box.values.toList();
            libs = new List.from(libs.reversed);
            int len = libs.length;
            int listLen = quantity>len? len : quantity;
            return libs != null && len>0?
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:  listLen,
              itemBuilder: (context, index) {
                if(index > (listLen-1)) return SizedBox();
                LibraryItem item = libs[index];
                return Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: LibraryItemComponent(libraryItem: item, location: location, hasStatus: false, isUsed: false),
                );
              },
            )
                :
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Istos.bookmark, color: Colors.black38, size: 60,),
                  SizedBox(height: 15,),
                  Translate(text: 'Online Library', align: TextAlign.center, style: titleStyle,),
                  Translate(text: 'No Item In The Library Yet!', align: TextAlign.center, style: mgsStyle,),
                ],
              ),
            );
          }
      )
          :
      FutureBuilder(
        future: tabData.getLastItems(quantity: quantity),
        builder: (context, AsyncSnapshot<Library> snapshot){
          if(snapshot.hasError){
            return Center(child: Translate(text: snapshot.error.toString()),);
          }
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            );
            default: {
              List<LibraryItem> items = snapshot.data.items;
              return items.length>0?
              ListView.builder(
                itemCount: items.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  LibraryItem item = items[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: LibraryItemComponent(libraryItem: item, location: location, hasStatus: false, isUsed: false),
                  );
                },
              )
                  :
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Istos.bookmark, color: Colors.black38, size: 60,),
                    SizedBox(height: 15,),
                    Translate(text: 'Online Library', align: TextAlign.center, style: titleStyle,),
                    Translate(text: 'No Item In The Library Yet!', align: TextAlign.center, style: mgsStyle,),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

}
