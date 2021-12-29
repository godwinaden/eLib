import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elib/components/Translate.dart';
import 'package:elib/components/notelist.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/locale.dart';
import 'package:elib/models/note.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_filereader/flutter_filereader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:open_file/open_file.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReadViewer extends StatefulWidget {
  final LibraryItem item;
  final int location; //1 = offline, 2 = online
  final bool hasStatus;
  final bool isUsed;
  final ItemToUse toUse;
  final UsingAndUsedItem usedOrUsing;

  ReadViewer({
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
    return _ReadViewerState();
  }
}

class _ReadViewerState extends State<ReadViewer> {
  final List locale = locales;
  File item;
  UsingAndUsedItem usedItem;
  String fileExtension;
  PdfController pdfController;
  AudioPlayer _player;
  int _allPagesCount = 0;
  int _actualPageNumber = 0;
  var duration;
  final TextStyle nStyle = new TextStyle(
    decoration: TextDecoration.none,
    fontFamily: 'Avenir',
    fontWeight: FontWeight.w500,
    wordSpacing: 10.0,
    letterSpacing: 2.0,
    fontSize: 14,
    color: Colors.black,
  ), tStyle = new TextStyle(
    decoration: TextDecoration.none,
    fontFamily: 'Noteworthy',
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.pink,
  ), eStyle = new TextStyle(
    decoration: TextDecoration.none,
    fontFamily: 'Lato-Italic',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: Colors.white54,
  ), fStyle = new TextStyle(
    decoration: TextDecoration.none,
    fontFamily: 'Noteworthy',
    fontWeight: FontWeight.w500,
    fontSize: 10,
    color: Colors.white30,
  ), vStyle = new TextStyle(
    decoration: TextDecoration.none,
    fontFamily: 'Palatino',
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontSize: 12,
    color: Colors.white54,
  );

  @override
  void initState() {
    super.initState();
    getUsingFile();
    if(widget.location == 2) {
      getExtension(path: widget.item.itemUrl);
      checkIfAudio();
    }
    if(widget.item.type.toLowerCase()=='audio') _player = AudioPlayer();
    tabData.addListener(() {
      try{
        if(tabData.presentNotes.items.length>0){
          usedItem.notes = tabData.presentNotes;
        }
      }catch(ex){
        print('SetState: $ex');
      }
    });
  }

  void getUsingFile() {
    List<UsingAndUsedItem> usedItems = myStorage.uses.values.toList();
    print("UsedItems: $usedItems");
    try{
      if(widget.isUsed == false){
        if(widget.toUse != null){
          myStorage.toUs.deleteAt(int.parse(widget.toUse.id));
          usedItems.forEach((UsingAndUsedItem ele) {
            if(ele.libraryItemId == widget.item.id){
              usedItem = ele;
            }
          });
        }
      } else {
        if(widget.usedOrUsing != null) usedItem = widget.usedOrUsing;
      }
    }catch(ex){
      print('Exception: $ex');
      usedItems.forEach((UsingAndUsedItem ele) {
        if(ele.libraryItemId == widget.item.id){
          usedItem = ele;
        }
      });
    }
    print("UsedItems: ${int.parse(usedItems.length.toString())}");
    if(usedItem == null) usedItem = new UsingAndUsedItem(
        id: usedItems.length.toString(),
        libraryItemId: widget.item.id,
        location: widget.location,
        status: "Using",
        finishedOn: null,
        lastScrollPosition: 1.0,
        lastUsed: DateTime.now(),
        notes: Notes(items: []),
        startedReading: DateTime.now(),
        timesOpened: 1
    );
    else {
      usedItem.status = 'Using';
      usedItem.lastUsed = DateTime.now();
      usedItem.timesOpened++;
    }
  }

  void updateUsingItem({@required double position}) async {
    usedItem.lastScrollPosition = position;
    await myStorage.uses.putAt(int.parse(usedItem.id), usedItem);
  }

  void updateUsingItemFree() async {
    try{
      int index = int.parse(usedItem.id);
      print("Used Item Index: $index");
      if(myStorage.uses.values.length >= index) await myStorage.uses.putAt(index, usedItem);
    }catch (ex) {
      print("UpdateUsingItemFree: $ex");
    }
  }

