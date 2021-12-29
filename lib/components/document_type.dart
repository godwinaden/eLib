import 'package:flutter/material.dart';

class DocumentType extends StatelessWidget{
  final String type;

  DocumentType({this.type: 'Pdf'});

  @override
  Widget build(BuildContext context) {
    switch(type.toLowerCase()){
      case 'pdf': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'P',
            style: TextStyle(
              fontSize: 23.0,
              fontFamily: "NexaDemo-Bold",
              color: Colors.deepOrange,
              fontWeight: FontWeight.w900
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'docx': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'W',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "NexaDemo-Bold",
                color: Colors.white,
                fontWeight: FontWeight.w700
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'ppsx': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.pink, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'Px',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "Autobus",
                color: Colors.pink,
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'txt': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(color: Colors.amber, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'T',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "NexaDemo-Bold",
                color: Colors.black,
                fontWeight: FontWeight.w700
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'mp4': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'm4',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "Autobus",
                color: Colors.deepOrange,
                fontWeight: FontWeight.w700
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'ts': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.cyan,
          border: Border.all(color: Colors.cyan, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'Ts',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "NexaDemo-Bold",
                color: Colors.black,
                fontWeight: FontWeight.w700
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'mp3': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'm3',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "Autobus",
                color: Colors.white54,
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'gif': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'Gf',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "Autobus",
                color: Colors.white54,
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'png': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'Pg',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "Autobus",
                color: Colors.white54,
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'jpg': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'Jg',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "Autobus",
                color: Colors.white54,
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      case 'csv': return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white54,
          border: Border.all(color: Color.fromRGBO(44, 234, 18, 1), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        child: Center(
          child: Text(
            'Cs',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "OpenSans-Regular",
                color: Color.fromRGBO(44, 234, 18, 1),
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
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
          child: Text(
            '?',
            style: TextStyle(
                fontSize: 23.0,
                fontFamily: "OpenSans-Regular",
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

}