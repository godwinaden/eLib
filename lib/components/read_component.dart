import 'dart:io';

import 'package:elib/components/page_transitions/scale.dart';
import 'package:elib/pages/read/read.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/shape/gf_button_shape.dart';

import 'Translate.dart';

class ReadComponent extends StatefulWidget{

  final String url;
  final int type;
  final ReadViewer view;
  final bool isUsing;

  ReadComponent({@required this.url, @required this.view, this.type: 1, this.isUsing: false}): assert(url != "" && url != null);

  @override
  State<StatefulWidget> createState() {
    return _ReadComponent();
  }

}

class _ReadComponent extends State<ReadComponent>{

  bool loading = false;

  Future<void> _read() async {
    setState(() => loading = true);
    if(widget.view.location == 1){
      File itemFile = await myStorage.decryptFile(path: widget.url);
      if(itemFile != null) widget.view.item.itemUrl = itemFile.path;
      else itemFile = File("documents/elibs/item/any.jpg");
    }
    setState(() => loading = false);
    Navigator.push(
      context,
      ScaleRoute(
        page: widget.view,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.type == 1?
    (
        loading?
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: SpinKitFadingCircle(
            size: 30,
            color: Color(0xff474747),
          ),
        )
            :
        IconButton(
          icon: widget.view.item.type =='Video'? Icon(FeatherIcons.video) : (widget.view.item.type == 'Audio'? Icon(FeatherIcons.headphones) : Icon(FeatherIcons.bookOpen)),
          iconSize: 30,
          color: widget.isUsing? Colors.black38 : Colors.blue,
          tooltip: "${widget.isUsing? 'Continue':'Start'} ${widget.view.item.type =='Video'? 'Watching' : (widget.view.item.type == 'Audio'? 'Listening' : 'Reading')}",
          onPressed: _read,
        )
    )
        :
    (
        loading?
        Center(
          child: SpinKitFadingCircle(
            color: Color(0xff474747),
          ),
        )
            :
        GFButton(
          size: 50.0,
          padding: isPhone()? EdgeInsets.zero : EdgeInsets.only(left: 90, right: 90),
          fullWidthButton: isPhone()? true : false,
          shape: GFButtonShape.pills,
          color: Theme.of(context).buttonColor,
          splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
          hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
          child: Translate(
            text: "${widget.isUsing? 'Continue':'Start'} ${widget.view.item.type =='Video'? 'Watching' : (widget.view.item.type == 'Audio'? 'Listening' : 'Reading')}",
            style: new TextStyle(
              fontFamily: 'Oswald-Regular',
              fontWeight: FontWeight.w500,
              fontSize: 20,
              decoration: TextDecoration.none,
              color: Colors.white,
            ),
          ),
          onPressed: _read,
          elevation: 0.0,
        )
    );
  }
}