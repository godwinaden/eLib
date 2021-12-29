import 'package:elib/components/Translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthTabState();
  }
}

class _AuthTabState extends State<AuthTab> {
  final TextStyle vStyle = new TextStyle(
    color: Colors.white38,
    fontFamily: "Oswald-Regular",
    fontWeight: FontWeight.w400,
    fontSize: 20.0,
  );

  final TextStyle sStyle = new TextStyle(
    color: Colors.white38,
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    double width = screen.width, height = screen.height;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingFour(
              color: Color(0xff474747),
              size: 50,
            ),
            SizedBox(height: 15.0,),
            Translate(
              text: "Oops! Working On It!",
              style: vStyle,
              align: TextAlign.center,
            ),
            SizedBox(height: 5.0,),
            Translate(
              text: "We will get this feature up and running as soon as possible.",
              style: sStyle,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}