import 'dart:convert';

import 'package:elib/components/Translate.dart';
import 'package:elib/components/automated_list.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/in_out_animation.dart';
import 'package:flutter_animator/widgets/sliding_entrances/slide_in_right.dart';
import 'package:flutter_animator/widgets/sliding_exits/slide_out_left.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class GeneralLibrary extends StatefulWidget {

  GeneralLibrary({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GeneralLibraryState();
  }
}

class _GeneralLibraryState extends State<GeneralLibrary> {
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
  int totalItems = tabData.allLibrary.items.length;
  String searchValue = '';
  List<LibraryItem> itemsFound = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode = FocusNode();
  }

  Future<Library> getLibrary() async{
    Library res = new Library(items: []);
    if(tabData.allLibrary.items.length>0) return tabData.allLibrary;
    else {
      if(useRestApiEnvironment){
        try{
          dynamic response = await iCloud.get(url: 'v2/library');
          final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
          if(decodedResponse != null && decodedResponse["items"] != null && decodedResponse["items"].length>0){
            res = new Library.fromJson(decodedResponse["items"]);
            Future.delayed(Duration.zero, (){
              setState(() {
                totalItems = res.items.length;
              });
            });
            tabData.allLibrary = res;
          }
        } catch(ex){
          print("GetLibrary: $ex");
        }
      }
    }
    return res;
  }

  @override
  void dispose() {
    searchValue = "";
    focusNode.dispose();
    super.dispose();
  }

  void _refresh(){
    try{
      Future.delayed(Duration.zero, () => setState(() {
        searchValue = "";
        itemsFound = [];
      }));
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    } catch(ex){
      print('_refresh: $ex');
    }
  }

  void _search(){
    try{
      if(searchValue != null && searchValue != "" && tabData.allLibrary.items.length > 0){
        List<LibraryItem> lList = tabData.allLibrary.items, newList = [];
        if(lList.length > 0){
          lList.forEach((LibraryItem item) {
            if((item.type.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                || (item.category.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                || (item.author.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                || (item.title.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)
                || (item.edition.toLowerCase().indexOf(searchValue.toLowerCase()) >= 0)) newList.add(item);
          });
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
                      text: 'Cloud Library',
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
            FutureBuilder(
              future: getLibrary(),
              builder: (context, AsyncSnapshot<Library> snapshot){
                if(snapshot.hasError) return Translate(text: 'Errors Found: ${snapshot.error}');
                switch(snapshot.connectionState){
                  case ConnectionState.waiting: return Container(
                    height: 300.0,
                    child: Center(
                      child: SpinKitFadingGrid(
                          color: Color(0xff474747),
                          size: 50.0
                      ),
                    ),
                  );
                  default: {
                    bool notEmpty = snapshot.hasData;
                    int len = snapshot.data.items.length;
                    return notEmpty && len > 0?
                    AutomatedList(items: snapshot.data.items, color: Colors.black12,)
                        :
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(AssetImage('assets/images/bookshelf.png'), color: Colors.white38, size: 70.0),
                          SizedBox(height: 15.0,),
                          Translate(text: "Oops! The Library's Presently Empty!", style: vStyle, align: TextAlign.center,),
                          SizedBox(height: 5.0,),
                          Translate(text: "Items Will Be Added Soon", style: sStyle, align: TextAlign.center,),
                        ],
                      ),
                    );
                  }
                }
              },
            )
                :
            (
                itemsFound.length > 0?
                AutomatedList(items: itemsFound, color: Colors.black12,)
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