import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';

class AuthButton extends StatelessWidget{
  final Function onTap;
  final String text;
  final TextStyle butStyle = new TextStyle(
      decoration: TextDecoration.none,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 22
  );


  AuthButton({@required this.onTap, @required this.text});

  @override
  Widget build(BuildContext context) {
    return InOutAnimation(
      inDefinition: BounceInUpAnimation(),
      outDefinition: BounceOutDownAnimation(),
      child: AwesomeButton(
        onTap: onTap,
        height: 40.0,
        width: 40.0,
        color: Color(0xff138c09),
        splashColor: Color(0xff138c09).withOpacity(0.5),
        borderRadius: BorderRadius.circular(60.0),
        blurRadius: 3.0,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: butStyle,
            ),
          ),
        ),
      ),
    );
  }
}