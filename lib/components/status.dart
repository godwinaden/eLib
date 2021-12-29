import 'package:flutter/material.dart';

class ItemStatus extends StatelessWidget{
  final String status; //'Pending', 'Using', 'Used'

  ItemStatus({this.status: 'Pending'});

  @override
  Widget build(BuildContext context) {
    switch(status.toLowerCase()){
      case 'pending': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.mark_chat_unread_rounded, size: 23, color: Colors.white,),
        ),
      );
      case 'using': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.mark_chat_read_rounded, size: 23, color: Colors.white,),
        ),
      );
      default: return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrangeAccent, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Icon(Icons.approval, size: 23, color: Colors.white,),
        ),
      );
    }
  }

}