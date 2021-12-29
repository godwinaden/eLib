import 'package:elib/components/Translate.dart';
import 'package:elib/components/note_component.dart';
import 'package:elib/models/note.dart' as NoteModel;
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_animator/widgets/in_out_animation.dart';

class Notes extends StatefulWidget {

  Notes({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<Notes> {
  NoteModel.Notes itemNotes = tabData.presentNotes;

  @override
  void initState() {
    super.initState();
    tabData.addListener(() {
      try{
        if(mounted) setState(() => itemNotes = tabData.presentNotes);
      } catch(ex){
        print("Notes: SetState: $ex");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    int itemIndex = 0;
    return Container(
      height: height,
      width: width,
      color: Colors.white,
      child: itemNotes.items.length > 0?
      SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: itemNotes.items.map((NoteModel.Note item){
            itemIndex++;
            return InOutAnimation(
                child: Container(
                  width: 350,
                  child: NoteComponent(
                    note: item,
                    index: itemIndex - 1,
                    makeBackgroundWhite: true,
                    fold: false,
                  ),
                ),
                inDefinition: SlideInRightAnimation(),
                outDefinition: SlideOutLeftAnimation()
            );
          }).toList(),
        ),
      )
          :
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage("assets/images/notes.png"),
              color: Colors.black38,
              size: 64.0,
            ),
            SizedBox(height: 30,),
            Translate(
              text: "Oops! Empty Notes!",
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black38,
                decoration: TextDecoration.none,
                letterSpacing: 2.0,
                wordSpacing: 5.0,
                fontWeight: FontWeight.w500,
                fontFamily: "Futura"
              ),
              align: TextAlign.center,
            ),
            SizedBox(height: 7,),
            Container(
              width: 350,
              child: Translate(
                text: "It's either you are not presently reading/using a library item or you don't have any note for any item.",
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black45,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500,
                ),
                align: TextAlign.center,
              ),
            )
          ],
        ),
      )
    );
  }
}