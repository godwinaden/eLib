import 'package:elib/components/Translate.dart';
import 'package:elib/models/locale.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Starred extends StatefulWidget {

  Starred({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StarredState();
  }
}

class _StarredState extends State<Starred> {
  final List locale = locales;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage("assets/images/starred.png"),
              color: Colors.black54,
              size: 64.0,
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingFour(size: 30, color: Color(0xff474747),),
                  Translate(
                    text: "Yeh! We Are Working On It!",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black45,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Apple SD Gothic Neo"
                    ),
                    align: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}