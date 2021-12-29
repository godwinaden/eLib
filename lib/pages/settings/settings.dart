import 'package:elib/components/Translate.dart';
import 'package:elib/components/authenticator.dart';
import 'package:elib/models/locale.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';

class Settings extends StatefulWidget {

  Settings({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

enum SettingsState{
  User,
  Unauthorized,
  Authorized
}

class _SettingsState extends State<Settings> {
  final List locale = locales;
  SettingsState _state = SettingsState.User;
  bool hasAuthority = false;
  final TextStyle tStyle = new TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    fontSize: 18.0,
    fontFamily: "Lato-Italic",
    decoration: TextDecoration.none,
  );

  Future<bool> checkAuthority() async{
    bool has = await myStorage.getFromStore(key: 'has_authority');
    return has != null? has : false;
  }

  @override
  void initState() {
    super.initState();
    tabData.addListener(() {
      Future.delayed(Duration.zero, ()async{
        if(mounted) setState(() {
          _state = tabData.state;
        });
      });
    });
  }

  // @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(top: 30),
      child: _state == SettingsState.User?
      Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: isPhone()? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            FormBuilderDropdown(
              attribute: 'locale',
              initialValue: myStorage.user.locale,
              decoration: const InputDecoration(
                enabled: true,
                fillColor: Colors.black38,
                labelText: "Your Preferred Language?",
                focusColor: Colors.white,
                hoverColor: Colors.white54,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(50.0))
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(50.0))
                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(50.0))
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(50.0))
                ),
                labelStyle: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: "Oswald-Regular",
                  decoration: TextDecoration.none,
                ),
              ),
              hint: Text('Select Gender'),
              style: tStyle,
              dropdownColor: Color.fromRGBO(97, 97, 97, 1.0),
              validators: [FormBuilderValidators.required()],
              items: langLocales
                  .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text('$lang', style: tStyle),
              ))
                  .toList(),
              // isExpanded: false,
              allowClear: true,
              onChanged: (value){
                myStorage.user.locale = value;
                myStorage.addToStore(key: 'user', value: myStorage.user);
              },
            ),
            SizedBox(height: 30,),
            GFButton(
              size: 50,
              child: Translate(text: "ADVANCED SETTINGS", style: tStyle,),
              fullWidthButton: isPhone()? true : false,
              color: Theme.of(context).buttonColor,
              shape: GFButtonShape.pills,
              padding: isPhone()? EdgeInsets.zero : EdgeInsets.only(right: 30, left: 30),
              onPressed: (){
                if(mounted) setState(() {
                  _state = SettingsState.Authorized;
                });
              },
            )
          ],
        ),
      )
          :
      FutureBuilder(
        future: checkAuthority(),
        builder: (context, AsyncSnapshot<bool> snapshot){
          if(snapshot.hasError) return Center(child: Translate(text: '${snapshot.error}',),);
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Center(
              child: SpinKitFadingCircle(
                color: Color(0xff474747),
                size: 60,
              ),
            );
            default: {
              hasAuthority = snapshot.data;
              if(hasAuthority) {
                tabData.updateTab(show: true);
                //Navigator.pop(context);
              }
              return hasAuthority?
              Container()
                  :
              InOutAnimation(
                inDefinition: SlideInRightAnimation(),
                outDefinition: SlideOutLeftAnimation(),
                child: Authenticator(),
              );
            }
          }
        },
      ),
    );
  }
}