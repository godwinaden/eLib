import 'package:elib/components/localAutomatedList.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/in_out_animation.dart';
import 'package:flutter_animator/widgets/sliding_entrances/slide_in_right.dart';
import 'package:flutter_animator/widgets/sliding_exits/slide_out_left.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'Translate.dart';
import 'automated_list.dart';

class LocalLibrary extends StatefulWidget {
  final int box; //0 => toUs, 1 => uses, 2 => libs

  LocalLibrary({Key key, @required this.box}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocalLibraryState();
  }
}

class _LocalLibraryState extends State<LocalLibrary> {
  final TextStyle tStyle = new TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  final TextStyle nStyle = new TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  final TextStyle sStyle = new TextStyle(
    color: Colors.black26,
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
  );

  final TextStyle vStyle = new TextStyle(
    color: Colors.black26,
    fontFamily: "Oswald-Regular",
    fontWeight: FontWeight.w400,
    fontSize: 22.0,
  );
  TextEditingController controller = new TextEditingController();
  FocusNode focusNode;
  int totalItems = 0;
  String searchValue = '';
  List<dynamic> itemsFound = [];

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    setState(() {
      switch(widget.box){
        case 0: {
          totalItems = myStorage.toUs.values.length;
          break;
        }
        case 1: {
          totalItems = myStorage.uses.values.length;
          break;
        }
        default: {
          totalItems = myStorage.libs.values.length;
          break;
        }
      }
    });
  }

  @override
  void dispose() {
    searchValue = "";
    controller.text = "";
    focusNode.dispose();
    super.dispose();
  }

  void _refresh(){
    try{
      Future.delayed(Duration.zero, () => setState(() {
        searchValue = "";
        controller.text = "";
        itemsFound = [];
      }));
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    }catch(ex){
      print('setState: $ex');
    }
  }

  void _search(){
    try{
      List<dynamic> lList = widget.box == 0? myStorage.toUs.values.toList(): (widget.box == 1? myStorage.uses.values.toList() : myStorage.libs.values.toList());
      if(searchValue != null && searchValue != ""){
        List<dynamic> newList = [];
        if(lList.length > 0){
          switch(widget.box){
            case 2: {
              lList.forEach((item) {
                if((item.type.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                    || (item.category.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                    || (item.author.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                    || (item.title.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                    || (item.edition.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)) newList.add(item);
              });
              break;
            }
            default: {
              LibraryItem libItem;
              lList.forEach((item) {
                libItem = item.getItem();
                if(libItem != null){
                  if((libItem.type.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                      || (libItem.category.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                      || (libItem.author.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                      || (libItem.title.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                      || (libItem.edition.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)) newList.add(item);
                }
              });
              break;
            }
          }
        }
        Future.delayed(Duration.zero, () {
          if(mounted) setState(() => itemsFound = newList);
        });
      }
    }catch(ex){
      print('_search: $ex');
    }

  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    double width = screen.width, height = screen.height;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            InOutAnimation(
              child: Container(
                margin: isPhone()? EdgeInsets.only(top: 20.0) : EdgeInsets.zero,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.black12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Translate(
                      text: widget.box == 0? 'Items To Use' : (widget.box == 1? 'Already Used And Using Items' : 'Local Library'),
                      style: tStyle,
                    ),
                    isPhone()? SizedBox() : Container(
                      width: 350,
                      child: FormBuilder(
                        autovalidateMode: AutovalidateMode.disabled,
                        child: FormBuilderTextField(
                          attribute: "search",
                          focusNode: focusNode,
                          controller: controller,
                          enabled: true,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x4437474F),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.all(Radius.circular(50.0))
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink),
                                borderRadius: BorderRadius.all(Radius.circular(50.0))
                            ),
                            suffixIcon: Wrap(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.search),
                                  color: Colors.black54,
                                  onPressed: _search,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: IconButton(
                                    icon: Icon(Icons.refresh),
                                    color: Colors.black54,
                                    onPressed: _refresh,
                                  ),
                                )
                              ],
                            ),
                            border: InputBorder.none,
                            hintText: "Search...",
                            hintStyle: new TextStyle(color: Colors.black54),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 20,
                              top: 14,
                              bottom: 14,
                            ),
                          ),
                          style: TextStyle(decoration: TextDecoration.none,fontSize: 16, color: Colors.grey[600]),
                          onChanged: (value){
                            searchValue = value;
                            _search();
                          },
                          valueTransformer: (text) => num.tryParse(text),
                        ),
                      ),
                    ),
                    Text('$totalItems Items', style: nStyle,)
                  ],
                ),
              ),
              inDefinition: SlideInRightAnimation(),
              outDefinition: SlideOutLeftAnimation(),
            ),
            SizedBox(height: 20.0,),
            isPhone()? Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: FormBuilderTextField(
                attribute: "search",
                focusNode: focusNode,
                controller: controller,
                enabled: true,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                  ),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                  ),
                  suffixIcon: Wrap(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.black45,
                        onPressed: _search,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.black45,
                          onPressed: _refresh,
                        ),
                      )
                    ],
                  ),
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: new TextStyle(color: Colors.black45),
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 20,
                    top: 14,
                    bottom: 14,
                  ),
                ),
                style: TextStyle(decoration: TextDecoration.none,fontSize: 16, color: Colors.grey[600]),
                onChanged: (value){
                  searchValue = value;
                  _search();
                },
                valueTransformer: (text) => num.tryParse(text),
              ),
            ) : SizedBox(),
            searchValue == ""?
            WatchBoxBuilder(
                box: widget.box == 0? myStorage.toUs : ( widget.box == 1? myStorage.uses : myStorage.libs),
                builder: (context, box){
                  switch(widget.box){
                    case 0: {
                      List<ItemToUse> tos = box.values.toList();
                      tos = new List.from(tos.reversed);
                      return tos != null && tos.length>0?
                      LocalAutomatedList(
                        isUsed: false,
                        toUses: tos,
                        usedOrUsings: [],
                      )
                          :
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Istos.bookmark, color: Colors.black38, size: 60,),
                            SizedBox(height: 15,),
                            Translate(text: widget.box == 0? 'To Read/Use Library Items': ( widget.box == 1? 'Using/Used Library Items' : 'Local Library'), align: TextAlign.center, style: vStyle,),
                            Translate(text: widget.box == 0? "Click On 'Read Later' To Add Items To This List": ( widget.box == 1? 'Once you use An Item, This List Will Automatically Update.' : 'No Item In The Library Yet! Download Any Book to Fill Up Your Library.'), align: TextAlign.center, style: sStyle,),
                          ],
                        ),
                      );
                    }
                    case 1: {
                      List<UsingAndUsedItem> uses = box.values.toList();
                      uses = new List.from(uses.reversed);
                      return uses != null && uses.length>0?
                      LocalAutomatedList(
                        isUsed: true,
                        toUses: [],
                        usedOrUsings: uses,
                      )
                          :
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Istos.bookmark, color: Colors.black38, size: 60,),
                            SizedBox(height: 15,),
                            Translate(text: widget.box == 0? 'To Read/Use Library Items': ( widget.box == 1? 'Using/Used Library Items' : 'Local Library'), align: TextAlign.center, style: vStyle,),
                            Translate(text: widget.box == 0? "Click On 'Read Later' To Add Items To This List": ( widget.box == 1? 'Once you use An Item, This List Will Automatically Update.' : 'No Item In The Library Yet! Download Any Book to Fill Up Your Library.'), align: TextAlign.center, style: sStyle,),
                          ],
                        ),
                      );
                    }
                    default: {
                      List<LibraryItem> libs = box.values.toList();
                      libs = new List.from(libs.reversed);
                      return libs != null && libs.length>0?
                      AutomatedList(items: libs, color: Colors.black12, location: 1,)
                          :
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Istos.bookmark, color: Colors.black38, size: 60,),
                            SizedBox(height: 15,),
                            Translate(text: widget.box == 0? 'To Read/Use Library Items': ( widget.box == 1? 'Using/Used Library Items' : 'Local Library'), align: TextAlign.center, style: vStyle,),
                            Translate(text: widget.box == 0? "Click On 'Read Later' To Add Items To This List": ( widget.box == 1? 'Once you use An Item, This List Will Automatically Update.' : 'No Item In The Library Yet! Download Any Book to Fill Up Your Library.'), align: TextAlign.center, style: sStyle,),
                          ],
                        ),
                      );
                    }
                  }
                }
            )
                :
            (
                itemsFound.length > 0?
                AutomatedList(items: itemsFound, color: Colors.black12, location: 1,)
                    :
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage('assets/images/bookshelf.png'), color: isPhone()? Colors.black38 : Colors.white38, size: 70.0),
                      SizedBox(height: 15.0,),
                      Translate(text: "Oops! No such item in here!", style: vStyle, align: TextAlign.center,),
                      SizedBox(height: 5.0,),
                      Translate(text: "Try other searches with different parameters.", style: sStyle, align: TextAlign.center,),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}