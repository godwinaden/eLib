import 'package:elib/models/library_item.dart';
import 'package:elib/models/library_shelf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/in_out_animation.dart';
import 'package:flutter_animator/widgets/sliding_entrances/slide_in_right.dart';
import 'package:flutter_animator/widgets/sliding_exits/slide_out_left.dart';

import 'Translate.dart';
import 'library_item_component.dart';

class Shelf extends StatelessWidget{
  final LibraryShelf shelf;
  final Color color;
  final int location;
  final TextStyle tStyle = new TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  final TextStyle nStyle = new TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  Shelf({@required this.shelf, @required this.color, @required this.location}): assert(shelf != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        children: [
          InOutAnimation(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: color,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 2.0,
                    children: [
                      Text(shelf.type.toUpperCase(), style: tStyle),
                      Translate(text:'Shelf'.toUpperCase(), style: nStyle),
                    ],
                  ),
                  Wrap(
                    spacing: 5.0,
                    children: [
                      Text('${shelf.items.length}', style: tStyle),
                      Translate(text:'Items', style: tStyle),
                    ],
                  )
                ],
              ),
            ),
            inDefinition: SlideInRightAnimation(),
            outDefinition: SlideOutLeftAnimation(),
          ),
          SizedBox(height: 5.0,),
          Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shelf.items.length,
              itemBuilder: (context, index) {
                LibraryItem item = shelf.items[index];
                return Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: InOutAnimation(
                    child: LibraryItemComponent(libraryItem: item, location: location, isUsed: false,),
                    inDefinition: SlideInRightAnimation(),
                    outDefinition: SlideOutLeftAnimation(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}