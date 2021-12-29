import 'package:elib/components/localLib.dart';
import 'package:flutter/material.dart';

class MyLibrary extends StatefulWidget {

  MyLibrary({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyLibraryState();
  }
}

class _MyLibraryState extends State<MyLibrary> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return LocalLibrary(box: 2,);
  }
}