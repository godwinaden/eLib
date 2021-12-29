import 'package:elib/components/Translate.dart';
import 'package:elib/components/horizontal_litem_list.dart';
import 'package:elib/models/locale.dart';
import 'package:flutter/material.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';

class RecentActivities extends StatefulWidget {

  RecentActivities({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecentActivitiesState();
  }
}

class _RecentActivitiesState extends State<RecentActivities> {
  final List locale = locales;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      padding: isPhone()? EdgeInsets.only(bottom: isPhone()? 0 : 20.0, top: 20.0) : EdgeInsets.only(bottom: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10.0),
              child: Row(
                mainAxisAlignment: isPhone()? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  Translate(text: "Recent Items", style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.blue,
                      fontSize: isPhone()? 18 : 20,
                      fontWeight: FontWeight.w300,
                  ),),
                  Translate(text: "Cloud Library", style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Color(0xff158c09),
                    fontSize: isPhone()? 19 : 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Proxima-Light"
                  ),)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: LibraryHorizontalList(location: 2, quantity: 60,),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10.0),
              child: Row(
                mainAxisAlignment:  isPhone()? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  Translate(text: "Latest Items", style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.blue,
                    fontSize: isPhone()? 18 : 20,
                    fontWeight: FontWeight.w300,
                  ),),
                  Translate(text: "My Library", style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Color(0xff158c09),
                      fontSize: isPhone()? 19 : 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Proxima-Light"
                  ),)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: LibraryHorizontalList(location: 1, quantity: 60,),
            ),
            /*Padding(
              padding: EdgeInsets.only(top: 50),
              child: Uploader(),
            )*/
          ],
        ),
      ),
    );
  }
}