import 'package:elib/pages/settings/settings.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:elib/components/auth_button.dart';

// ignore: must_be_immutable
class Authenticator extends StatelessWidget{

  String keyPass = "";

  void _add({@required String value}) async {
    keyPass = keyPass + value;
    if(keyPass.toLowerCase().indexOf("26#november#2020")>2){
      await myStorage.addToStore(key: "has_authority" , value: true);
      tabData.updateState(sta: SettingsState.Authorized);
      tabData.updateTab(show: true);
    }
    print(keyPass);
    print(keyPass.toLowerCase().indexOf("26#november#2020"));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
      crossAxisCount: isPhone()? 7 : 15,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 6.0,
      children: <Widget>[
        AuthButton(onTap: () => _add(value: "1"), text: "1",),
        AuthButton(onTap: () => _add(value: "2"), text: "2",),
        AuthButton(onTap: () => _add(value: "3"), text: "3",),
        AuthButton(onTap: () => _add(value: "4"), text: "4",),
        AuthButton(onTap: () => _add(value: "5"), text: "5",),
        AuthButton(onTap: () => _add(value: "6"), text: "6",),
        AuthButton(onTap: () => _add(value: "7"), text: "7",),
        AuthButton(onTap: () => _add(value: "8"), text: "8",),
        AuthButton(onTap: () => _add(value: "9"), text: "9",),
        AuthButton(onTap: () => _add(value: "0"), text: "0",),
        AuthButton(onTap: () => _add(value: "@"), text: "@",),
        AuthButton(onTap: () => _add(value: "\$"), text: "\$",),
        AuthButton(onTap: () => _add(value: "%"), text: "%",),
        AuthButton(onTap: () => _add(value: "-"), text: "-",),
        AuthButton(onTap: () => _add(value: "*"), text: "*",),
        AuthButton(onTap: () => _add(value: "#"), text: "#",),
        AuthButton(onTap: () => _add(value: "("), text: "(",),
        AuthButton(onTap: () => _add(value: ")"), text: ")",),
        AuthButton(onTap: () => _add(value: "^"), text: "^",),
        AuthButton(onTap: () => _add(value: "."), text: ".",),
        AuthButton(onTap: () => _add(value: ":"), text: ":",),
        AuthButton(onTap: () => _add(value: "!"), text: "!",),
        AuthButton(onTap: () => _add(value: "~"), text: "~",),
        AuthButton(onTap: () => _add(value: "A"), text: "A",),
        AuthButton(onTap: () => _add(value: "B"), text: "B",),
        AuthButton(onTap: () => _add(value: "C"), text: "C",),
        AuthButton(onTap: () => _add(value: "D"), text: "D",),
        AuthButton(onTap: () => _add(value: "E"), text: "E",),
        AuthButton(onTap: () => _add(value: "F"), text: "F",),
        AuthButton(onTap: () => _add(value: "G"), text: "G",),
        AuthButton(onTap: () => _add(value: "H"), text: "H",),
        AuthButton(onTap: () => _add(value: "I"), text: "I",),
        AuthButton(onTap: () => _add(value: "J"), text: "J",),
        AuthButton(onTap: () => _add(value: "K"), text: "K",),
        AuthButton(onTap: () => _add(value: "L"), text: "L",),
        AuthButton(onTap: () => _add(value: "M"), text: "M",),
        AuthButton(onTap: () => _add(value: "N"), text: "N",),
        AuthButton(onTap: () => _add(value: "O"), text: "O",),
        AuthButton(onTap: () => _add(value: "P"), text: "P",),
        AuthButton(onTap: () => _add(value: "Q"), text: "Q",),
        AuthButton(onTap: () => _add(value: "R"), text: "R",),
        AuthButton(onTap: () => _add(value: "S"), text: "S",),
        AuthButton(onTap: () => _add(value: "T"), text: "T",),
        AuthButton(onTap: () => _add(value: "U"), text: "U",),
        AuthButton(onTap: () => _add(value: "V"), text: "V",),
        AuthButton(onTap: () => _add(value: "W"), text: "W",),
        AuthButton(onTap: () => _add(value: "X"), text: "X",),
        AuthButton(onTap: () => _add(value: "Y"), text: "Y",),
        AuthButton(onTap: () => _add(value: "Z"), text: "Z",),
      ],
    );
  }
}