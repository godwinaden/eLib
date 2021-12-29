import 'package:flutter/material.dart';

enum SignUpState {
  FirstStep,
  SecondStep,
  ThirdStep,
  FourthStep,
  Submitted,
  Failed,
  Succeed
}

class SignUpData extends ChangeNotifier {
  static final SignUpData _signUpData = new SignUpData._internal();
  static get signUpData => _signUpData;

  bool userRegistered = false;
  SignUpState state = SignUpState.FirstStep;
  Map newUser = {
    "title": "Mrs",
    "fullname": "",
    "gender": "Female",
    "state_of_residence": "Abuja",
    "email": "",
    "password": '',
    "locale": 'English',
    "verified_email": false
  };

  factory SignUpData() {
    return _signUpData;
  }

  void update(String field, value) {
    newUser[field] = value;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updateUserRegistered(bool value) {
    userRegistered = value;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updateState(SignUpState value) {
    state = value;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  bool validateNewUserData(){
    bool result = false;
    result = newUser["fullname"] != "" && newUser["state_of_residence"] != "" && newUser["email"] != "" && newUser["password"] != ""?
        true : false;
    return result;
  }

  bool validateReturningUserData(){
    bool result = false;
    result = newUser["email"] != "" && newUser["password"] != ""? true : false;
    return result;
  }

  SignUpData._internal();
}
final signUpData = SignUpData();