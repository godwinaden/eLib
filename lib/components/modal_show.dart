import 'package:elib/components/Translate.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:mobile_popup/mobile_popup.dart';

class ModalShow extends StatelessWidget{
  final String buttonTitle;
  final String modalTitle;
  final List<Widget> actions;

  final Widget child;

  ModalShow({@required this.buttonTitle, @required this.child, @required this.modalTitle, this.actions: const <Widget>[]});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GFButton(
        size: 45,
        onPressed: (){
          showMobilePopup(
            context: context,
            builder: (context) => MobilePopUp(
              title: modalTitle,
              showFullScreen: false,
              leadingColor: Colors.white,
              actions: actions,
              child: Builder(
                builder: (navigator) => Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        fullWidthButton: true,
        shape: GFButtonShape.pills,
        color: Theme.of(context).buttonColor,
        hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
        splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
        child: Translate(
          text: buttonTitle,
          style: TextStyle(
              fontFamily: "Lato-Italic",
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18.0,
              decoration: TextDecoration.none
          ),
          align: TextAlign.center,
        ),
      ),
    );
  }
}