import 'package:elib/components/Translate.dart';
import 'package:elib/components/upload_task.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/locale.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Admin extends StatefulWidget {

  Admin({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AdminState();
  }
}

enum Adding{
  FirstStep,
  SecondStep,
  Succeed,
  Failed
}

class _AdminState extends State<Admin> {
  final List locale = locales;
  Adding state = Adding.FirstStep;
  final TextStyle vStyle = new TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 22.0,
    color: isPhone()? Colors.white54 : Colors.amber,
  ), nStyle = new TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: isPhone()? 19.0 : 16.0,
    color: Colors.white70,
  ), bStyle = new TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: isPhone()? 19.0 : 16.0,
    color: Colors.white,
  ), hStyle = new TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 18,
  color: Colors.black,
  );
  LibraryItem newItem = new LibraryItem(
    id: 'unknown',
    type: 'Book',
    addedOn: DateTime.now(),
    author: '',
    category: 'Adventure',
    coverImageUrl: '',
    edition: '',
    itemUrl: '',
    title: '',
  );
  bool loading = false;
  String issues = '';
  bool hasUploadedFiles = false;

  @override
  void initState() {
    tabData.addListener(() {
      try{
        newItem.itemUrl = tabData.restUploadTask.filePath;
        newItem.coverImageUrl = tabData.restUploadTask.coverPath;
        Future.delayed(Duration.zero, () {
          if(mounted) setState(() => hasUploadedFiles = tabData.restUploadTask.hasErrors? false : true);
        });
      } catch(ex){
        print('$ex');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height, width = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Translate(text: 'Adding Item To Library'),
        actions: [
          isPhone() && state == Adding.FirstStep? GFButton(
            shape: GFButtonShape.standard,
            hoverColor: Colors.blue.withOpacity(0.7),
            splashColor: Colors.blue.withOpacity(0.7),
            color: Theme.of(context).buttonColor,
            child: Translate(text: 'Next', style: bStyle,),
            onPressed: _moveToNextStep,
          ) : SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: FormBuilder(
          autovalidateMode: AutovalidateMode.always,
          child: state == Adding.FirstStep?
          (
              isPhone()?
              Column(
                children: [
                  FormBuilderRadioGroup(
                    initialValue: newItem.type,
                    decoration: InputDecoration(
                      labelText: 'What Type Of Item?',
                      labelStyle: vStyle,
                    ),
                    attribute: 'item_type',
                    onChanged: (value){
                      newItem.type = value;
                    },
                    validators: [FormBuilderValidators.required()],
                    options: ['Book', 'Paper', 'Article', 'Project','Map', 'Video', 'Art', 'Audio', 'Manuscript', 'Biography','Newspaper']
                        .map((lang) => FormBuilderFieldOption(
                      value: lang,
                      child: Translate(text:'$lang', style: nStyle,),
                    ))
                        .toList(growable: false),
                  ),
                  SizedBox(height: 10.0),
                  FormBuilderRadioGroup(
                    initialValue: newItem.category,
                    decoration: InputDecoration(
                      labelText: 'What Category Does This Item Belong To?',
                      labelStyle: vStyle,
                    ),
                    attribute: 'item_category',
                    onChanged: (value){
                      newItem.category = value;
                    },
                    validators: [FormBuilderValidators.required()],
                    options: myStorage.categories.map((lang) => FormBuilderFieldOption(
                      value: lang,
                      child: Translate(text:'$lang', style: nStyle,),
                    ))
                        .toList(growable: false),
                  ),
                  SizedBox(height: 10.0),

                ],
              )
                  :
              InOutAnimation(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    Container(
                      height: height/1.5,
                      width: width/3.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Colors.black45,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: FormBuilderRadioGroup(
                          initialValue: newItem.type,
                          decoration: InputDecoration(
                            labelText: 'What Type Of Item?',
                            labelStyle: vStyle,
                          ),
                          attribute: 'item_type',
                          onChanged: (value){
                            newItem.type = value;
                          },
                          validators: [FormBuilderValidators.required()],
                          options: ['Book', 'Paper', 'Article', 'Project','Map', 'Video', 'Art', 'Audio', 'Manuscript', 'Biography','Newspaper']
                              .map((lang) => FormBuilderFieldOption(
                            value: lang,
                            child: Translate(text:'$lang', style: nStyle,),
                          ))
                              .toList(growable: false),
                        ),
                      ),
                    ),
                    Container(
                      height: height/1.5,
                      width: width/3.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        color: Colors.black45,
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: FormBuilderRadioGroup(
                          initialValue: newItem.category,
                          decoration: InputDecoration(
                            labelText: 'What Category Does This Item Belong To?',
                            labelStyle: vStyle,
                          ),
                          attribute: 'item_category',
                          onChanged: (value){
                            newItem.category = value;
                          },
                          validators: [FormBuilderValidators.required()],
                          options: myStorage.categories.map((lang) => FormBuilderFieldOption(
                            value: lang,
                            child: Translate(text:'$lang', style: nStyle,),
                          ))
                              .toList(growable: false),
                        ),
                      ),
                    ),
                    Container(
                      height: height/1.5,
                      width: width/3.2,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0)
                                ),
                                color: Colors.black45,
                              ),
                              child: FormBuilderTextField(
                                initialValue: newItem.author,
                                attribute: "author",
                                autofocus: true,
                                style: nStyle,
                                decoration: InputDecoration(
                                    labelText: "What's The Author(s) Name(s)",
                                    labelStyle: vStyle,
                                    icon: const Icon(
                                      Icons.people_outline_rounded,
                                      color: Colors.black,
                                      size: 25.0,
                                    )
                                ),
                                onChanged: (value){
                                  newItem.author = value;
                                },
                                valueTransformer: (text) => num.tryParse(text),
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                              ),
                              child: FormBuilderTextField(
                                initialValue: newItem.title,
                                attribute: "title",
                                autofocus: true,
                                style: nStyle,
                                decoration: InputDecoration(
                                    labelText: "What's The Title?",
                                    labelStyle: vStyle,
                                    icon: const Icon(
                                      Icons.title,
                                      color: Colors.black,
                                      size: 25.0,
                                    )
                                ),
                                onChanged: (value){
                                  newItem.title = value;
                                },
                                valueTransformer: (text) => num.tryParse(text),
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft:  Radius.circular(30.0),
                                    bottomRight:  Radius.circular(30.0)
                                ),
                                color: Colors.black45,
                              ),
                              child: FormBuilderTextField(
                                initialValue: newItem.edition,
                                attribute: 'edition',
                                style: nStyle,
                                decoration: InputDecoration(
                                    labelText: "What Edition Is This?",
                                    labelStyle: vStyle,
                                    icon: const Icon(
                                      Icons.add_moderator,
                                      color: Colors.black,
                                      size: 25.0,
                                    )
                                ),
                                onChanged: (value){
                                  newItem.edition = value;
                                },
                                valueTransformer: (text) => num.tryParse(text),
                                validators: [
                                  FormBuilderValidators.required(),
                                ],
                              ),
                            ),
                            !hasUploadedFiles? Uploader() : SizedBox(),
                            SizedBox(height: 10.0,),
                            loading? Center(
                              child: SpinKitFadingFour(size: 40.0, color: Colors.white38),
                            )
                                :
                            (
                              hasUploadedFiles? GFButton(
                                size: 50.0,
                                fullWidthButton: true,
                                shape: GFButtonShape.pills,
                                hoverColor: Colors.blue.withOpacity(0.7),
                                splashColor: Colors.blue.withOpacity(0.7),
                                color: Theme.of(context).buttonColor,
                                child: Translate(text: 'Add Now', style: bStyle,),
                                onPressed: _save,
                              ) : SizedBox()
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                inDefinition: SlideInRightAnimation(),
                outDefinition: SlideOutLeftAnimation()
              )
          )
              :
          (
            state == Adding.SecondStep?
            Column(
              children: [
                Container(
                  height: 100,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)
                    ),
                    color: Colors.black45,
                  ),
                  child: FormBuilderTextField(
                    initialValue: newItem.author,
                    attribute: "author",
                    autofocus: true,
                    style: nStyle,
                    decoration: InputDecoration(
                        labelText: "What's The Author(s) Name(s)",
                        labelStyle: vStyle,
                        icon: const Icon(
                          Icons.people_outline_rounded,
                          color: Colors.black,
                          size: 25.0,
                        )
                    ),
                    onChanged: (value){
                      newItem.author = value;
                    },
                    valueTransformer: (text) => num.tryParse(text),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                  ),
                  child: FormBuilderTextField(
                    initialValue: newItem.title,
                    attribute: "title",
                    autofocus: true,
                    style: nStyle,
                    decoration: InputDecoration(
                        labelText: "What's The Title?",
                        labelStyle: vStyle,
                        icon: const Icon(
                          Icons.title,
                          color: Colors.black,
                          size: 25.0,
                        )
                    ),
                    onChanged: (value){
                      newItem.title = value;
                    },
                    valueTransformer: (text) => num.tryParse(text),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft:  Radius.circular(30.0),
                        bottomRight:  Radius.circular(30.0)
                    ),
                    color: Colors.black45,
                  ),
                  child: FormBuilderTextField(
                    initialValue: newItem.edition,
                    attribute: "edition",
                    style: nStyle,
                    decoration: InputDecoration(
                        labelText: "What Edition Is This?",
                        labelStyle: vStyle,
                        icon: const Icon(
                          Icons.add_moderator,
                          color: Colors.black,
                          size: 25.0,
                        )
                    ),
                    onChanged: (value){
                      newItem.edition = value;
                    },
                    valueTransformer: (text) => num.tryParse(text),
                    validators: [
                      FormBuilderValidators.required(),
                    ],
                  ),
                ),
                !hasUploadedFiles? Uploader() : SizedBox(),
                loading? Center(
                  child: SpinKitFadingFour(size: 40.0, color: Colors.white38),
                )
                    :
                (
                    hasUploadedFiles? GFButton(
                      fullWidthButton: true,
                      size: 50.0,
                      shape: GFButtonShape.pills,
                      hoverColor: Colors.blue.withOpacity(0.7),
                      splashColor: Colors.blue.withOpacity(0.7),
                      color: Theme.of(context).buttonColor,
                      child: Translate(text: 'Add Now', style: bStyle,),
                      onPressed: _save,
                    ) : SizedBox()
                )
              ],
            )
                :
            (
                state == Adding.Succeed?
                InOutAnimation(
                  inDefinition: SlideInRightAnimation(),
                  outDefinition: SlideOutLeftAnimation(),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: [
                          ImageIcon(AssetImage('assets/images/bookcase.png'), size: 60, color: Colors.pink,),
                          SizedBox(height: 20.0,),
                          Translate(
                            text: 'A ${newItem.type} titled "${newItem.title}" written by ${newItem.author} has been added to the library on the ${newItem.category} shelf.',
                            style: hStyle,
                            align: TextAlign.center,
                          ),
                          GFButton(
                            onPressed: () => Navigator.pop(context),
                            fullWidthButton: isPhone()? true : false,
                            padding: isPhone()? EdgeInsets.zero : EdgeInsets.only(right: 20, left: 20),
                            color: Theme.of(context).buttonColor,
                            child: Translate(text: 'FINISH', style: bStyle,),
                            shape: GFButtonShape.pills,
                            splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                            hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                          )
                        ],
                      )
                    ),
                  ),
                )
                    :
                InOutAnimation(
                  inDefinition: SlideInRightAnimation(),
                  outDefinition: SlideOutLeftAnimation(),
                  child: Container(
                    child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.error_outline_sharp, size: 60, color: Colors.red,),
                            SizedBox(height: 20.0,),
                            Translate(
                              text: 'There were issues that made it impossible to complete the process. Issues: $issues.',
                              style: hStyle,
                              align: TextAlign.center,
                            ),
                            GFButton(
                              onPressed: () {
                                try{
                                  setState(() => state = isPhone()? Adding.SecondStep : Adding.FirstStep);
                                }catch(ex){
                                  print('setState: $ex');
                                }
                              },
                              fullWidthButton: isPhone()? true : false,
                              padding: isPhone()? EdgeInsets.zero : EdgeInsets.only(right: 20, left: 20),
                              color: Theme.of(context).buttonColor,
                              child: Translate(text: 'TRY AGAIN', style: bStyle,),
                              shape: GFButtonShape.pills,
                              splashColor: Theme.of(context).buttonColor.withOpacity(0.7),
                              hoverColor: Theme.of(context).buttonColor.withOpacity(0.7),
                            )
                          ],
                        )
                    ),
                  ),
                )
            )
          ),
        ),
      ),
    );
  }

  void _save() async {
    try{
      String msg = '';
      if(mounted) setState(() {
        loading = true;
      });
      if(_checkFields()){
        bool hasUploaded = await tabData.uploadLibraryItem(libraryItem: newItem);
        if(hasUploaded && mounted) setState(() {
          state = Adding.Succeed;
        });
        if(!hasUploaded && mounted) setState(() {
          issues = tabData.restUploadTask.errors;
          state = Adding.Failed;
        });
      }else{
        if(mounted) setState(() {
          loading = false;
        });
        msg = "All Fields Are Required.";
        Alert(context: context, style: myStorage.alertStyle, type: AlertType.error, title: "Advance Settings", desc: msg, ).show();
      }
    }catch(ex){
      print('setState: $ex');
    }
  }

  bool _checkFields(){
    if(newItem.type != ''
        && newItem.category != ''
        && newItem.edition != ''
        && newItem.title != ''
        && newItem.author != ''
        && newItem.coverImageUrl != ''
        && newItem.itemUrl != '') return true;
    else return false;
  }

  void _moveToNextStep(){
    try{
      if(mounted && newItem.type != '' && newItem.category != '') setState(() {
        state = Adding.SecondStep;
      });
    }catch(ex){
      print('setState: $ex');
    }
  }
}