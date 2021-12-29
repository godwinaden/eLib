import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elib/components/document_type.dart';
import 'package:elib/components/item_type.dart';
import 'package:elib/components/status.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:elib/pages/read/library_item_detail.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'delete.dart';

// ignore: must_be_immutable
class LibraryItemComponent extends StatelessWidget{

  final LibraryItem libraryItem;
  final int location; //1 = offline 2 = online
  final bool hasStatus;
  final bool isUsed;
  final ItemToUse toUse;
  final UsingAndUsedItem usedOrUsing;
  final BorderRadius borderRadius = BorderRadius.all(Radius.circular(20.0));

  File coverFile;

  LibraryItemComponent({
    @required this.libraryItem,
    this.location: 1,
    this.hasStatus: false,
    this.isUsed,
    this.usedOrUsing,
    this.toUse,
  });

  Future<bool> getFilePath() async{
    File decrypted = myStorage.getADecryptedFile(testPath: libraryItem.coverImageUrl);
    coverFile = decrypted == null?
    ((await myStorage.decryptFile(path: libraryItem.coverImageUrl)) ??
        File("documents/elibs/cover/any.jpg")) : decrypted;
    myStorage.addDecryptedFile(
      decrypted: new AlreadyDecrypted(
        path: libraryItem.coverImageUrl,
        decryptedPath: coverFile.path
      )
    );
    return true;
  }

  String getExtention({@required String path}){
    String result = '';
    try{
      if(path != null && path != ''){
        if(location == 1){
          result = path.split('/').last;
          List lStr = result.split('.');
          result = lStr[1];
        }else{
          result = path.split('.').last;
        }
      }
    } catch(ex){
      print('GetExtension: $ex');
    }
    return result;
  }

  bool isMedia(){
    bool isTrue = false;
    if(libraryItem != null && libraryItem.type != null) isTrue = libraryItem.type.toLowerCase() == 'video' || libraryItem.type.toLowerCase() == 'audio'? true : false;
    return isTrue;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () => tabData.updateWidget(widget: LibraryItemDetail(
            item: location == 2? libraryItem : new LibraryItem(
                id: libraryItem.id,
                title: libraryItem.title,
                type: libraryItem.type,
                edition: libraryItem.edition,
                addedOn: libraryItem.addedOn,
                author: libraryItem.author,
                category: libraryItem.category,
                itemUrl: libraryItem.itemUrl,
                coverImageUrl: coverFile.path
            ),
            location: location,
            hasStatus: hasStatus,
            isUsed: isUsed,
            toUse: toUse,
            usedOrUsing: usedOrUsing,
          )),
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: borderRadius,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10.0),
                    height: 200,
                    width: isMedia()? 300:140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(-2,-2), blurRadius: 0.5, spreadRadius: 3),
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(-2,2), blurRadius: 0.5, spreadRadius: 3),
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(2,2), blurRadius: 0.5, spreadRadius: 3),
                        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(2,-2), blurRadius: 0.5, spreadRadius: 3),
                      ],
                    ),
                    child: ClipRRect(
                        borderRadius: borderRadius,
                        child: location == 1?
                        FutureBuilder(
                          future: getFilePath(),
                          builder: (context, AsyncSnapshot<bool> snapshot){
                            if(snapshot.hasError) return Image.asset(
                              "assets/images/g.jpg",
                              height: 200,
                              width: 130,
                              fit: BoxFit.cover,
                              alignment: Alignment.centerRight,
                            );
                            switch(snapshot.connectionState){
                              case ConnectionState.waiting: return Center(
                                child: SpinKitFadingCircle(
                                    color: Color(0xff474747),
                                    size: 35.0
                                ),
                              );
                              default: {
                                return isMedia()?
                                Stack(
                                  children: [
                                    Image.file(
                                      coverFile,
                                      errorBuilder: (context, obj, stk){
                                        return Image.asset(
                                          "assets/images/g.jpg",
                                          height: 200,
                                          width: 300,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.centerRight,
                                        );
                                      },
                                      height: 200,
                                      width: 300,
                                      fit: BoxFit.cover,
                                    ),
                                    Center(
                                        child: Image.asset(
                                            'assets/images/video.png',
                                            width: 40.0,
                                            height: 40.0,
                                            fit: BoxFit.contain
                                        )
                                    )
                                  ],
                                )
                                    :
                                Image.file(
                                  coverFile,
                                  errorBuilder: (context, obj, stk){
                                    return Image.asset(
                                      "assets/images/g.jpg",
                                      height: 200,
                                      width: 130,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerRight,
                                    );
                                  },
                                  height: 200,
                                  width: 130,
                                  fit: BoxFit.cover,
                                );
                              }
                            }
                          },
                        )
                            :
                        (
                            isMedia()?
                            Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: iCloud.displayCloudFile(path: libraryItem.coverImageUrl),
                                  height: 200,
                                  width: 300,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, obj, stk){
                                    return Image.asset(
                                      "assets/images/g.jpg",
                                      height: 200,
                                      width: 130,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerRight,
                                    );
                                  },
                                ),
                                Center(
                                    child: Image.asset(
                                        'assets/images/video.png',
                                        width: 40.0,
                                        height: 40.0,
                                        fit: BoxFit.contain
                                    )
                                )
                              ],
                            )
                                :
                            CachedNetworkImage(
                              imageUrl: iCloud.displayCloudFile(path: libraryItem.coverImageUrl),
                              height: 200,
                              width: 130,
                              fit: BoxFit.cover,
                              errorWidget: (context, obj, stk){
                                return Image.asset(
                                  "assets/images/g.jpg",
                                  height: 200,
                                  width: 130,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerRight,
                                );
                              },
                            )
                        )

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: DocumentType(type: getExtention(path: libraryItem.itemUrl),),
                  ),
                  hasStatus?
                  Padding(
                    padding: EdgeInsets.only(top: 63.0),
                    child: ItemStatus(status: isUsed? usedOrUsing.status : 'Pending',),
                  )
                      :
                  SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(top: 106),
                    child: libraryItem.type==null? SizedBox() : ItemType(type: libraryItem.type,),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                width: 180,
                child: Column(
                  children: [
                    Text(
                      myStorage.getSubString(text: libraryItem.title, limit: 40),
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Lato-Italic",
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 3.0,),
                    Text(
                      myStorage.getSubString(text: libraryItem.edition, limit: 40),
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: "NexaDemo-Light",
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        location == 1?
        Padding(
          padding: EdgeInsets.only(left: 10, top: 149),
          child: DeleteItem(
            item: toUse != null? toUse : (usedOrUsing != null? usedOrUsing : libraryItem),
            type: toUse != null? 1 : (usedOrUsing != null? 2 : 0),
          ),
        ) : (
            hasStatus?
            Padding(
              padding: EdgeInsets.only(left: 10, top: 149),
              child: DeleteItem(
                item: toUse != null? toUse : (usedOrUsing != null? usedOrUsing : libraryItem),
                type: toUse != null? 1 : (usedOrUsing != null? 2 : 0),
              ),
            ): SizedBox()
        ),
      ],
    );
  }
}