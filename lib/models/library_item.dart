import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'library_item.g.dart';

@JsonSerializable()
@HiveType(typeId : 3)
class LibraryItem extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String type; // 'Book', 'Paper', 'article', 'project','Map', 'video', 'Art', 'audio', 'manuscript', 'Biography','Newspaper'

  @HiveField(2)
  String edition;

  @HiveField(3)
  String author;

  @HiveField(4)
  DateTime addedOn;

  @HiveField(5)
  String category;

  @HiveField(6)
  String coverImageUrl;

  @HiveField(7)
  String title;

  @HiveField(8)
  String itemUrl;

  LibraryItem({
    this.id,
    this.type,
    this.addedOn,
    this.author,
    this.coverImageUrl,
    this.title,
    this.edition,
    this.category,
    this.itemUrl
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) => _$LibraryItemFromJson(json);

  Map<String, dynamic> toJson() => _$LibraryItemToJson(this);
}

@HiveType(typeId : 4)
class Library extends HiveObject{

  @HiveField(0)
  List<LibraryItem> items;

  Library({this.items});

  factory Library.fromJson(List<dynamic> json) {
    return Library(
      items: json
          .map((e) => LibraryItem.fromJson(e as Map<String, dynamic>))
          .toList()
    );
  }
}