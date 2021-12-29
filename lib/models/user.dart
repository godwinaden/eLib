import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class User extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String email;

  @HiveField(2)
  String fullName;

  @HiveField(3)
  String gender;

  @HiveField(4)
  String locale;

  @HiveField(5)
  String stateOfResidence;

  @HiveField(6)
  String title;

  @HiveField(7)
  bool verifiedEmail;

  @HiveField(8)
  String deviceRegToken;

  User({
    this.id,
    this.email,
    this.fullName,
    this.gender,
    this.locale,
    this.stateOfResidence,
    this.title,
    this.verifiedEmail,
    this.deviceRegToken
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@HiveType(typeId: 8)
class UserList extends HiveObject{

  @HiveField(0)
  List<User> users;

  UserList({this.users});

  factory UserList.fromJson(List<dynamic> json) {
    return UserList(
        users: json
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}