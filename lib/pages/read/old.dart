import 'package:elib/components/localLib.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';

class AlreadyReadOrReading extends StatefulWidget {

  AlreadyReadOrReading({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlreadyReadOrReadingState();
  }
}

class _AlreadyReadOrReadingState extends State<AlreadyReadOrReading> {

  @override
  void initState() {
    super.initState();
    tabData.updateTitle(dTitle: "Already Using And Used Items");
  }

  @override
  Widget build(BuildContext context) {
    return LocalLibrary(box: 1);
  }
}