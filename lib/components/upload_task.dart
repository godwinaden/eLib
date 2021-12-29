import 'dart:io';

import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:getflutter/getwidget.dart';

import 'Translate.dart';
import 'modal_show.dart';


class RestUploadTask{
  String filePath;
  String coverPath;
  bool hasErrors;
  String errors;

  RestUploadTask({
    @required this.hasErrors,
    this.coverPath: '',
    this.filePath: '',
    this.errors: '',
  });

  Future<dynamic> download() async {

  }

}

class Uploader extends StatelessWidget{

  final String title = "Upload Library Item Files";

  @override
  Widget build(BuildContext context) {
    return ModalShow(
      modalTitle: title,
      buttonTitle: title,
      actions: [
        IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
          iconSize: 30,
          color: Colors.pink,
          splashColor: Colors.pink.withOpacity(0.7),
          hoverColor: Colors.pink.withOpacity(0.7),
        )
      ],
      child: UploadDialog(),
    );
  }
}

class UploadDialog extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _UploadDialogState();
  }
}

class _UploadDialogState extends State<UploadDialog>{

  File cover;
  File item;
  bool hasCover = false, hasItem = false;
  bool loading = false;
  TextEditingController _textEditingController = new TextEditingController();
  TextEditingController _textEditingController2 = new TextEditingController();
  final TextStyle tStyle = new TextStyle(
    fontWeight: FontWeight.normal,
    color: Colors.black,
    fontSize: isPhone()? 17.0 : 14.0,
    decoration: TextDecoration.none,
  ), sStyle = new TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontFamily: "Lato-Italic",
    fontSize: isPhone()? 17.0 : 16.0,
    decoration: TextDecoration.none,
  );
  final file = OpenFilePicker()
    ..filterSpecification = {
      'All Files': '*.*',
      'Image (*.png; *.jpg; *.gif)': '*.png; *.jpg; *.gif',
      'Word Document (*.doc)': '*.doc',
      'Web Page (*.htm; *.html)': '*.htm;*.html',
      'Pdf (*.pdf)': '*.pdf',
      'Text Document (*.txt)': '*.txt',
    }
    ..defaultFilterIndex = 0
    ..defaultExtension = 'jpg'
    ..title = 'Select Document';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InOutAnimation(
      child: Container(
          padding: EdgeInsets.all(15.0),
          child: isPhone()?
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 10.0,
                children: [
                  hasCover? Image.file(
                    cover,
                    fit: BoxFit.cover,
                    height: 170,
                    width: 120,
                    errorBuilder: (context, stack, obj){
                      return Image.asset(
                        "assets/images/g.jpg",
                        alignment: Alignment.centerRight,
                        fit: BoxFit.cover,
                        height: 170,
                        width: 120,
                      );
                    },
                  ) : SizedBox(height: 0.0,),
                  hasItem? Image.file(
                    item,
                    fit: BoxFit.cover,
                    height: 170,
                    width: 120,
                    errorBuilder: (context, stack, obj){
                      return Image.asset(
                        "assets/images/g.jpg",
                        alignment: Alignment.centerRight,
                        fit: BoxFit.cover,
                        height: 170,
                        width: 120,
                      );
                    },
                  ) : SizedBox(height: 0.0,)
                ],
              ),
              SizedBox(height: 20.0,),
              FormBuilderFilePicker(
                attribute: "cover",
                decoration: InputDecoration(
                  labelStyle: tStyle,
                  labelText: "Library Document Cover",
                  counterStyle: tStyle,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: "Library Document Cover",
                  hintStyle: new TextStyle(color: Colors.black54),
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 20,
                    top: 14,
                    bottom: 14,
                  ),
                ),
                maxFiles: 1,
                multiple: false,
                previewImages: true,
                onChanged: (val) {
                  try{
                    var resList =val.values.toList();
                    setState(() {
                      cover = File(resList[0]);
                      hasCover = true;
                    });
                  }catch(ex){
                    print('error: $ex');
                  }
                },
                fileType: FileType.image,
                selector: Row(
                  children: <Widget>[
                    Icon(Icons.file_upload, color: Colors.black,),
                    Text('Upload Document Cover', style: tStyle,),
                  ],
                ),
                onFileLoading: (val) {
                  print(val);
                },
              ),
              SizedBox(height: 15.0,),
              FormBuilderFilePicker(
                attribute: "files",
                decoration: InputDecoration(
                  labelStyle: tStyle,
                  labelText: "Library Document",
                  counterStyle: tStyle,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: "Library Document",
                  hintStyle: new TextStyle(color: Colors.black54),
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 20,
                    top: 14,
                    bottom: 14,
                  ),
                ),
                maxFiles: 1,
                multiple: false,
                previewImages: true,
                onChanged: (val) {
                  try{
                    var resList =val.values.toList();
                    setState(() {
                      item = File(resList[0]);
                      hasItem = true;
                      print("I GOT HERE");
                    });
                  }catch(ex){
                    print('error: $ex');
                  }
                },
                fileType: FileType.any,
                selector: Row(
                  children: <Widget>[
                    Icon(Icons.file_upload, color: Colors.black,),
                    Text('Upload Library Document', style: tStyle,),
                  ],
                ),
                onFileLoading: (val) {
                  print(val);
                },
              ),
              SizedBox(height: 15.0,),
              hasCover && hasItem?
              (
                  loading?
                  Container(
                    child: Center(
                      child: SpinKitFadingFour(
                        color: Colors.pink,
                        size: 50.0,
                      ),
                    ),
                  )
                      :
                  GFButton(
                    size: 50,
                    color: Theme.of(context).buttonColor,
                    shape: GFButtonShape.pills,
                    splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                    hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                    child: Translate(text: "Upload Item To Cloud", style: sStyle,),
                    fullWidthButton: true,
                    onPressed: () async{
                      try{
                        if(mounted) setState(() {
                          loading = true;
                        });
                        RestUploadTask upTasks = await iCloud.uploadFilesToCloud(file: item, cover: cover);
                        if(upTasks.hasErrors){
                          print('Upload Errors: ${upTasks.errors}');
                        }else{
                          tabData.updateTask(task: upTasks);
                          Navigator.pop(context);
                        }
                        if(mounted) setState(() {
                          loading = false;
                        });
                      }catch(ex){
                        print('error: $ex');
                      }
                    },
                  )
              )
                  :
              Translate(text:"It's mandatory to select both document and a cover for it", style: tStyle, align: TextAlign.center),
            ],
          )
              :
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      spacing: 10.0,
                      children: [
                        hasCover? Image.file(
                          cover,
                          fit: BoxFit.cover,
                          height: 170,
                          width: 120,
                          errorBuilder: (context, stack, obj){
                            return Image.asset(
                              "assets/images/g.jpg",
                              alignment: Alignment.centerRight,
                              fit: BoxFit.cover,
                              height: 170,
                              width: 120,
                            );
                          },
                        ) : SizedBox(height: 0.0,),
                        hasItem? Image(
                          image: FileImage(item),
                          fit: BoxFit.cover,
                          height: 170,
                          width: 120,
                          loadingBuilder: (context, child, chunk){
                            return Container(
                              height: 170,
                              width: 120,
                              child: Center(
                                child: SpinKitFadingCircle(
                                  color: Colors.pink,
                                  size: 30.0,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, stack, obj){
                            return Image.asset(
                              "assets/images/g.jpg",
                              alignment: Alignment.centerRight,
                              fit: BoxFit.cover,
                              height: 170,
                              width: 120,
                            );
                          },
                        ) : SizedBox(height: 0.0,),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    FormBuilderTextField(
                      initialValue: null,
                      attribute: "cover",
                      controller: _textEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Library Item Cover",
                        labelStyle: tStyle,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.file_upload),
                          iconSize: 30,
                          color: Theme.of(context).buttonColor,
                          splashColor: Colors.white.withOpacity(0.7),
                          hoverColor: Colors.white.withOpacity(0.7),
                          onPressed: () {
                            try{
                              final result = file.getFile(); print("Yes! Yes!!");
                              if (result != null && mounted) setState(() {
                                _textEditingController.text = result.path;
                                cover = /*File(result.path)*/ result;
                                hasCover = true;
                              });
                            }catch(ex){
                              print('error: $ex');
                            }
                          },
                        ),
                        suffixText: 'Select Cover Image',
                        suffixStyle: tStyle,
                        border: InputBorder.none,
                        hintText: "Library Item Cover",
                        hintStyle: new TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 20,
                          top: 14,
                          bottom: 14,
                        ),
                      ),
                      style: tStyle,
                      valueTransformer: (text) => num.tryParse(text),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(50),
                      ],
                    ),
                    SizedBox(height: 8.0,),
                    FormBuilderTextField(
                      initialValue: null,
                      attribute: "item",
                      controller: _textEditingController2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Library Item",
                        labelStyle: tStyle,
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.file_upload),
                          iconSize: 30,
                          color: Theme.of(context).buttonColor,
                          splashColor: Colors.white.withOpacity(0.7),
                          hoverColor: Colors.white.withOpacity(0.7),
                          onPressed: () {
                            try{
                              final result = file.getFile();
                              if (result != null && mounted) setState(() {
                                _textEditingController2.text = result.path;
                                item = /*File(result.path)*/ result;
                                hasItem = true;
                              });
                            }catch(ex){
                              print('error: $ex');
                            }
                          },
                        ),
                        suffixText: 'Select Library Item',
                        suffixStyle: tStyle,
                        border: InputBorder.none,
                        hintText: "Library Item",
                        hintStyle: new TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 20,
                          top: 14,
                          bottom: 14,
                        ),
                      ),
                      style: tStyle,
                      valueTransformer: (text) => num.tryParse(text),
                      validators: [
                        FormBuilderValidators.required(),
                        FormBuilderValidators.maxLength(50),
                      ],
                    ),
                    SizedBox(height: 15.0,),
                    hasCover && hasItem?
                    (
                        loading? SizedBox(width: 0.0,)
                            :
                        GFButton(
                          size: 50,
                          color: Theme.of(context).buttonColor,
                          shape: GFButtonShape.pills,
                          splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                          hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                          child: Translate(text: "Upload Item To Cloud", style: sStyle,),
                          fullWidthButton: true,
                          onPressed: () async {
                            try{
                              if(mounted) setState(() {
                                loading = true;
                              });
                              if(useRestApiEnvironment){
                                RestUploadTask upTasks = await iCloud.uploadFilesToCloud(file: item, cover: cover);
                                if(upTasks.hasErrors){
                                  print('Upload Errors: ${upTasks.errors}');
                                }else{
                                  tabData.updateTask(task: upTasks);
                                  Navigator.pop(context);
                                }
                                if(mounted) setState(() {
                                  loading = false;
                                });
                              }
                            }catch(ex){
                              print('error: $ex');
                            }
                          },
                        )
                    )
                        :
                    Translate(text:"It's mandatory to select both document and a cover for it", style: tStyle, align: TextAlign.center),
                  ],
                ),
              ),
              SizedBox(width: 15.0,),
              loading? Container(
                child: Center(
                  child: SpinKitFadingFour(
                    color: Colors.pink,
                    size: 50.0,
                  ),
                ),
              ) : SizedBox()
            ],
          ),
        ),
      inDefinition: SlideInUpAnimation(),
      outDefinition: SlideOutDownAnimation()
    );
  }
}
