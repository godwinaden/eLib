import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';

class Translate extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign align;


  Translate({@required this.text, this.style: const TextStyle(
      decoration: TextDecoration.none
  ), this.align: TextAlign.start});



  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Translation>(
      future: myStorage.translate(text: text),
      builder: (BuildContext context, AsyncSnapshot<Translation> snapshot) {
        return Text(
          snapshot?.data?.text?? text,
          style: style,
          textAlign: align,
        );
      },
    );
  }
}