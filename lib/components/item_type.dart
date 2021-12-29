import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';

class ItemType extends StatelessWidget{
  final String type; //'Book', 'article', 'project','Map', 'video', 'Art', 'audio', 'manuscript', 'Biography','Newspaper', Magazine, research

  ItemType({this.type: 'Book'}) : assert(type != null);

  @override
  Widget build(BuildContext context) {
    switch(type.toLowerCase()){
      case 'book': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(FeatherIcons.book, size: 23, color: Colors.deepOrange,),
        ),
      );
      case 'article': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Istos.bookmark, size: 23, color: Colors.white,),
        ),
      );
      case 'project': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.pink, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.dashboard, size: 23, color: Colors.pink,),
        ),
      );
      case 'map': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(color: Colors.amber, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Istos.map, size: 23, color: Colors.black,),
        ),
      );
      case 'video': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.purple, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(FeatherIcons.video, size: 23, color: Colors.purple,),
        ),
      );
      case 'art': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(FeatherIcons.image, size: 23, color: Colors.cyan,),
        ),
      );
      case 'audio': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(FeatherIcons.mic, size: 23, color: Colors.white,),
        ),
      );
      case 'manuscript': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Color.fromRGBO(44, 234, 18, 1), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.architecture, size: 23, color: Color.fromRGBO(44, 234, 18, 1),),
        ),
      );
      case 'biography': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(FeatherIcons.user, size: 23, color: Colors.black,),
        ),
      );
      case 'newspaper': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Color.fromRGBO(44, 234, 18, 1), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.assignment, size: 23, color: Color.fromRGBO(44, 234, 18, 1),),
        ),
      );
      case 'magazine': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Color.fromRGBO(44, 234, 18, 1), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.note, size: 23, color: Color.fromRGBO(44, 234, 18, 1),),
        ),
      );
      case 'research': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Color.fromRGBO(44, 234, 18, 1), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Istos.coffeescript, size: 23, color: Color.fromRGBO(44, 234, 18, 1),),
        ),
      );
      default: return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Istos.aids, size: 23, color: Colors.white,),
        ),
      );
    }
  }

}