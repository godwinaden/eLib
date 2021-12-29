import 'package:elib/models/note.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/shape/gf_button_shape.dart';

import 'Translate.dart';

class NoteComponent extends StatefulWidget{
  final Note note;
  final int index;
  final bool makeBackgroundWhite;
  final bool fold;

  NoteComponent({
    Key key,
    @required this.note,
    @required this.index,
    this.makeBackgroundWhite: false,
    this.fold: true
  }): super(key: key);

  @override
  State<StatefulWidget> createState(){
    return _NoteComponentState();
  }
}

class _NoteComponentState extends State<NoteComponent>{

  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();
  double height = 60.0;
  TextStyle tStyle, nStyle, cStyle, vStyle, dStyle, eStyle;
  String content;

  @override
  void initState() {
    super.initState();
    replaceEnters();
    if(mounted) setState(() {
      tStyle = TextStyle(
          color: widget.makeBackgroundWhite? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Al Nile'
      );
      nStyle = TextStyle(
          color: widget.makeBackgroundWhite? Colors.black54 : Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Superclarendon'
      );
      cStyle = TextStyle(
          color: widget.makeBackgroundWhite? Colors.pink : Colors.amber,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          fontFamily: 'Palatino'
      );
      vStyle = TextStyle(
          color: widget.makeBackgroundWhite? Colors.black38 : Colors.white38,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Lato-Italic'
      );
      dStyle = TextStyle(
          color: widget.makeBackgroundWhite? Colors.black38 : Colors.white38,
          fontSize: 7,
          fontWeight: FontWeight.w500,
          fontFamily: 'Party LET'
      );
      eStyle = TextStyle(
          color: widget.makeBackgroundWhite? Colors.black87 : Colors.white60,
          fontSize: 9,
          fontWeight: FontWeight.w500,
          fontFamily: 'Lato-Italic'
      );
    });
  }

  void replaceEnters(){
    String res = widget.note.content.replaceAll('\n', '');
    res = res ==''? res :
    (
        res.length > 30?
        res.substring(0, 30) + '...'
            :
        res
    );
    if(mounted) setState(() {
      content = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFoldingCell.create(
      key: _foldingCellKey,
      frontWidget: _buildFrontWidget(),
      innerWidget: _buildInnerWidget(),
      unfoldCell: widget.fold,
      cellSize: Size(MediaQuery.of(context).size.width, height),
      animationDuration: Duration(milliseconds: 300),
      borderRadius: 10,
      onOpen: () {
        try{
          Future.delayed(Duration.zero, (){
            if(mounted) setState(() {
              height = 140.0;
            });
          });
        } catch(ex) {
          print('Error Open: $ex');
        }
      },
      onClose: () {
        try{
          Future.delayed(Duration.zero, (){
            if(mounted) setState(() {
              height = 70.0;
            });
          });
        } catch(ex) {
          print('Error Close: $ex');
        }
      },
    );
  }

  void _clear(){
    try{
      Future.delayed(Duration.zero, () {
        if(mounted) setState(() => widget.note.content = "");
      });
    }catch (ex){
      print('_clear: $ex');
    }
  }

  void _delete(){
    try{
      tabData.deleteFromNotes(index: widget.index);
    }catch (ex){
      print('_clear: $ex');
    }
  }

  void _save(){
    try{
      print("Index: ${widget.index}");
      tabData.updateANote(note: widget.note, index: widget.index);
      replaceEnters();
      print("Notes: ${tabData.presentNotes.items}");
      _foldingCellKey?.currentState?.toggleFold();
    }catch (ex){
      print('_clear: $ex');
    }
  }

  Widget _buildFrontWidget(){
    return InkWell(
      onTap: () => _foldingCellKey?.currentState?.toggleFold(),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: widget.makeBackgroundWhite? Color(0xffdbdbdb) : Color(0xff474747),
          boxShadow: widget.makeBackgroundWhite? [
            BoxShadow(color: Colors.black26, offset: Offset(3,-3), blurRadius: 1.5, spreadRadius: 1.5),
          ] : []
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageIcon(AssetImage("assets/images/notes.png",), size: 30, color:widget.makeBackgroundWhite? Colors.black38 : Colors.white38,),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Translate(
                      text: content,
                      style: tStyle,
                    ),
                    SizedBox(width: 10),
                    Text('${widget.note.dateCreated}', style: nStyle,)
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerWidget(){
    return Container(
      padding: EdgeInsets.all(10.0),
      color: widget.makeBackgroundWhite? Color(0xffcfcfcf) : Colors.black54,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FormBuilderTextField(
              initialValue: widget.note.content,
              attribute: "content",
              style: cStyle,
              decoration: InputDecoration(
                labelText: "My Note",
                labelStyle: vStyle,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.makeBackgroundWhite? Color(0xffccc) : Colors.white38),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.makeBackgroundWhite? Color(0xffccc) : Colors.white38),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.black38,
                  onPressed: _clear,
                  padding: EdgeInsets.all(1.0),
                  tooltip: 'Clear',
                ),
              ),
              onChanged: (value){
                widget.note.content = value;
              },
              maxLengthEnforced: true,
              maxLength: 2000,
              enableSuggestions: true,
              enableInteractiveSelection: true,
              autocorrect: true,
              maxLines: 50,
              minLines: 8,
              valueTransformer: (text) => num.tryParse(text),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 5.0,
                        children: [
                          Translate(
                            text: 'Created On: ',
                            style: dStyle,
                          ),
                          Text(
                            widget.note.dateCreated.toIso8601String(),
                            style: eStyle,
                          )
                        ],
                      ),
                      Wrap(
                        spacing: 5.0,
                        children: [
                          Translate(
                            text: 'Last Edited: ',
                            style: dStyle,
                          ),
                          Text(
                            widget.note.lastEditedOn.toIso8601String(),
                            style: eStyle,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Wrap(
                  spacing: 2,
                  children: [
                    IconButton(
                      onPressed: _delete,
                      iconSize: 20.0,
                      color: Colors.black,
                      icon: Icon(FeatherIcons.trash2),
                      padding: EdgeInsets.all(1.0),
                      tooltip: 'Delete',
                    ),
                    IconButton(
                      onPressed: _save,
                      iconSize: 20.0,
                      color: Colors.black,
                      icon: Icon(FeatherIcons.save),
                      padding: EdgeInsets.all(1.0),
                      tooltip: 'Save',
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}