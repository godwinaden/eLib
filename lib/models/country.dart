import 'package:flutter/material.dart';

class Country{
  final String country;
  final List<String> states;

  const Country({@required this.country, @required this.states});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Country && runtimeType == other.runtimeType && country == other.country;

  @override
  int get hashCode => country.hashCode;

  @override
  String toString() {
    return 'Country{$country}';
  }

  String toLowerCase(){
    return country.toLowerCase();
  }

  String toUpperCase(){
    return country.toUpperCase();
  }

  List getState(){
    return states;
  }
}

class RestDownloadTask{
  final String encryptedFilePath;
  final String encryptedCoverPath;
  final bool hasError;
  final String errors;

  RestDownloadTask({this.hasError: true, this.errors: '', this.encryptedCoverPath: '', this.encryptedFilePath: ''});
}

const List<Country> AllCountries = [
  Country(country: 'Nigeria', states: ['Abia', 'Abuja Federal Capital Territory', 'Adamawa', 'Akwa Ibom', 'Anambra', 'Bauchi', 'Bayelsa', 'Benue', 'Borno', 'Cross River', 'Delta', 'Ebonyi', 'Edo', 'Ekiti', 'Enugu', 'Gombe', 'Imo', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi', 'Kwara', 'Lagos', 'Nassarawa', 'Niger', 'Ogun', 'Ondo', 'Osun', 'Oyo', 'Plateau', 'Rivers', 'Sokoto', 'Taraba', 'Yobe', 'Zamfara']),
];

final List<String> nigeriaStates = AllCountries[0].states;