  Future<File> decryptItem() async {
    item = File(widget.item.itemUrl);
    getExtension(path: item.path);
    if(isPhone()==false && fileExtension =='pdf') OpenFile.open(item.path);
    return item;
  }

  void checkIfAudio(){
    if(widget.item.type.toLowerCase() == 'audio'){
      duration = widget.location == 1? _player.setFilePath(item.path) : _player.setUrl(iCloud.displayCloudFile(path: widget.item.itemUrl));
    }
  }

  void getExtension({@required String path}){
    try{
      fileExtension = path.split(".").last;
    } catch (ex){
      print("GetExtension: $ex");
    }
  }

  @override
  void dispose() {
    updateUsingItemFree();
    if(widget.item.type.toLowerCase() == 'audio'){
      _player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double height = screen.height, width = screen.width;

    return Scaffold(
      backgroundColor: Color(0xff474747),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      color: Colors.black38,
                      child: Column(
                        children: [
                          SizedBox(height: 25.0),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  width: width/2.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.item.title.toUpperCase(), style: tStyle,),
                                      Text(widget.item.edition, style: eStyle,)
                                    ],
                                  ),
                                ),
                                isPhone()? SizedBox() : Expanded(
                                  child: Container(
                                    width: width/3.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 2.0,
                                          children: [
                                            Translate(text: 'Author:'.toUpperCase(), style: fStyle,),
                                            Text(widget.item.author, style: vStyle,),
                                          ],
                                        ),
                                        Wrap(
                                          spacing: 2.0,
                                          children: [
                                            Translate(text: 'Last Used On:'.toUpperCase(), style: fStyle,),
                                            Text('${usedItem.lastUsed}', style: vStyle,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          )
                        ]
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          child: widget.item.type.toLowerCase() == 'video'?
                          Container(
                            color: Colors.white,
                            child: widget.location == 1?
                            FutureBuilder(
                              future: decryptItem(),
                              builder: (context, AsyncSnapshot<File> snapshot){
                                if(snapshot.hasError) return Translate(
                                  text: 'Oops! The following error occurred. ${snapshot.error}',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                );
                                switch(snapshot.connectionState){
                                  case ConnectionState.waiting: return Center(
                                    child: SpinKitFadingFour(
                                      color: Color(0xff474747),
                                      shape: BoxShape.circle,
                                      size: 40.0,
                                    ),
                                  );
                                  default: {
                                    File dFile = snapshot.data;
                                    return NativeVideoView(
                                      keepAspectRatio: true,
                                      autoHide: true,
                                      showMediaController: true,
                                      enableVolumeControl: true,
                                      onCreated: (controller) {
                                        controller.setVideoSource(
                                          dFile.path,
                                          sourceType: VideoSourceType.file,
                                          requestAudioFocus: true,
                                        );
                                      },
                                      onPrepared: (controller, info) {
                                        if(widget.isUsed) controller.seekTo(usedItem.lastScrollPosition.toInt());
                                        controller.play();
                                      },
                                      onError: (controller, what, extra, message) {
                                        print('Player Error ($what | $extra | $message)');
                                        Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Video Player", desc: message, ).show();
                                      },
                                      onCompletion: (controller) async {
                                        usedItem.lastScrollPosition = (await controller.currentPosition()).toDouble();
                                        usedItem.finishedOn = DateTime.now();
                                        print('Video completed');
                                      },
                                    );
                                  }
                                }
                              },
                            )
                                :
                            NativeVideoView(
                              keepAspectRatio: true,
                              autoHide: true,
                              showMediaController: true,
                              enableVolumeControl: true,
                              onCreated: (controller) {
                                controller.setVideoSource(
                                  iCloud.displayCloudFile(path: widget.item.itemUrl),
                                  sourceType: VideoSourceType.network,
                                  requestAudioFocus: true,
                                );
                              },
                              onPrepared: (controller, info) {
                                if(widget.isUsed) controller.seekTo(usedItem.lastScrollPosition.toInt());
                                controller.play();
                              },
                              onError: (controller, what, extra, message) {
                                print('Player Error ($what | $extra | $message)');
                                Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Video Player", desc: message, ).show();
                              },
                              onCompletion: (controller) async {
                                usedItem.lastScrollPosition = (await controller.currentPosition()).toDouble();
                                usedItem.finishedOn = DateTime.now();
                                print('Video completed');
                              },
                            ),
                          )
                              :
                          (
                              widget.item.type.toLowerCase() == 'audio'?
                              Container(
                                color: Colors.black38,
                                child: widget.location == 1?
                                FutureBuilder(
                                  future: decryptItem(),
                                  builder: (context, AsyncSnapshot<File> snapshot){
                                    if(snapshot.hasError) return Translate(text: 'Oops! The following error occurred. ${snapshot.error}');
                                    switch(snapshot.connectionState){
                                      case ConnectionState.waiting: return Center(
                                        child: SpinKitFadingFour(
                                          color: Color(0xff474747),
                                          shape: BoxShape.circle,
                                          size: 40.0,
                                        ),
                                      );
                                      default: {
                                        File dFile = snapshot.data;
                                        checkIfAudio();
                                        return NativeVideoView(
                                          keepAspectRatio: true,
                                          autoHide: true,
                                          showMediaController: true,
                                          enableVolumeControl: true,
                                          onCreated: (controller) {
                                            controller.setVideoSource(
                                              dFile.path,
                                              sourceType: VideoSourceType.file,
                                              requestAudioFocus: true,
                                            );
                                          },
                                          onPrepared: (controller, info) {
                                            if(widget.isUsed) controller.seekTo(usedItem.lastScrollPosition.toInt());
                                            controller.play();
                                          },
                                          onError: (controller, what, extra, message) {
                                            print('Player Error ($what | $extra | $message)');
                                            Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Video Player", desc: message, ).show();
                                          },
                                          onCompletion: (controller) async {
                                            usedItem.lastScrollPosition = (await controller.currentPosition()).toDouble();
                                            usedItem.finishedOn = DateTime.now();
                                            print('Video completed');
                                          },
                                        );
                                      }
                                    }
                                  },
                                )
                                    :
                                NativeVideoView(
                                  keepAspectRatio: true,
                                  autoHide: true,
                                  showMediaController: true,
                                  enableVolumeControl: true,
                                  onCreated: (controller) {
                                    controller.setVideoSource(
                                      iCloud.displayCloudFile(path: widget.item.itemUrl),
                                      sourceType: VideoSourceType.network,
                                      requestAudioFocus: true,
                                    );
                                  },
                                  onPrepared: (controller, info) {
                                    if(widget.isUsed) controller.seekTo(usedItem.lastScrollPosition.toInt());
                                    controller.play();
                                  },
                                  onError: (controller, what, extra, message) {
                                    print('Player Error ($what | $extra | $message)');
                                    Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Video Player", desc: message, ).show();
                                  },
                                  onCompletion: (controller) async {
                                    usedItem.lastScrollPosition = (await controller.currentPosition()).toDouble();
                                    usedItem.finishedOn = DateTime.now();
                                    print('Video completed');
                                  },
                                ),
                              )
                                  :
                              (
                                  widget.item.type.toLowerCase() == 'art'?
                                  Container(
                                    color: Colors.black38,
                                    child: widget.location == 1?
                                    FutureBuilder(
                                      future: decryptItem(),
                                      builder: (context, AsyncSnapshot<File> snapshot){
                                        if(snapshot.hasError) return Translate(text: 'Oops! The following error occurred. ${snapshot.error}');
                                        switch(snapshot.connectionState){
                                          case ConnectionState.waiting: return Center(
                                            child: SpinKitFadingFour(
                                              color: Color(0xff474747),
                                              shape: BoxShape.circle,
                                              size: 40.0,
                                            ),
                                          );
                                          default: {
                                            File dFile = snapshot.data;
                                            return Image.file(
                                              dFile,
                                              fit: BoxFit.contain,
                                              filterQuality: FilterQuality.high,
                                              errorBuilder: (context, obj, stk){
                                                return Image.asset(
                                                  'assets/images/1.jpg',
                                                  fit: BoxFit.contain,
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                    )
                                        :
                                    CachedNetworkImage(
                                      imageUrl: iCloud.displayCloudFile(path: widget.item.itemUrl),
                                      fit: BoxFit.contain,
                                      errorWidget: (context, obj, stk){
                                        return Image.asset(
                                          "assets/images/1.jpg",
                                          fit: BoxFit.contain,
                                        );
                                      },
                                    ),
                                  )
                                      :
                                  (
                                      widget.location == 1?
                                      FutureBuilder(
                                        future: decryptItem(),
                                        builder: (context, AsyncSnapshot<File> snapshot){
                                          if(snapshot.hasError) return Translate(text: 'Oops! The following error occurred. ${snapshot.error}');
                                          switch(snapshot.connectionState){
                                            case ConnectionState.waiting: return Center(
                                              child: SpinKitFadingCircle(
                                                color: Color(0xff474747),
                                                size: 30.0,
                                              ),
                                            );
                                            default: {
                                              File dFile = snapshot.data; String readString = ''; Uint8List bytes;
                                              bool isPdf = fileExtension == 'pdf'? true : false;
                                              if(isPhone()==false && isPdf == false) readString = dFile.readAsStringSync();
                                              if(isPdf == true) {
                                                pdfController = PdfController(
                                                  document: isPhone()? PdfDocument.openFile(dFile.path) : PdfDocument.openData(dFile.readAsBytesSync()),
                                                  initialPage: widget.isUsed? usedItem.lastScrollPosition.toInt() : 1
                                                );
                                              }
                                              return Container(
                                                width: double.maxFinite,
                                                height: height - (height * 0.05),
                                                color: Colors.white,
                                                child: isPdf?
                                                PdfView(
                                                  controller: pdfController,
                                                  onDocumentLoaded: (PdfDocument doc){
                                                    _allPagesCount = doc.pagesCount;
                                                  },
                                                  onPageChanged: (int page){
                                                    _actualPageNumber = page;
                                                    usedItem.lastScrollPosition = page.toDouble();
                                                    if(page >= _allPagesCount){
                                                      usedItem.finishedOn = DateTime.now();
                                                    }
                                                  },
                                                  onDocumentError: (Object details){
                                                    Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Issues", desc: details.toString(), ).show();
                                                  },
                                                  documentLoader: Center(
                                                    child: SpinKitFadingCircle(
                                                      color: Color(0xff474747),
                                                    ),
                                                  ),
                                                  pageLoader: Center(
                                                    child: SpinKitFadingCircle(
                                                      color: Color(0xff474747),
                                                    ),
                                                  ),
                                                  errorBuilder: (Exception ex){
                                                    Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Issues", desc: ex.toString(), ).show();
                                                    return Center(
                                                      child: Translate(
                                                        text: ex.toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black54
                                                        ),
                                                        align: TextAlign.center,
                                                      ),
                                                    );
                                                  },
                                                  renderer: (PdfPage page) => page.render(
                                                    width: page.width,
                                                    height: page.height,
                                                    format: PdfPageFormat.JPEG,
                                                    backgroundColor: '#FFFFFF',
                                                  ),
                                                )
                                                    :
                                                SingleChildScrollView(
                                                  padding: EdgeInsets.all(20.0),
                                                  child: isPhone()?
                                                  FileReaderView(
                                                    filePath: dFile.path,
                                                    loadingWidget: SpinKitFadingFour(color: Color(0xff474747), shape: BoxShape.circle, size: 40,),
                                                    unSupportFileWidget: Center(
                                                      child: Column(
                                                        children: [
                                                          Icon(Icons.auto_fix_off, color: Colors.black12, size: 80,),
                                                          Translate(
                                                            text: 'Oops! Unsupported File Format.',
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: "Oswald-Regular",
                                                                color: Colors.black12,
                                                                decoration: TextDecoration.none
                                                            ),
                                                            align: TextAlign.center,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                      :
                                                  Text(
                                                    readString,
                                                    style: nStyle,
                                                  ),
                                                )
                                              );
                                            }
                                          }
                                        },
                                      )
                                          :
                                      Container(
                                          color: Colors.white,
                                          width: double.maxFinite,
                                          height: height-(height*0.1),
                                          child: isPhone()?
                                          (
                                              fileExtension == 'pdf'?
                                              PDF(
                                                enableSwipe: true,
                                                swipeHorizontal: true,
                                                autoSpacing: false,
                                                pageFling: false,
                                                defaultPage: widget.isUsed? usedItem.lastScrollPosition.toInt() : 0,
                                                onViewCreated: (PDFViewController control) async {
                                                  _allPagesCount = await control.getPageCount();
                                                },
                                                onError: (error) {
                                                  print(error.toString());
                                                },
                                                onPageError: (page, error) {
                                                  print('$page: ${error.toString()}');
                                                },
                                                onPageChanged: (int page, int total) {
                                                  _actualPageNumber = page;
                                                  usedItem.lastScrollPosition = page.toDouble();
                                                  if(page >= _allPagesCount){
                                                    usedItem.finishedOn = DateTime.now();
                                                  }
                                                },
                                              ).cachedFromUrl(
                                                  iCloud.displayCloudFile(path: widget.item.itemUrl),
                                                  placeholder: (progress) => Center(
                                                    child: SpinKitFadingCircle(
                                                      color: Color(0xff474747),
                                                    ),
                                                  ),
                                                  errorWidget: (ex){
                                                    Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Network Issues", desc: ex.toString(), ).show();
                                                    return Center(
                                                      child: Translate(
                                                        text: ex.toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black54
                                                        ),
                                                        align: TextAlign.center,
                                                      ),
                                                    );
                                                  },
                                              )
                                                  :
                                              SingleChildScrollView(
                                                padding: EdgeInsets.all(20.0),
                                                child: FileReaderView(
                                                  filePath: widget.item.itemUrl,
                                                  loadingWidget: SpinKitFadingFour(color: Color(0xff474747), shape: BoxShape.circle, size: 40,),
                                                  unSupportFileWidget: Center(
                                                    child: Column(
                                                      children: [
                                                        Icon(Icons.auto_fix_off, color: Colors.black12, size: 80,),
                                                        Translate(
                                                          text: 'Oops! Unsupported File Format.',
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: "Oswald-Regular",
                                                              color: Colors.black12,
                                                              decoration: TextDecoration.none
                                                          ),
                                                          align: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                          )
                                              :
                                          (
                                              fileExtension == 'pdf'?
                                              Container()
                                                  :
                                              Container()
                                          ),
                                      )
                                  )
                              )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            isPhone()? SizedBox() : Container(
              width: 350.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30, width: 5.0),
                color: Colors.white30
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    color: Colors.black12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Translate(text: 'My Notes'.toUpperCase(), style: nStyle,),
                        Wrap(
                          spacing: 2.0,
                          children: [
                            IconButton(
                              iconSize: 20,
                              icon: Icon(Icons.arrow_back_ios_sharp),
                              color: Colors.black54,
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              highlightColor: Colors.black45.withOpacity(0.7),
                              tooltip: 'Back',
                            ),
                            IconButton(
                              iconSize: 20,
                              icon: Icon(Icons.post_add),
                              color: Colors.black54,
                              tooltip: 'Add New Note',
                              onPressed: (){
                                try{
                                  usedItem.notes.items.add(Note(
                                      usingOrUsedId: usedItem.id,
                                      content: '',
                                      dateCreated: DateTime.now(),
                                      lastEditedOn: DateTime.now(),
                                      id: '${new Random().nextInt(9999999)}'
                                  ));
                                  tabData.updateNotes(notes: usedItem.notes);
                                } catch(ex){
                                  print('IconButton Add: $ex');
                                }
                              },
                              highlightColor: Colors.black45.withOpacity(0.7),
                            ),
                            IconButton(
                              iconSize: 20,
                              icon: Icon(FeatherIcons.trash),
                              color: Colors.black54,
                              tooltip: 'Delete New Note',
                              onPressed: (){
                                try{
                                  usedItem.notes.items.removeLast();
                                } catch(ex){
                                  print('IconButton Add: $ex');
                                }
                              },
                              highlightColor: Colors.black45.withOpacity(0.7),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListNotes(notes: usedItem.notes, height: height,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}