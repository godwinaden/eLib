import 'package:elib/components/library_item_component.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:flutter/material.dart';

class LocalItemComponent extends StatelessWidget{

  final bool isUsed;
  final ItemToUse toUse;
  final UsingAndUsedItem usedOrUsing;

  LocalItemComponent({@required this.isUsed, this.toUse, this.usedOrUsing}): assert(isUsed? usedOrUsing != null : toUse != null);

  @override
  Widget build(BuildContext context) {
    return LibraryItemComponent(
      libraryItem: isUsed? usedOrUsing.getItem() : toUse.getItem(),
      location: isUsed? usedOrUsing.location : toUse.location,
      hasStatus: true,
      isUsed: isUsed,
      usedOrUsing: usedOrUsing,
      toUse: toUse,
    );
  }
}