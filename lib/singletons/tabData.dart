import 'dart:convert';

import 'package:elib/components/upload_task.dart';
import 'package:elib/models/library_item.dart';
import 'package:elib/models/note.dart';
import 'package:elib/models/user.dart';
import 'package:elib/pages/settings/settings.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter/material.dart';

class TabData extends ChangeNotifier {
  static final TabData _tabData = new TabData._internal();
  static get tabData => _tabData;

  bool loading = false;
  String title = "FMT eLibrary: ";
  String mainTitle = "Your library anywhere anytime!";
  Library limitedLibrary  = new Library(items: []);
  Library allLibrary  = new Library(items: []);
  Library searchLibrary  = new Library(items: []);
  Library localLibrary = new Library(items: []);
  UserList allUsers = new UserList(users: []);
  Notes presentNotes = new Notes(items: []);
  String coverUrl = "";
  String fileUrl = "";
  RestUploadTask restUploadTask = new RestUploadTask(hasErrors: true);
  Library searchResults = new Library(items: []);
  Widget menuChild;
  Widget lastWidget;
  bool showTabs = false;
  SettingsState state = SettingsState.User;


  factory TabData() {
    return _tabData;
  }

  void updateNotes({@required Notes notes}){
    presentNotes = notes;
    print("PresentNotes: ${presentNotes.items}");
    notifyListeners();
  }

  void updateANote({@required Note note, @required int index}){
    try{
      presentNotes.items[index] = note;
    } catch(ex){
      print("TabData: updateANote: $ex");
    }
    notifyListeners();
  }

  void deleteFromNotes({@required int index}){
    try{
      presentNotes.items.removeAt(index);
    } catch(ex){
      print("TabData: updateANote: $ex");
    }
    notifyListeners();
  }

  void updateState({@required SettingsState sta}){
    state = sta;
    notifyListeners();
  }

  void updateTab({@required bool show}){
    showTabs = show;
    notifyListeners();
  }

  void updateFileUrl({@required String url}){
    fileUrl = url;
    notifyListeners();
  }

  void updateCoverUrl({@required String url}){
    coverUrl = url;
    notifyListeners();
  }

  void updateTask({@required RestUploadTask task}){
     restUploadTask = task;
     notifyListeners();
  }

  void updateUsers({@required UserList users}){
    allUsers = users;
    notifyListeners();
  }

  void updateAllLibrary({@required Library libs}){
    allLibrary = libs;
    notifyListeners();
  }

  void addToAllLibrary({@required LibraryItem item}){
    allLibrary.items.add(item);
    notifyListeners();
  }

  Future<bool> uploadLibraryItem({@required LibraryItem libraryItem}) async {
    bool status = false;
    try{
      if(useRestApiEnvironment){
        updateLoading(true);
        dynamic response = await iCloud.post(url: 'v2/library', body: libraryItem.toJson());
        final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
        if(decodedResponse != null && decodedResponse["libraryItem"] != null){
          LibraryItem theItem = new LibraryItem.fromJson(decodedResponse["libraryItem"]);
          addToAllLibrary(item: theItem);
          status = true;
        }
        updateLoading(false);
      }
    }catch(ex){
      print("TabData: uploadLibraryItem: ${ex.toString()}");
      updateLoading(false);
    }

    return status;
  }

  void updateWidget({@required Widget widget}){
    menuChild = widget;
    notifyListeners();
  }

  Future<Library> getLastItems({@required int quantity}) async{
    if(limitedLibrary.items.length < 1){
      try{
        dynamic response = await iCloud.get(url: 'v2/library/last/$quantity');
        final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
        if(decodedResponse != null && decodedResponse["items"]!=null && decodedResponse["items"].length>0){
          List<dynamic> items = decodedResponse["items"];
          limitedLibrary = Library.fromJson(items);
        }
      } catch(ex){
        print("TabData: getLastItems: $ex");
      }
    }
    return limitedLibrary;
  }

  void searchBy({@required String searchWord, @required String by}) async {
    try{
      updateLoading(true);
      dynamic response = await iCloud.get(url: 'v2/library/search/$by/$searchWord');
      final Map<String, dynamic> decodedResponse = json.decode(isPhone()? response.toString() : response.body.toString());
      if(decodedResponse != null && decodedResponse["items"]!=null && decodedResponse["items"].length>0){
        Map<String, dynamic> items = decodedResponse["items"];
        limitedLibrary = Library.fromJson(items['data']);
      }
      updateLoading(false);
    } catch(ex){
      updateLoading(false);
      print("TabData: searchBy: $ex");
    }
  }

  void updateTitle({@required String dTitle}) {
    mainTitle = title + dTitle;
    notifyListeners();
  }

  void updateLoading(bool action) {
    loading = action;
    notifyListeners();
  }

  TabData._internal();
}
final tabData = TabData();