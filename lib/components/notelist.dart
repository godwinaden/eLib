import 'package:auto_animated/auto_animated.dart';
import 'package:elib/components/note_component.dart';
import 'package:elib/models/note.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';

class ListNotes extends StatefulWidget{
  final Notes notes;
  final double height;

  ListNotes({@required this.notes, @required this.height});

  @override
  State<StatefulWidget> createState() {
    tabData.updateNotes(notes: notes);
    return _ListNotesState();
  }
}

class _ListNotesState extends State<ListNotes>{

  @override
  Widget build(BuildContext context) {
    return AnimateIfVisibleWrapper(
      // Show each item through (default 250)
      showItemInterval: Duration(milliseconds: 150),
      child: Container(
        height: widget.height - 60.0,
        child: ListView.builder(
          itemCount: widget.notes.items.length,
          itemBuilder: (context, index){
            int lastItemIndex = widget.notes.items.length - 1;
            Note note = widget.notes.items[lastItemIndex - index];
            return AnimateIfVisible(
              key: Key('${note.id}'),
              duration: Duration(milliseconds: 500),
              builder: (BuildContext context, Animation<double> animation) =>
                  FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: NoteComponent(note: note, index: lastItemIndex-index,),
                  ),
            );
          },
        ),
      ),
    );
  }
}