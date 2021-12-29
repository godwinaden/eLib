import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elib/components/Translate.dart';
import 'package:elib/components/page_transitions/scale.dart';
import 'package:elib/components/read_component.dart';
import 'package:elib/components/upload_task.dart';
import 'package:elib/models/country.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:elib/pages/read/read.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LibraryItemDetail extends StatefulWidget {

  final LibraryItem item;
  final int location; //1 = offline, 2 = online
  final bool hasStatus;
  final bool isUsed;
  final ItemToUse toUse;
  final UsingAndUsedItem usedOrUsing;

  LibraryItemDetail({
    Key key,
    @required this.item,
    this.location: 1,
    this.isUsed,
    this.toUse,
    this.usedOrUsing,
    this.hasStatus
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LibraryItemDetailState();
  }
}

class _LibraryItemDetailState extends State<LibraryItemDetail> {

  File itemFile;
  File coverFile;
  bool loading = false;
  bool decrypting = false;
  bool hasDownloaded = false;
  final TextStyle tStyle = new TextStyle(
    fontFamily: 'NexaDemo-Light',
    fontWeight: FontWeight.bold,
    fontSize: isPhone()? 25 : 23,
    decoration: TextDecoration.none,
    color: Colors.black,
  ), eStyle = new TextStyle(
    fontFamily: 'Lato-Italic',
    fontWeight: FontWeight.bold,
    fontSize: isPhone()? 20 : 18,
    decoration: TextDecoration.none,
    color: Colors.black54,
  ), vStyle = new TextStyle(
    fontFamily: 'NexaDemo-Bold',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    decoration: TextDecoration.none,
    color: Colors.pink,
  ), nStyle = new TextStyle(
    fontFamily: 'Oswald-Regular',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    decoration: TextDecoration.none,
    color: Colors.black54,
  ), bStyle = new TextStyle(
    fontFamily: 'Oswald-Regular',
    fontWeight: FontWeight.w500,
    fontSize: 20,
    decoration: TextDecoration.none,
    color: Colors.white,
  );
  ReadViewer viewer;

  Future<bool> getFilePath() async {
    try{
      coverFile = File(widget.item.coverImageUrl);
    } catch(ex){
      print("Decryption: Details: $ex");
    }
    return true;
  }

  bool isUsing(){
    bool using = false;
    try{
      UsingAndUsedItem uses = myStorage.uses.values.firstWhere((_) => _.libraryItemId == widget.item.id, orElse: () => null);
      if(uses != null && uses.id != null) using = true;
    } catch(ex){
      print("Details: isUsing: $ex");
    }
    return using;
  }

  bool isToRead(){
    bool added = false;
    try{
      ItemToUse tos = myStorage.toUs.values.firstWhere((_) => _.libraryItemId == widget.item.id, orElse: () => null);
      if(tos != null && tos.id != null) added = true;
    }catch(ex){
      print("Details: isToRead: $ex");
    }
    return added;
  }

  bool checkIfDownloaded(){
    LibraryItem lItem = myStorage.libs.values.firstWhere((_) => _.id == widget.item.id, orElse: () => null);
    return lItem == null? false : true;
  }

  void goBack() {
    tabData.updateWidget(widget: tabData.lastWidget);
  }

