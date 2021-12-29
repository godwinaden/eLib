import 'package:elib/components/library_item_component.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:flutter/material.dart';

class LocalAutomatedList extends StatelessWidget{

  final bool isUsed;
  final List<ItemToUse> toUses;
  final List<UsingAndUsedItem> usedOrUsings;
  final Color color;

  LocalAutomatedList({
    @required this.isUsed,
    this.toUses,
    this.usedOrUsings,
    this.color: Colors.white
  }) : assert(isUsed?
  (usedOrUsings != null && usedOrUsings.length > 0)
      : (toUses != null && toUses.length > 0));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: isUsed?
        usedOrUsings.map((UsingAndUsedItem item) =>
            LibraryItemComponent(
              libraryItem: item.getItem(),
              hasStatus: true,
              isUsed: true,
              usedOrUsing: item,
              location: item.location,
            )).toList()
            :
        toUses.map((ItemToUse item) =>
          LibraryItemComponent(
            libraryItem: item.getItem(),
            hasStatus: true,
            isUsed: false,
            toUse: item,
            location: item.location,
          )).toList(),
      ),
    );
  }
}