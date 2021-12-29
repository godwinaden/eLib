import 'dart:convert';

import 'package:elib/components/Translate.dart';
import 'package:elib/components/UserComponent.dart';
import 'package:elib/models/user.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UsersTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UsersTabState();
  }
}

class _UsersTabState extends State<UsersTab> {

  final TextStyle tStyle = new TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  final TextStyle nStyle = new TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  final TextStyle sStyle = new TextStyle(
    color: Colors.white38,
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
  );

  final TextStyle vStyle = new TextStyle(
    color: Colors.white38,
    fontFamily: "Oswald-Regular",
    fontWeight: FontWeight.w400,
    fontSize: 22.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<UserList> getUsers() async {
    UserList userList = UserList(users: []);
    //check if any locally
    if(tabData.allUsers.users.length>0) return tabData.allUsers;
    else {
      if(useRestApiEnvironment){
        try{
          dynamic response = await iCloud.get(url: 'v2/user');
          final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
          if(decodedResponse != null && decodedResponse["users"] != null && decodedResponse["users"].length>0){
            UserList res = new UserList.fromJson(decodedResponse["users"]);
            tabData.updateUsers(users: res);
          }
        } catch(ex){
          print("GetUsers: $ex");
        }
      }
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    double width = screen.width, height = screen.height;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: getUsers(),
        builder: (context, AsyncSnapshot<UserList> snapshot){
          if(snapshot.hasError) return Translate(text: 'Errors Found: ${snapshot.error}');
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Container(
              height: 300.0,
              child: Center(
                child: SpinKitFadingGrid(
                    color: Colors.white,
                    size: 50.0
                ),
              ),
            );
            default: {
              bool notEmpty = snapshot.hasData;
              List<User> users = snapshot.data.users;
              int len = users.length;
              return notEmpty && len > 0?
              (
                isPhone()?
                ListView.builder(
                  itemCount: len,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    User user = users[index];
                    return InOutAnimation(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: UserComponent(user: user,),
                      ),
                      inDefinition: SlideInRightAnimation(),
                      outDefinition: SlideOutLeftAnimation()
                    );
                  },
                ) : Center(
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: users.map((User user) => Container(
                      width: 350,
                      child: InOutAnimation(
                        child: UserComponent(user: user,),
                        inDefinition: SlideInRightAnimation(),
                        outDefinition: SlideOutLeftAnimation(),
                      ),
                    )).toList(),
                  ),
                )
              )
                  :
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(AssetImage('assets/images/ty.png'), color: Colors.white38, size: 70.0),
                    SizedBox(height: 15.0,),
                    Translate(text: "Oops! The Library Has No User!", style: vStyle, align: TextAlign.center,),
                    SizedBox(height: 5.0,),
                    Translate(text: "As users join, You will be notified", style: sStyle, align: TextAlign.center,),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}