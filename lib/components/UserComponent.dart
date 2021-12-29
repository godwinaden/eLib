import 'package:elib/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserComponent extends StatelessWidget{
  final User user;

  UserComponent({@required this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.black45,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: Image.asset(
              user.gender == 'Female'? 'assets/images/u.jpg' : 'assets/images/hj.jpg',
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10.0,),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.title}. ${user.fullName}',
                    style: new TextStyle(
                      color: Colors.white70,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Avenir',
                      decoration: TextDecoration.none
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${user.gender} | ${user.email} | ${user.locale}',
                    style: new TextStyle(
                      color: Colors.white38,
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lato-Italic',
                      decoration: TextDecoration.none
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${user.stateOfResidence} | ${user.verifiedEmail}',
                    style: new TextStyle(
                      color: Colors.white24,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Oswald-Regular',
                      decoration: TextDecoration.none
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}