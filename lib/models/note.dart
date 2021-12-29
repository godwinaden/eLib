import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'note.g.dart';

@JsonSerializable()
@HiveType(typeId : 1)
class Note extends HiveObject{
  @HiveField(0)
  String id;

  @HiveField(1)
  String usingOrUsedId;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime dateCreated;

  @HiveField(4)
  DateTime lastEditedOn;

  Note({
    this.id,
    this.content,
    this.dateCreated,
    this.lastEditedOn,
    this.usingOrUsedId
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

@HiveType(typeId : 2)
class Notes extends HiveObject{

  @HiveField(0)
  List<Note> items;

  Notes({this.items});

  factory Notes.fromJson(List<dynamic> json) {
    return Notes(
        items: json
            .map((e) => Note.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}