import 'dart:io';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:elib/models/file.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/user.dart';
import 'package:elib/models/using_used.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:translator/translator.dart';


class MyStorage extends ChangeNotifier {
  static final MyStorage _myStorage = new MyStorage._internal();
  static get myStorage => _myStorage;


  Box lStore; Box<LibraryFile> files;
  Box<ItemToUse> toUs; Box<UsingAndUsedItem> uses;
  Box<LibraryItem> libs;
  List<LibraryFile> fileStores;
  List<AlreadyDecrypted> alreadyDecrypts = [];
  User user = new User();
  ToUseList toUses = new ToUseList(items: []);
  UsingAndUsedList allUses = new UsingAndUsedList(items: []);
  Library library = new Library(items: []);
  var crypt = AesCrypt('5tyu3457@675#745');
  bool hasInitialized = false;
  List<String> categories = [
    'Adventure', 'African-American Studies', 'Art', 'Biography', 'Business', 'Canadian Literature', 'African Literature', 'Classic', 'Computers', 'Cooking', 'Correspondence', 'Creative Commons', 'Criticism', 'Drama', 'Espionage',
    'Etiquette', 'Fantasy', 'Fiction And Literature', 'Games', 'Ghost Stories', 'Horror', 'Humor', 'Instructional', 'Language', 'Music', 'Mystery/Detective', 'Myth', 'Nature', 'Nautical', 'Non-Fiction', 'Occult', 'Periodical', 'Philosophy', 'Pirate Tales',
    'Poetry', 'Politics', 'Post-1930', 'Psychology', 'Pulp', 'Random Selection', 'Reference', 'Religion', 'Romance', 'Satire', 'Science', 'Science Fiction', 'Sexuality', 'Short Story', 'Short Story Collection', 'Thriller', 'Travel',
    'War', 'Western', 'Western', "Women's Studies", 'Young Readers','Gothic', 'Government Publication', 'Harvard Classics', 'Health', 'History',
  ];

  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
          fontFamily: "Lato-Italic",
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold
      ),
      descTextAlign: TextAlign.center,
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.black,
      ),
      alertAlignment: Alignment.topCenter,
      backgroundColor: Colors.white,
      overlayColor: Colors.black45,
      alertElevation: 0.0
  );



  factory MyStorage() {
    return _myStorage;
  }

  Future<void> initializeValues() async {
    try{
      Directory dick = await iCloud.getDataDirectory();
      Directory dir = await Directory(dick.path + '/elib').create();
      Hive.init(dir.path);
      lStore = await Hive.openBox('elibBox');
      files = await Hive.openBox('fileBox');
      toUs = await Hive.openBox<ItemToUse>('toUseBox');
      uses = await Hive.openBox<UsingAndUsedItem>('usesBox');
      libs = await Hive.openBox<LibraryItem>('libBox');
      if(lStore!=null && libs != null) {
        user = lStore.get("user");
        hasInitialized = true;
      }
      crypt.setOverwriteMode(AesCryptOwMode.on);
      notifyListeners();
    }catch (ex) {
      print(ex.toString());
    }
  }

  Future<bool> addItemToLibraryStore({@required LibraryItem item}) async {
    try{
      if(hasInitialized){
        libs.add(item);
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: addItemToLibraryStore: Error: $ex");
    }
    return false;
  }

  Future<bool> addItemToUseStore({@required ItemToUse item}) async {
    try{
      if(hasInitialized){
        toUs.add(item);
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: addItemToUseStore: Error: $ex");
    }
    return false;
  }

  Future<bool> addUsingAndUseStore({@required UsingAndUsedItem item}) async {
    try{
      if(hasInitialized){
        uses.add(item);
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: addUsingAndUseStore: Error: $ex");
    }
    return false;
  }

  Future<bool> removeUsingAndUseStore({@required UsingAndUsedItem item}) async {
    try{
      if(hasInitialized){
        var _task = uses.values.where((_) => _.id == item.id).first;
        _task.delete();
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: removeUsingAndUseStore: Error: $ex");
    }
    return false;
  }

  Future<bool> removeFromToUseStore({@required ItemToUse item}) async {
    try{
      if(hasInitialized){
        var _task = toUs.values.where((_) => _.id == item.id).first;
        _task.delete();
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: removeFromToUseStore: Error: $ex");
    }
    return false;
  }

  Future<bool> removeFromLocalLibrary({@required LibraryItem item}) async {
    try{
      if(hasInitialized){
        var _task = libs.values.where((_) => _.id == item.id).first;
        _task.delete();
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: removeFromLocalLibrary: Error: $ex");
    }
    return false;
  }

  Future<bool> clearLocalLibraryStore() async {
    try{
      if(hasInitialized){
        libs.deleteFromDisk();
        notifyListeners();
        return true;
      }
    } catch(ex){
      print("MyStorage: clearLocalLibraryStore: Error: $ex");
    }
    return false;
  }

  Future<String> encryptFile({@required String path}) async {
    String encFilepath;
    try {
      encFilepath = await crypt.encryptFile(path);
      print('Successfully Encrypted file: $encFilepath');
    } on AesCryptException catch (e) {
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The encryption error: ${e.message}.');
      }
    }
    return encFilepath;
  }

  Future<File> decryptFile({@required String path}) async {
    String decFilepath; File finishedFile;
    try {
      decFilepath = await crypt.decryptFile(path);
      //print('Decrypted file as: $decFilepath');
      finishedFile = File(decFilepath);
    } on AesCryptException catch (e) {
      if (e.type == AesCryptExceptionType.destFileExists) {
        print('The encryption error: ${e.message}.');
      }
    } catch(e) {
      print('The encryption error: $e.');
    }
    return finishedFile;
  }

  void addDecryptedFile({@required AlreadyDecrypted decrypted}){
    if(decrypted != null) {
      bool exists = alreadyDecrypts.contains(decrypted);
      if(!exists) alreadyDecrypts.add(decrypted);
    }
  }

  void removeDecryptedFile({@required String decryptedPath}){
    if(decryptedPath != '') {
      alreadyDecrypts.removeWhere((AlreadyDecrypted decrypted)
      => decrypted.isSameDecrypt(testPath: decryptedPath));
    }
  }

  File getADecryptedFile({@required String testPath}) {
    if(alreadyDecrypts.length>0){
      AlreadyDecrypted alreadyDecrypted = alreadyDecrypts.lastWhere((AlreadyDecrypted ele)
      => ele.isSamePath(testPath: testPath));
      return alreadyDecrypted == null? null : alreadyDecrypted.getFile();
    }
    return null;
  }

  List<String> stringKeyToArray({@required String searchText}){
    List<String> keys = []; List<String> lowerCase = [];
    keys = searchText.split(new RegExp('\\s+'));
    if(keys.length>0){
      for(int i=0; i<keys.length; i++){
        lowerCase.add(keys[i].toLowerCase());
        for(int j=i + 1; j<keys.length; j++){
          lowerCase.add((keys[i] + " " + keys[j]).toLowerCase());
        }
      }
    }
    keys.addAll(lowerCase);
    //do string convert after space

    return keys;
  }

  Future<void> addToStore({String key, dynamic value}) async {
    try{
      if(lStore!=null){
        await lStore.put(key, value);
      }
    }catch (ex) {
      print(ex.toString());
    }
  }

  Future<dynamic> getFromStore({String key}) async {
    dynamic result;
    try{
      if(lStore!=null){
        result = await lStore.get(key);
      }
    }catch (ex) {
      print(ex.toString());
    }
    return result;
  }

  dynamic getPendingUserDetail() {
    dynamic details;
    try{
      if(lStore!=null){
        details = lStore.get("pendingUserDetail")==null? null: lStore.get("pendingUserDetail");
      }
    }catch (ex) {
      print(ex.toString());
    }
    return details;
  }

  void updateDeviceToken(String value) async {
    if(lStore!=null){
      try{
        await lStore.put("firebaseMessengerToken", value);
      } catch(er){
        print("Caught Error: Add Device:  $er");
      }
    }
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  int dateDifference({@required DateTime dDate, String period: "days"}){
    final today = DateTime.now();
    int result = 0;
    switch(period){
      case "microseconds":{
        result = dDate.difference(today).inMicroseconds;
        break;
      }
      case "milliseconds":{
        result = dDate.difference(today).inMilliseconds;
        break;
      }
      case "seconds":{
        result = dDate.difference(today).inSeconds;
        break;
      }
      case "minutes":{
        result = dDate.difference(today).inMinutes;
        break;
      }
      case "hours":{
        result = dDate.difference(today).inHours;
        break;
      }
      default: {
        result = dDate.difference(today).inDays;
        break;
      }
    }
    return result;
  }

  void updateLocale(String value) async{
    try{
      user.locale = value;
      await lStore.put('user', user);
      notifyListeners();
    }catch (ex) {
      print(ex.toString());
    }
  }

  DateTime getDateFromString(String value){
    return DateTime.parse(value);
  }

  String getSubString({@required String text, int limit: 25}){
    String result = ""; limit+=3;
    try{
      if(text != null && text.length>1){
        int len = text.length;
        if(len > limit) {
          result = text.substring(0,limit-3) + "...";
        }else{result = text;}
      }
    } catch(ex){
      print("MyStorage: getSubString: 336: $ex");
    }
    return result;
  }

  Future<Translation> translate({@required String text, String fromLocaleCode: 'en'}) async{
    final translator = new GoogleTranslator();
    final String lang = myStorage.user !=null && myStorage.user.locale != null? myStorage.user.locale : "en";
    Translation translation = await translator.translate(text,from: fromLocaleCode, to: lang);
    return translation;
  }

  MyStorage._internal();
}
final myStorage = MyStorage();

bool isPhone() => UniversalPlatform.isIOS || UniversalPlatform.isAndroid? true : false;

class AlreadyDecrypted {
  final String path;
  final String decryptedPath;

  File decryptedFile;

  AlreadyDecrypted({@required this.path, @required this.decryptedPath}) {
    decryptedFile = File(decryptedPath);
  }

  File getFile() => decryptedFile;

  bool isSamePath({@required String testPath}) => path.toLowerCase() == testPath.toLowerCase();

  bool isSameDecrypt({@required String testPath}) => decryptedPath.toLowerCase() == testPath.toLowerCase();
}