  Future<void> _download() async {
    if(hasDownloaded == false){
      String msg = ''; AlertType msgType = AlertType.info;
      try{
        setState(() => loading = true);
        if(widget.item != null && widget.location == 2){
          RestUploadTask upTask = new RestUploadTask(hasErrors: false, filePath: widget.item.itemUrl, coverPath: widget.item.coverImageUrl);
          RestDownloadTask downloaded = await iCloud.downloadFileFromRest(task: upTask);
          if(downloaded.hasError){
            msg = "Could not download the files. The following error(s) occurred: ${downloaded.errors}";
            msgType = AlertType.error;
          }else{
            if(mounted) setState(() => hasDownloaded = true);
            LibraryItem newItem = new LibraryItem(
              id: widget.item.id,
              type: widget.item.type,
              author: widget.item.author,
              addedOn: widget.item.addedOn,
              coverImageUrl: downloaded.encryptedCoverPath,
              title: widget.item.title,
              edition: widget.item.edition,
              category: widget.item.category,
              itemUrl: downloaded.encryptedFilePath
            );
            await myStorage.addItemToLibraryStore(item: newItem);
            msg = "Library Item has been successfully downloaded.";
            msgType = AlertType.success;
          }
        }else{
          msg = "Item already exist locally";
        }
      } catch(ex){
        msg = "Error: $ex";
        msgType = AlertType.error;
      }
      setState(() => loading = false);
      Alert(context: context, style: myStorage.alertStyle, type: msgType, title: "Download", desc: msg, ).show();
    }
  }

  void deleteDecryptedFile() async {
    if(widget.location == 1){
      try{
        await itemFile.delete();
        await coverFile.delete();
      } catch(ex){
        print("Decryption: Details: $ex");
      }
    }
  }

  @override
  void initState() {
    hasDownloaded = checkIfDownloaded();
    super.initState();
    viewer = ReadViewer(
      item: widget.item,
      location: widget.location,
      hasStatus: widget.hasStatus,
      isUsed: widget.isUsed,
      toUse: widget.toUse,
      usedOrUsing: widget.usedOrUsing,
    );
  }

