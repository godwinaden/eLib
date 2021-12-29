// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 7;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      fullName: fields[2] as String,
      gender: fields[3] as String,
      locale: fields[4] as String,
      stateOfResidence: fields[5] as String,
      title: fields[6] as String,
      verifiedEmail: fields[7] as bool,
      deviceRegToken: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.locale)
      ..writeByte(5)
      ..write(obj.stateOfResidence)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.verifiedEmail)
      ..writeByte(8)
      ..write(obj.deviceRegToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserListAdapter extends TypeAdapter<UserList> {
  @override
  final int typeId = 8;

  @override
  UserList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserList(
      users: (fields[0] as List)?.cast<User>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.users);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: (json['id']).toString(),
    email: json['email'] as String,
    fullName: json['fullName'] as String,
    gender: json['gender'] as String,
    locale: json['locale'] as String,
    stateOfResidence: json['stateOfResidence'] as String,
    title: json['title'] as String,
    verifiedEmail: json['verifiedEmail'] == 0? false : true,
    deviceRegToken: json['deviceRegToken'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      //'id': int.parse(instance.id),
      'email': instance.email,
      'fullName': instance.fullName,
      'gender': instance.gender,
      'locale': instance.locale,
      'stateOfResidence': instance.stateOfResidence,
      'title': instance.title,
      'verifiedEmail': instance.verifiedEmail? 1 : 0,
      'deviceRegToken': instance.deviceRegToken,
    };
