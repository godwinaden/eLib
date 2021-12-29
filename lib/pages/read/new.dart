import 'package:elib/components/localLib.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';

class ToRead extends StatefulWidget {

  ToRead({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ToReadState();
  }
}

class _ToReadState extends State<ToRead> {

  @override
  void initState() {
    tabData.updateTitle(dTitle: "To-Use Library Items");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LocalLibrary(box: 0);
  }
}