import 'dart:convert';

import 'package:awesome_button/awesome_button.dart';
import 'package:elib/components/Translate.dart';
import 'package:elib/components/page_transitions/fade.dart';
import 'package:elib/components/shapes/signup_container.dart';
import 'package:elib/components/splashscreen.dart';
import 'package:elib/models/country.dart';
import 'package:elib/models/locale.dart';
import 'package:elib/models/user.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:elib/singletons/signupData.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:universal_platform/universal_platform.dart';

class SignUp extends StatefulWidget{
  SignUp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp>{
  final TextStyle tStyle = new TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xff138c09),
    fontSize: 25.0,
    decoration: TextDecoration.none,
  );
  final TextStyle largeStyle = new TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.black87,
      fontSize: 25.0,
      decoration: TextDecoration.none,
  );
  final TextStyle largerStyle = new TextStyle(
      fontWeight: FontWeight.w600,
      color: Color(0xff158c09),
      fontSize: 30.0,
      decoration: TextDecoration.none,
      fontFamily: "Oswald-Regular",
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0.5, 0.5),
        blurRadius: 0.7,
      ),
    ],
  );
  final TextStyle cStyle = new TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: 20.0,
    decoration: TextDecoration.none,
    fontFamily: "OpenSans-SemiBold"
  );
  final TextStyle ccStyle = new TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.white,
      fontSize: 20.0,
      decoration: TextDecoration.none,
      fontFamily: "OpenSans-SemiBold"
  );
  final TextStyle nextStyle = new TextStyle(
      fontWeight: FontWeight.w500,
      color: Color(0xff138c09),
      fontSize: 30.0,
      decoration: TextDecoration.none,
      fontFamily: "Autobus",
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0.8, 0.8),
        blurRadius: 0.7,
      ),
    ],
  );
  final TextStyle nStyle = new TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontFamily: "Lato-Italic",
      fontWeight: FontWeight.w300,
      decoration: TextDecoration.none,
  );
  final TextStyle npStyle = new TextStyle(
    color: Colors.black87,
    fontSize: 16.0,
    decoration: TextDecoration.none,
  );
  final TextStyle eStyle = new TextStyle(
    color: Colors.white,
    fontSize: 20.0,
    decoration: TextDecoration.none,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.2),
        offset: Offset(0.5, 0.5),
        blurRadius: 0.5,
      ),
    ],
  );
  List<String> states = nigeriaStates;
  var newUser = signUpData.newUser;
  bool showPassword1 = false;
  bool showPassword2 = false;
  bool loading;
  int hasSaveDetails;
  SignUpState presentState;
  double secondStepCurveHeight;
  FocusNode focusNode;
  FocusNode focusNode1;
  String msg = "An Error Occurred While Trying To Connect To The Cloud.";
  

  _SignUpState();

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode1 = FocusNode();
    signUpData.addListener(() {
      setState(() {
        newUser = signUpData.newUser;
        presentState = signUpData.state;
      });
    });
    setState(() {
      states = [];
      showPassword1 = false;
      showPassword2 = false;
      loading = false;
      presentState = signUpData.state;
      secondStepCurveHeight = 0.3;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    focusNode1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size,
      height = screenSize.height;
    return new WillPopScope(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black87,
        body:presentState==SignUpState.FirstStep? Container(
          child: SignUpContainer(
            color: Colors.white38,
            frontColor: Color(0xfff7f7f7),
            arcHeight: 0.40,
            type: 0,
            child: Padding(
              padding: EdgeInsets.only(top: isPhone()? (height*0.7) + 50.0 : (height*0.7), left: 10.0, bottom: 10.0, right: 10.0),
              child: isPhone()?
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Translate(
                        text: "Federal Ministry Of Transport",
                        style: largeStyle,
                      ),
                      /*Padding(
                          padding: EdgeInsets.only(left:20.0),
                          child: Text(
                            "eLibrary",
                            style: largerStyle,
                          ),
                        ),*/
                      Translate(
                        text: "Library On The Go!",
                        style: tStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: isPhone()?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AwesomeButton(
                              height: 40.0,
                              width: 150.0,
                              color: Colors.black12,
                              onTap: (){
                                signUpData.updateState(SignUpState.SecondStep);
                                print("State: $presentState");
                              },
                              splashColor: Colors.black12,
                              borderRadius: BorderRadius.circular(30),
                              blurRadius: 0.4,
                              child: Center(
                                child: Translate(
                                  text: "Sign In",
                                  style: cStyle,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            AwesomeButton(
                              height: 40.0,
                              width: 150.0,
                              color: Theme.of(context).primaryColor,
                              onTap: (){
                                signUpData.updateState(SignUpState.ThirdStep);
                              },
                              splashColor: Theme.of(context).primaryColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30),
                              blurRadius: 0.4,
                              child: Center(
                                child: Translate(
                                  text: "Sign Up",
                                  style: ccStyle,
                                ),
                              ),
                            ),
                          ],
                        )
                            :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AwesomeButton(
                              height: 40.0,
                              width: 150.0,
                              color: Colors.black12,
                              onTap: (){
                                signUpData.updateState(SignUpState.SecondStep);
                                print("State: $presentState");
                              },
                              splashColor: Colors.black12,
                              borderRadius: BorderRadius.circular(30),
                              blurRadius: 0.4,
                              child: Center(
                                child: Translate(
                                  text: "Sign In",
                                  style: cStyle,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            AwesomeButton(
                              height: 40.0,
                              width: 150.0,
                              color: Theme.of(context).primaryColor,
                              onTap: (){
                                signUpData.updateState(SignUpState.ThirdStep);
                              },
                              splashColor: Theme.of(context).primaryColor.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(30),
                              blurRadius: 0.4,
                              child: Center(
                                child: Translate(
                                  text: "Sign Up",
                                  style: ccStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 220, top: 40),
                    child: Image.asset(
                      'assets/images/7.jpg',
                      width: 120,
                      height: 120,
                    ),
                  )
                ],
              )
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Translate(
                              text: "Federal Ministry Of Transport",
                              style: largeStyle,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left:20.0),
                              child: Text(
                                "eLibrary",
                                style: largerStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                      Translate(
                        text: "Library On The Go!",
                        style: tStyle,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AwesomeButton(
                              height: 40.0,
                              width: 150.0,
                              color: Colors.black12,
                              onTap: (){
                                signUpData.updateState(SignUpState.SecondStep);
                                print("State: $presentState");
                              },
                              splashColor: Colors.black12,
                              borderRadius: BorderRadius.circular(30),
                              blurRadius: 0.4,
                              child: Center(
                                child: Translate(
                                  text: "Sign In",
                                  style: cStyle,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0,),
                            AwesomeButton(
                              height: 40.0,
                              width: 150.0,
                              color: Colors.blue,
                              onTap: (){
                                signUpData.updateState(SignUpState.ThirdStep);
                              },
                              splashColor: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(30),
                              blurRadius: 0.4,
                              child: Center(
                                child: Translate(
                                  text: "Sign Up",
                                  style: ccStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 60,),
                  Image.asset(
                    'assets/images/7.jpg',
                    width: 120,
                    height: 120,
                  )
                ],
              ),
            ),
          ),
        )
            :
          (presentState==SignUpState.SecondStep? Container(
            child: SignUpContainer(
              color: Colors.white.withOpacity(0.7),
              frontColor: Color(0xfff7f7f7),
              arcHeight: isPhone()? 0.4 : 0.9,
              space: isPhone()? 0.04 : 0.30,
              equality: true,
              clock: false,
              child: Padding(
                padding: isPhone()?
                EdgeInsets.only(top: (height*0.3), left: 20.0, bottom: 20.0, right: 20.0)
                :
                EdgeInsets.only(top: (height*0.3), left: height*0.6, bottom: 20.0, right: height*0.6),
                child: FormBuilder(
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FormBuilderTextField(
                        initialValue: newUser["email"].toString(),
                        attribute: "email",
                        autofocus: true,
                        style: npStyle,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: nStyle,
                            icon: const Icon(
                              Icons.alternate_email,
                              color: Colors.black26,
                              size: 25.0,
                            )
                        ),
                        onChanged: (value){
                          signUpData.update("email", value);
                          setState(() {
                            secondStepCurveHeight = 0.1;
                          });
                          //_fbKey1.currentState.setAttributeValue("email", "$value");
                        },
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: (){
                          setState(() {
                            secondStepCurveHeight = 0.3;
                          });
                          if (focusNode.hasFocus) {
                            focusNode.unfocus();
                          }
                        },
                        valueTransformer: (text) => num.tryParse(text),
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ],
                      ),
                      FormBuilderTextField(
                        initialValue: newUser["password"].toString(),
                        attribute: "password",
                        focusNode: focusNode1,
                        style: npStyle,
                        obscureText: showPassword2==false? true : false,
                        maxLines: 1,
                        decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: showPassword2==false?
                            IconButton(
                              icon: const Icon(Icons.visibility),
                              color: Colors.black26,
                              onPressed: (){
                                try{
                                  if(mounted) setState(() {
                                    showPassword2 = true;
                                  });
                                } catch (ex){
                                  print("setState: SignUp: Password: $ex");
                                }
                              },
                            )
                                :
                            IconButton(
                              icon: const Icon(Icons.visibility_off),
                              color: Colors.black26,
                              onPressed: (){
                                try{
                                  if(mounted) setState(() {
                                    showPassword2 = false;
                                  });
                                } catch (ex){
                                  print("setState: SignUp: Password: $ex");
                                }
                              },
                            ),
                            labelStyle: nStyle,
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.black26,
                              size: 25.0,
                            )
                        ),
                        onChanged: (value){
                          signUpData.update("password", value);
                          setState(() {
                            secondStepCurveHeight = 0.1;
                          });
                        },
                        onEditingComplete: (){
                          setState(() {
                            secondStepCurveHeight = 0.3;
                          });
                          if (focusNode1.hasFocus) {
                            focusNode1.unfocus();
                          }
                        },
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(10),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 140, bottom: 20),
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          children: <Widget>[
                            GFButton(
                              color: Colors.white,
                              splashColor: Color(0xff158c09),
                              hoverColor: Color(0xff158c09).withOpacity(0.7),
                              shape: GFButtonShape.pills,
                              elevation: 0.0,
                              type: GFButtonType.transparent,
                              child: Center(
                                child: Translate(
                                  text: "Previous",
                                  style: nStyle,
                                ),
                              ),
                              onPressed: (){
                                signUpData.updateState(SignUpState.FirstStep);
                              },
                            ),
                            newUser["email"]!="" && newUser["password"]!=""?
                            (loading? Center(
                              child: SpinKitFadingCircle(
                                color: Color(0xff474747),
                              ),
                            ): Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: GFButton(
                                onPressed: _signIn,
                                color: Colors.white,
                                splashColor: Colors.black12,
                                shape: GFButtonShape.pills,
                              elevation: 0.0,
                                padding: EdgeInsets.only(left: 30, right: 30),
                                size: GFSize.LARGE,
                                type: GFButtonType.solid,
                                child: Center(
                                  child: Translate(
                                    text: "Sign In",
                                    style: cStyle,
                                  ),
                                ),
                              ),
                            ))
                                :
                            SizedBox()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
              :
            (presentState==SignUpState.ThirdStep? Container(
              child: SignUpContainer(
                color: Colors.white.withOpacity(0.7),
                frontColor: Color(0xfff7f7f7),
                arcHeight: isPhone()? 0.4 : 0.9,
                space: isPhone()? 0.04 : 0.30,
                equality: true,
                clock: false,
                child: Padding(
                  padding: isPhone()?
                  EdgeInsets.only(top: (height*0.3), left: 20.0, bottom: 20.0, right: 20.0)
                      :
                  EdgeInsets.only(top: (height*0.3), left: height*0.6, bottom: 20.0, right: height*0.6),
                  child: FormBuilder(
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FormBuilderTextField(
                          initialValue: newUser["title"].toString(),
                          attribute: "title",
                          autofocus: true,
                          style: npStyle,
                          decoration: InputDecoration(
                              labelText: "Title: Mrs, Mr, Dr, Engr etc",
                              labelStyle: nStyle,
                              icon: const Icon(
                                Icons.accessibility_new,
                                color: Colors.black26,
                                size: 25.0,
                              )
                          ),
                          onChanged: (value){
                            signUpData.update("title", value);
                          },
                          valueTransformer: (text) => num.tryParse(text),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.maxLength(25),
                          ],
                        ),
                        FormBuilderTextField(
                          initialValue: newUser["fullname"].toString(),
                          attribute: "fullname",
                          style: npStyle,
                          decoration: InputDecoration(
                              labelText: "FullName",
                              labelStyle: nStyle,
                              icon: const Icon(
                                Icons.person_pin_circle,
                                color: Colors.black26,
                                size: 25.0,
                              )
                          ),
                          onChanged: (value){
                            signUpData.update("fullname", value);
                          },
                          valueTransformer: (text) => num.tryParse(text),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.maxLength(30),
                          ],
                        ),
                        FormBuilderRadioGroup(
                          decoration: InputDecoration(
                              labelText: 'Gender',
                              labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Oswald-Regular",
                                  color: Colors.black
                              ),
                              isDense: false,
                              icon: const Icon(
                                Icons.face,
                                color: Colors.black26,
                                size: 30.0,
                              )
                          ),
                          attribute: "gender",
                          initialValue: newUser["gender"].toString(),
                          onChanged: (value){
                            signUpData.update("gender", value);
                          },
                          valueTransformer: (value) => value == 'Female'? true : false,
                          validators: [FormBuilderValidators.required()],
                          options: [
                            "Female",
                            "Male",
                          ]
                              .map((lang) => FormBuilderFieldOption(value: lang))
                              .toList(growable: false),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 140, bottom: 20),
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: <Widget>[
                              GFButton(
                                color: Colors.white,
                                splashColor: Color(0xff158c09),
                                hoverColor: Color(0xff158c09).withOpacity(0.7),
                                shape: GFButtonShape.pills,
                              elevation: 0.0,
                                type: GFButtonType.transparent,
                                child: Center(
                                  child: Translate(
                                    text: "Previous",
                                    style: nStyle,
                                  ),
                                ),
                                onPressed: (){
                                  signUpData.updateState(SignUpState.FirstStep);
                                },
                              ),
                              newUser["title"]!="" && newUser["fullname"]!="" && newUser["gender"]!=""?
                              GFButton(
                                color: Colors.white,
                                splashColor: Color(0xff158c09),
                                hoverColor: Color(0xff158c09).withOpacity(0.7),
                                shape: GFButtonShape.pills,
                              elevation: 0.0,
                                type: GFButtonType.transparent,
                                child: Center(
                                  child: Translate(
                                    text: "Next",
                                    style: nStyle,
                                  ),
                                ),
                                onPressed: (){
                                  signUpData.updateState(SignUpState.FourthStep);
                                },
                              ) : SizedBox()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
                :
              (presentState==SignUpState.FourthStep? Container(
                child: SignUpContainer(
                  color: Colors.white.withOpacity(0.7),
                  frontColor: Color(0xfff7f7f7),
                  arcHeight: 0.2,
                  space: 0.04,
                  equality: true,
                  clock: true,
                  child: Padding(
                    padding: EdgeInsets.only(top: (height*0.08), left: 20.0, bottom: 20.0, right: 20.0),
                    child: FormBuilder(
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: isPhone()? EdgeInsets.only(right: 0.0, top: (height/2.5)): EdgeInsets.only(right: height),
                            child: FormBuilderCustomField(
                              attribute: "locale",
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              formField: FormField(
                                enabled: true,
                                initialValue: signUpData.newUser["locale"].toString(),
                                builder: (FormFieldState<dynamic> field) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: "Language",
                                      labelStyle: nStyle,
                                      contentPadding: EdgeInsets.only(top: 10.0, bottom: 0.0),
                                      border: InputBorder.none,
                                      hintText: 'Select Language',
                                      errorText: field.errorText,
                                      icon: const Icon(
                                        Icons.language,
                                        color: Colors.black26,
                                        size: 25.0,
                                      ),
                                    ),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: langLocales.map((option) {
                                        return DropdownMenuItem(
                                          child: Text("$option", style: npStyle,),
                                          value: option,
                                        );
                                      }).toList(),
                                      value: field.value,
                                      onChanged: (value) {
                                        field.didChange(value);
                                        signUpData.update("locale", value);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: isPhone()? EdgeInsets.only(right: 0.0): EdgeInsets.only(right: height),
                            child: FormBuilderTypeAhead(
                              initialValue: newUser["state_of_residence"].toString(),
                              validators: [
                                FormBuilderValidators.required(),
                              ],
                              decoration: InputDecoration(
                                  labelText: "State Of Residence",
                                  labelStyle: nStyle,
                                  icon: const Icon(
                                    Icons.location_city,
                                    color: Colors.black26,
                                    size: 25.0,
                                  )
                              ),
                              attribute: 'state',
                              onChanged: (value){
                                signUpData.update("state_of_residence", value);
                                //_fbKey.currentState.setAttributeValue("state_of_residence", "$value");
                              },
                              itemBuilder: (context, country) {
                                return ListTile(
                                  title: Text(country,style: npStyle,),
                                );
                              },
                              suggestionsCallback: (query) {
                                if (query.length != 0) {
                                  var lowercaseQuery = query.toLowerCase();
                                  return states.where((dState) {
                                    return dState
                                        .toLowerCase()
                                        .contains(lowercaseQuery);
                                  }).toList(growable: true)
                                    ..sort((a, b) => a
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(
                                        b.toLowerCase().indexOf(lowercaseQuery)));
                                } else {
                                  return states;
                                }
                              },
                            ),
                          ),
                          newUser["locale"]!="" && newUser["state_of_residence"]!=""?
                          Padding(
                            padding: EdgeInsets.only(top: 100.0, bottom: 20),
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: <Widget>[
                                GFButton(
                                  color: Colors.white,
                                  splashColor: Color(0xff158c09),
                                  shape: GFButtonShape.pills,
                              elevation: 0.0,
                                  hoverColor: Color(0xff158c09).withOpacity(0.7),
                                  type: GFButtonType.transparent,
                                  child: Center(
                                    child: Translate(
                                      text: "Previous",
                                      style: nStyle,
                                    ),
                                  ),
                                  onPressed: (){
                                    signUpData.updateState(SignUpState.ThirdStep);
                                  },
                                ),
                                GFButton(
                                  color: Colors.white,
                                  splashColor: Color(0xff158c09),
                                  shape: GFButtonShape.pills,
                              elevation: 0.0,
                                  hoverColor: Color(0xff158c09).withOpacity(0.7),
                                  type: GFButtonType.transparent,
                                  child: Center(
                                    child: Translate(
                                      text: "Next",
                                      style: nStyle,
                                    ),
                                  ),
                                  onPressed: (){
                                    signUpData.updateState(SignUpState.Submitted);
                                  },
                                )
                              ],
                            ),
                          )
                              :
                          SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  :
                (presentState==SignUpState.Submitted? Container(
                  child: SignUpContainer(
                    color: Colors.white.withOpacity(0.7),
                    frontColor: Color(0xfff7f7f7),
                    arcHeight: isPhone()?  0.1 : 0.9,
                    space:  isPhone()? 0.04 : 0.06,
                    equality: true,
                    clock: isPhone()? true : false,
                    child: Padding(
                      padding: isPhone()? EdgeInsets.only(top: (height*0.05), left: 20.0, bottom: 20.0, right: 20.0)
                          : EdgeInsets.only(top: (height*0.05), left: (height*0.6), bottom: 20.0, right: (height*0.6)) ,
                      child: FormBuilder(
                        autovalidateMode: AutovalidateMode.always,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FormBuilderTextField(
                              attribute: "email",
                              autofocus: true,
                              style: npStyle,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: nStyle,
                                  icon: const Icon(
                                    Icons.alternate_email,
                                    color: Colors.black26,
                                    size: 25.0,
                                  )
                              ),
                              onChanged: (value){
                                signUpData.update("email", value);
                              },
                              valueTransformer: (text) => num.tryParse(text),
                              validators: [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ],
                            ),
                            FormBuilderTextField(
                              attribute: "password",
                              maxLines: 1,
                              style: npStyle,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: showPassword2==false? true : false,
                              decoration: InputDecoration(
                                  labelText: "Password",
                                  suffixIcon: showPassword2==false?
                                  IconButton(
                                    icon: const Icon(
                                      Icons.visibility,
                                      color: Colors.black26,
                                      size: 25.0,
                                    ),
                                    onPressed: (){
                                      try{
                                        if(mounted) setState(() {
                                          showPassword2 = true;
                                        });
                                      } catch (ex){
                                        print("setState: SignUp: Password: $ex");
                                      }
                                    },
                                  )
                                      :
                                  IconButton(
                                    icon: const Icon(Icons.visibility_off),
                                    color: Colors.black26,
                                    onPressed: (){
                                      try{
                                        if(mounted) setState(() {
                                          showPassword2 = false;
                                        });
                                      } catch (ex){
                                        print("setState: SignUp: Password: $ex");
                                      }
                                    },
                                  ),
                                  labelStyle: nStyle,
                                  icon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.black26,
                                    size: 25.0,
                                  )
                              ),
                              onChanged: (value){
                                signUpData.update("password", value);
                              },
                              valueTransformer: (text) => num.tryParse(text),
                              validators: [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(10),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Flex(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  GFButton(
                                    color: Colors.white,
                                    splashColor: Color(0xff158c09),
                                    hoverColor: Color(0xff158c09).withOpacity(0.7),
                                    shape: GFButtonShape.pills,
                              elevation: 0.0,
                                    type: GFButtonType.transparent,
                                    child: Center(
                                      child: Translate(
                                        text: "Previous",
                                        style: nStyle,
                                      ),
                                    ),
                                    onPressed: (){
                                      signUpData.updateState(SignUpState.FourthStep);
                                    },
                                  ),
                                  newUser["email"]!="" && newUser["password"]!="" && newUser["state_of_residence"]!=""?
                                  (loading? Center(
                                    child: SpinKitFadingCircle(
                                      color: Color(0xff474747),
                                    ),
                                  ): Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: GFButton(
                                      onPressed: _submit,
                                      color: Colors.white,
                                      splashColor: Colors.black12,
                                      shape: GFButtonShape.pills,
                                      elevation: 0.0,
                                      padding: EdgeInsets.only(left: 30, right: 30),
                                      size: GFSize.LARGE,
                                      type: GFButtonType.solid,
                                      child: Center(
                                        child: Translate(
                                          text: "Submit",
                                          style: cStyle,
                                        ),
                                      ),
                                    ),
                                  ))
                                      :
                                  SizedBox()
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                    :
                  (presentState==SignUpState.Succeed? Container(
                    child: SignUpContainer(
                      color: Colors.white.withOpacity(0.7),
                      frontColor: Color(0xfff7f7f7),
                      arcHeight: 0.1,
                      space: 0.04,
                      equality: true,
                      clock: true,
                      child: Center(
                        child: Padding(
                          padding: isPhone()? EdgeInsets.fromLTRB(20, isPhone()? 300 : 250, 20, 20) : EdgeInsets.all(height*0.3),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                border: Border.all(color: Colors.white, width: 7.0),
                                borderRadius: BorderRadius.all(Radius.circular(50.0))
                            ),
                            height: height - (height*0.4),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Translate(
                                      text: "Terms & Conditions",
                                      style: nextStyle,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Translate(
                                        style: nStyle,
                                        text: "eLib is owned, and maintained by The Federal Ministry Of Transport. Designed and Engineered by Aden Godwin John Under Megaton Media Limited",
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Translate(
                                        style: nStyle,
                                        text: "Installing this app on your phone is a full acceptance of all the terms and conditions listed herein and future updates to terms, conditions, and other policies bidding your use of eLib. To disagree, simply uninstall the app from your phone.",
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Translate(
                                        style: nStyle,
                                        text: "As a user on this platform, kindly visit the legal and policy menu for full legal terms and policies. It's mandatory for all our users to understand these terms and policies before doing any transaction with us.",
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: GFButton(
                                        onPressed: (){
                                          Navigator.push(context, FadeRoute(page: SplashScreen()));
                                        },
                                        color: Colors.white,
                                        splashColor: Colors.black12,
                                        shape: GFButtonShape.pills,
                              elevation: 0.0,
                                        size: GFSize.LARGE,
                                        type: GFButtonType.solid,
                                        fullWidthButton: true,
                                        child: Center(
                                          child: Translate(
                                            text: "I Agree",
                                            style: cStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      :
                  Container(
                    child: SignUpContainer(
                      color: Colors.white.withOpacity(0.7),
                      frontColor: Color(0xff474747),
                      arcHeight: 0.1,
                      space: 0.04,
                      equality: false,
                      clock: true,
                      child: Padding(
                        padding: EdgeInsets.only(top: (height*0.8), left: 20.0, bottom: 20.0, right: 20.0),
                        child: FormBuilder(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Translate(
                                text: msg,
                                style: eStyle,
                                align: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: GFButton(
                                  onPressed: (){
                                    signUpData.updateState(SignUpState.FirstStep);
                                  },
                                  color: Colors.white,
                                  splashColor: Colors.black12,
                                  shape: GFButtonShape.pills,
                              elevation: 0.0,
                                  size: 50.0,
                                  type: GFButtonType.solid,
                                  fullWidthButton: true,
                                  child: Center(
                                    child: Translate(
                                      text: "Try Again",
                                      style: cStyle,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  )
                )
              )
            )
          ),
      ),
      onWillPop: () async => false,
    );
  }

  void _submit() async {
    if(signUpData.validateNewUserData()){
      try{
        setState(() {
          loading = true;
        });
        User user = new User(
            title: signUpData.newUser["title"],
            fullName: signUpData.newUser["fullname"],
            gender: signUpData.newUser["gender"],
            stateOfResidence: signUpData.newUser["state_of_residence"],
            email: signUpData.newUser["email"],
            locale: signUpData.newUser["locale"],
            deviceRegToken: '',
            verifiedEmail: false
        );
        dynamic response = await iCloud.post(url: 'new/libraryUser', body: user.toJson(), useSSL: false);
        final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
        print("Response: $decodedResponse");
        if(decodedResponse != null && decodedResponse["user"]!=null){
          Map<String, dynamic> user = decodedResponse["user"];
          myStorage.user = new User.fromJson(user);
          myStorage.addToStore(key: 'user', value: myStorage.user);
          iCloud.setUpRestApiCloud();
          signUpData.updateState(SignUpState.Succeed);
        }else{
          msg = "$decodedResponse";
          Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Sign Up", desc: msg, ).show();
        }
        setState(() {
          loading = false;
        });
      }
      catch(eX){
        setState(() {
          loading = false;
        });
        String msg =  "Please check your network connections and try again. $eX";
        print("Error: $eX");
        Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Connection", desc: msg, ).show();
      }
    }else{
      setState(() {
        loading = false;
      });
      msg = "All fields are required.";
      Alert(context: context, style: myStorage.alertStyle, type: AlertType.warning, title: "Fields Empty", desc: msg, ).show();
      signUpData.updateState(SignUpState.ThirdStep);
    }
  }

  void _signIn() async {
    if(signUpData.validateReturningUserData()){
      setState(() {
        loading = true;
      });
      try{
        if(useRestApiEnvironment){
          dynamic response = await iCloud.post(url: 'existing', body: {"email": signUpData.newUser["email"]});
          final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
          if(decodedResponse != null && decodedResponse["users"]!=null && decodedResponse["users"].length>0){
            Map<String, dynamic> user = decodedResponse["users"][0];
            myStorage.user = new User.fromJson(user);
            myStorage.addToStore(key: 'user', value: myStorage.user);
            iCloud.setUpRestApiCloud();
            msg = "Your account has been successfully retrieved.";
            Alert(context: context, style: myStorage.alertStyle, type: AlertType.info, title: "Sign In", desc: msg, ).show();
            signUpData.updateState(SignUpState.Succeed);
          }else{
            msg = "Could not retrieve your account now. You are not registered on this platform. Kindly sign up.";
            Alert(context: context, style: myStorage.alertStyle, type: AlertType.info, title: "Sign In", desc: msg, ).show();
            signUpData.updateState(SignUpState.Failed);
          }
          setState(() {
            loading = false;
          });
        }
      }
      catch(eX){
        String msg =  "Please check your network connections and try again. Errors: $eX";
        print("Sign In: Error: $eX");
        Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Issues", desc: msg, ).show();
        setState(() {
          loading = false;
        });
      }
    }else{
      msg = "All fields are required. Kindly fill them appropriately.";
      Alert(context: context, style: myStorage.alertStyle, type: AlertType.info, title: "Sign In", desc: msg, ).show();
      signUpData.updateState(SignUpState.ThirdStep);
    }
  }
}