  @override
  void dispose() {
    deleteDecryptedFile();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double height = screen.height, width = screen.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.location == 1?
      FutureBuilder(
        future: getFilePath(),
        builder: (context, AsyncSnapshot<bool> snapshot){
          if(snapshot.hasError) return Translate(text: "Some Errors Occurred: ${snapshot.error}");
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return Center(
              child: SpinKitFadingCircle(
                  color: Color(0xff474747),
              ),
            );
            default: return Stack(
              children: [
                Image.file(
                  coverFile,
                  colorBlendMode: BlendMode.screen,
                  height: height,
                  width: width,
                  errorBuilder: (context, obj, stk){
                    return Image.asset(
                      "assets/images/g.jpg",
                      fit: BoxFit.cover,
                      alignment: Alignment.centerRight,
                      height: height,
                      width: width,
                    );
                  },
                  fit: BoxFit.cover,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black54
                    ),
                    height: height,
                    width: width,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: isPhone()? 0.0 : 25.0, top: isPhone()? 150: 75, right: isPhone()? 0.0 : 20.0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: isPhone()? height : 300.0),
                              child: Container(
                                padding: EdgeInsets.all(isPhone()? 5.0 : 10.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 0.9),
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Column(
                                  children: [
                                    Flex(
                                      direction: Axis.horizontal,
                                      mainAxisAlignment: isPhone()? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                                      children: [
                                        isPhone()? SizedBox() : Container(
                                          margin: EdgeInsets.only(left: 100),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.item.title,
                                                style: tStyle,
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                widget.item.edition,
                                                style: eStyle,
                                                textAlign: TextAlign.left,
                                              )
                                            ],
                                          ),
                                        ),
                                        isPhone()? SizedBox() : Wrap(
                                          spacing: 15.0,
                                          runSpacing: 5.0,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    widget.item.author,
                                                    style: nStyle,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Translate(
                                                  text: 'Author'.toUpperCase(),
                                                  style: vStyle,
                                                  align: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  widget.item.category,
                                                  style: nStyle,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Translate(
                                                  text: 'Category'.toUpperCase(),
                                                  style: vStyle,
                                                  align: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  widget.item.type,
                                                  style: nStyle,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Translate(
                                                  text: 'Type'.toUpperCase(),
                                                  style: vStyle,
                                                  align: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(10.0),
                                            child: Wrap(
                                              spacing: 10.0,
                                              runSpacing: 10.0,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.star_border),
                                                  iconSize: 30,
                                                  focusColor: Colors.black,
                                                  hoverColor: Colors.pink,
                                                  splashColor: Colors.blue,
                                                  color: Colors.black38,
                                                  tooltip: 'Add To Favorite!',
                                                  onPressed: (){

                                                  },
                                                ),
                                                loading?
                                                Padding(
                                                  padding: EdgeInsets.only(top: 10.0),
                                                  child: SpinKitFadingCircle(
                                                    size: 30,
                                                    color: Color(0xff474747),
                                                  ),
                                                )
                                                    :
                                                IconButton(
                                                  icon: Icon(Icons.cloud_download_outlined),
                                                  iconSize: 30,
                                                  color: Colors.black38,
                                                  tooltip: 'Download To My Library!',
                                                  onPressed: _download,
                                                ),
                                                IconButton(
                                                  icon: Icon(FeatherIcons.clock),
                                                  iconSize: 30,
                                                  color: isToRead()? Colors.black38 : Colors.blue,
                                                  tooltip: 'Read Later',
                                                  onPressed: () async {
                                                    print("ItemToRead: id: ${widget.item.id}");
                                                    ItemToUse toUse = new ItemToUse(
                                                        id: myStorage.toUs.values.length.toString(),
                                                        libraryItemId: widget.item.id,
                                                        status: 'Pending',
                                                        location: widget.location,
                                                        selectedOn: DateTime.now()
                                                    );
                                                    bool added = await myStorage.addItemToUseStore(item: toUse);
                                                    String msg = 'Unable To Complete Operation. Try Again Later';
                                                    if(added){
                                                      msg = 'Added To Store';
                                                      Alert(context: context, style: myStorage.alertStyle, type: AlertType.success, title: "To Read Later", desc: msg, ).show();
                                                    }else{
                                                      Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Issues", desc: msg, ).show();
                                                    }
                                                  },
                                                ),
                                                ReadComponent(
                                                  url: widget.item.itemUrl,
                                                  view: viewer,
                                                  isUsing: isUsing(),
                                                ),
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                    isPhone()?
                                    Container(
                                      width: width-100.0,
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.item.title,
                                            style: tStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            widget.item.edition,
                                            style: eStyle,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    )
                                        :
                                    SizedBox(),
                                    SizedBox(height: 20,),
                                    isPhone()?
                                    Wrap(
                                      spacing: 15.0,
                                      runSpacing: 5.0,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              child: Text(
                                                widget.item.author,
                                                style: nStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Translate(
                                              text: 'Author'.toUpperCase(),
                                              style: vStyle,
                                              align: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              widget.item.category,
                                              style: nStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Translate(
                                              text: 'Category'.toUpperCase(),
                                              style: vStyle,
                                              align: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              widget.item.type,
                                              style: nStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Translate(
                                              text: 'Type'.toUpperCase(),
                                              style: vStyle,
                                              align: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                        :
                                    SizedBox(),
                                    SizedBox(height: 20.0,),
                                    isPhone()?
                                    Column(
                                      children: [
                                        GFButton(
                                          size: 50.0,
                                          padding: EdgeInsets.zero,
                                          fullWidthButton: true,
                                          shape: GFButtonShape.pills,
                                          color: Theme.of(context).buttonColor,
                                          splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                          hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                          child: Translate(text: "Back", style: bStyle,),
                                          onPressed: goBack,
                                          elevation: 0.0,
                                        ),
                                        SizedBox(height: 20),
                                        ReadComponent(
                                          url: widget.item.itemUrl,
                                          view: viewer,
                                          isUsing: isUsing(),
                                          type: 2,
                                        )
                                      ],
                                    )
                                        :
                                    Flex(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      direction: Axis.horizontal,
                                      children: [
                                        GFButton(
                                          size: 50.0,
                                          padding: EdgeInsets.only(left: 90, right: 90),
                                          fullWidthButton: false,
                                          shape: GFButtonShape.pills,
                                          color: Theme.of(context).buttonColor,
                                          splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                          hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                          child: Translate(text: "Back", style: bStyle,),
                                          onPressed: goBack,
                                          elevation: 0.0,
                                        ),
                                        ReadComponent(
                                          url: widget.item.itemUrl,
                                          view: viewer,
                                          isUsing: isUsing(),
                                          type: 2,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: isPhone()? 30.0 : 50.0, top: isPhone()? 100.0:50.0),
                            child: Container(
                                height: 120.0,
                                width: 80.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.9), width: 7.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  child: widget.location == 1?
                                  Image.file(
                                    coverFile,
                                    errorBuilder: (context, obj, stk){
                                      return Image.asset(
                                        "assets/images/g.jpg",
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerRight,
                                      );
                                    },
                                    fit: BoxFit.cover,
                                  )
                                      :
                                  CachedNetworkImage(
                                    imageUrl: iCloud.displayCloudFile(path: widget.item.coverImageUrl),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, obj, stk){
                                      return Image.asset(
                                        "assets/images/g.jpg",
                                        fit: BoxFit.cover,
                                        alignment: Alignment.centerRight,
                                      );
                                    },
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                )
              ],
            );
          }
        },
      )
          :
      Container(
        decoration: BoxDecoration(
            color: Colors.black38,
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                iCloud.displayCloudFile(path: widget.item.coverImageUrl),
                headers: iCloud.getHttpOptions.headers,
                scale: 1.0,
                errorListener: (){
                  return Image.asset(
                    "assets/images/g.jpg",
                    fit: BoxFit.cover,
                    alignment: Alignment.centerRight,
                  );
                },
              ),
              alignment: Alignment.center,
              fit: BoxFit.cover,
              onError: (obj, sckTrc){
                return Image.asset(
                  "assets/images/g.jpg",
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                );
              },
            )
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black54
          ),
          height: height,
          width: width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: isPhone()? 0.0 : 25.0, top: isPhone()? 150: 75, right: isPhone()? 0.0 : 20.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: isPhone()? height : 300.0),
                    child: Container(
                      padding: EdgeInsets.all(isPhone()? 5.0 : 10.0),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Column(
                        children: [
                          Flex(
                            direction: Axis.horizontal,
                            mainAxisAlignment: isPhone()? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                            children: [
                              isPhone()? SizedBox() : Container(
                                margin: EdgeInsets.only(left: 100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.item.title,
                                      style: tStyle,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      widget.item.edition,
                                      style: eStyle,
                                      textAlign: TextAlign.left,
                                    )
                                  ],
                                ),
                              ),
                              isPhone()? SizedBox() : Wrap(
                                spacing: 15.0,
                                runSpacing: 5.0,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        child: Text(
                                          widget.item.author,
                                          style: nStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Translate(
                                        text: 'Author'.toUpperCase(),
                                        style: vStyle,
                                        align: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.item.category,
                                        style: nStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                      Translate(
                                        text: 'Category'.toUpperCase(),
                                        style: vStyle,
                                        align: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.item.type,
                                        style: nStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                      Translate(
                                        text: 'Type'.toUpperCase(),
                                        style: vStyle,
                                        align: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Wrap(
                                    spacing: 10.0,
                                    runSpacing: 10.0,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.star_border),
                                        iconSize: 30,
                                        focusColor: Colors.black,
                                        hoverColor: Colors.pink,
                                        splashColor: Colors.blue,
                                        color: Colors.black38,
                                        tooltip: 'Add To Favorite!',
                                        onPressed: (){

                                        },
                                      ),
                                      loading?
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: SpinKitFadingCircle(
                                          size: 30,
                                          color: Color(0xff474747),
                                        ),
                                      )
                                          :
                                      IconButton(
                                        icon: Icon(Icons.cloud_download_outlined),
                                        iconSize: 30,
                                        color: hasDownloaded? Colors.black38: Colors.blue,
                                        tooltip: 'Download To My Library!',
                                        onPressed: _download,
                                      ),
                                      IconButton(
                                        icon: Icon(FeatherIcons.clock),
                                        iconSize: 30,
                                        color: isToRead()? Colors.black38 : Colors.blue,
                                        tooltip: 'Read Later',
                                        onPressed: () async {
                                          print("ItemToRead: id: ${widget.item.id}");
                                          ItemToUse toUse = new ItemToUse(
                                              id: myStorage.toUs.values.length.toString(),
                                              libraryItemId: widget.item.id,
                                              status: 'Pending',
                                              location: widget.location,
                                              selectedOn: DateTime.now()
                                          );
                                          bool added = await myStorage.addItemToUseStore(item: toUse);
                                          String msg = 'Unable To Complete Operation. Try Again Later';
                                          if(added){
                                            msg = 'Added To Store';
                                            Alert(context: context, style: myStorage.alertStyle, type: AlertType.success, title: "To Read Later", desc: msg, ).show();
                                          }else{
                                            Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Issues", desc: msg, ).show();
                                          }

                                        },
                                      ),
                                      ReadComponent(
                                        url: widget.item.itemUrl,
                                        view: viewer,
                                        isUsing: isUsing(),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                          isPhone()?
                          Container(
                            width: width-100.0,
                            child: Column(
                              children: [
                                Text(
                                  widget.item.title,
                                  style: tStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.item.edition,
                                  style: eStyle,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                              :
                          SizedBox(),
                          SizedBox(height: 20,),
                          isPhone()?
                          Wrap(
                            spacing: 15.0,
                            runSpacing: 5.0,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      widget.item.author,
                                      style: nStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Translate(
                                    text: 'Author'.toUpperCase(),
                                    style: vStyle,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    widget.item.category,
                                    style: nStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Translate(
                                    text: 'Category'.toUpperCase(),
                                    style: vStyle,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    widget.item.type,
                                    style: nStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  Translate(
                                    text: 'Type'.toUpperCase(),
                                    style: vStyle,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          )
                              :
                          SizedBox(),
                          SizedBox(height: 20.0,),
                          isPhone()?
                          Column(
                            children: [
                              GFButton(
                                size: 50.0,
                                padding: EdgeInsets.zero,
                                fullWidthButton: true,
                                shape: GFButtonShape.pills,
                                color: Theme.of(context).buttonColor,
                                splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                child: Translate(text: "Back", style: bStyle,),
                                onPressed: goBack,
                                elevation: 0.0,
                              ),
                              SizedBox(height: 20),
                              ReadComponent(
                                url: widget.item.itemUrl,
                                view: viewer,
                                isUsing: isUsing(),
                                type: 2,
                              )
                            ],
                          )
                              :
                          Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: [
                              GFButton(
                                size: 50.0,
                                padding: EdgeInsets.only(left: 90, right: 90),
                                fullWidthButton: false,
                                shape: GFButtonShape.pills,
                                color: Theme.of(context).buttonColor,
                                splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                                child: Translate(text: "Back", style: bStyle,),
                                onPressed: goBack,
                                elevation: 0.0,
                              ),
                              ReadComponent(
                                url: widget.item.itemUrl,
                                view: viewer,
                                isUsing: isUsing(),
                                type: 2,
                              )

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, top: isPhone()? 100.0:50.0),
                  child: Container(
                      height: 120.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.9), width: 7.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: widget.location == 1?
                        Image.file(
                          coverFile,
                          errorBuilder: (context, obj, stk){
                            return Image.asset(
                              "assets/images/g.jpg",
                              fit: BoxFit.cover,
                              alignment: Alignment.centerRight,
                            );
                          },
                          fit: BoxFit.cover,
                        )
                            :
                        CachedNetworkImage(
                          imageUrl: iCloud.displayCloudFile(path: widget.item.coverImageUrl),
                          fit: BoxFit.cover,
                          errorWidget: (context, obj, stk){
                            return Image.asset(
                              "assets/images/g.jpg",
                              fit: BoxFit.cover,
                              alignment: Alignment.centerRight,
                            );
                          },
                        ),
                      )
                  ),
                ),
              ],
            ),
          )
        ),
      )
    );
  }
}