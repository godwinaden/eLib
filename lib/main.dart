import 'package:elib/models/library_item.dart';
import 'package:elib/models/to_use.dart';
import 'package:elib/models/using_used.dart';
import 'package:elib/pages/home/home.dart';
import 'package:elib/pages/signup/signup.dart';
import 'package:elib/singletons/iCloud.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:desktop_window/desktop_window.dart';

import 'components/splashscreen.dart';
import 'models/note.dart';
import 'models/user.dart';



void main() async {
  if (UniversalPlatform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(LibraryItemAdapter());
  Hive.registerAdapter(LibraryAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(ItemToUseAdapter());
  Hive.registerAdapter(ToUseListAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserListAdapter());
  Hive.registerAdapter(UsingAndUsedItemAdapter());
  Hive.registerAdapter(UsingAndUsedListAdapter());
  await myStorage.initializeValues();

  //_setTargetPlatformForDesktop();
  if(useRestApiEnvironment) iCloud.setUpRestApiCloud();

  runApp(MyApp());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (UniversalPlatform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (UniversalPlatform.isLinux || UniversalPlatform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  int firstTime = 0;

  Future<bool> _getCredentials({@required BuildContext context}) async{
    await precacheImage(AssetImage("assets/images/logo.png"), context);
    await precacheImage(AssetImage("assets/images/1.jpg"), context);
    await precacheImage(AssetImage("assets/images/1a.jpg"), context);
    await precacheImage(AssetImage("assets/images/2a.jpg"), context);
    await precacheImage(AssetImage("assets/images/3a.jpg"), context);
    await precacheImage(AssetImage("assets/images/4a.jpg"), context);
    await precacheImage(AssetImage("assets/images/5a.jpg"), context);
    await precacheImage(AssetImage("assets/images/2.jpg"), context);
    await precacheImage(AssetImage("assets/images/3.jpg"), context);
    await precacheImage(AssetImage("assets/images/4.jpg"), context);
    await precacheImage(AssetImage("assets/images/5.jpg"), context);
    await precacheImage(AssetImage("assets/images/6.jpg"), context);
    await precacheImage(AssetImage("assets/images/7.jpg"), context);
    await precacheImage(AssetImage("assets/images/t.jpg"), context);
    await precacheImage(AssetImage("assets/images/g.jpg"), context);
    await precacheImage(AssetImage("assets/images/gg.jpg"), context);
    await precacheImage(AssetImage("assets/images/u.jpg"), context);
    await precacheImage(AssetImage("assets/images/hj.jpg"), context);
    await precacheImage(AssetImage("assets/images/bookcase.png"), context);
    await precacheImage(AssetImage("assets/images/books.png"), context);
    await precacheImage(AssetImage("assets/images/bookshelf.png"), context);
    await precacheImage(AssetImage("assets/images/net.png"), context);
    await precacheImage(AssetImage("assets/images/notes.png"), context);
    await precacheImage(AssetImage("assets/images/reading-book.png"), context);
    await precacheImage(AssetImage("assets/images/settings.png"), context);
    await precacheImage(AssetImage("assets/images/starred.png"), context);
    await precacheImage(AssetImage("assets/images/ty.png"), context);
    await precacheImage(AssetImage("assets/images/un.png"), context);
    await precacheImage(AssetImage("assets/images/user.png"), context);
    await precacheImage(AssetImage("assets/images/video.png"), context);
    await precacheImage(AssetImage("assets/images/work-time.png"), context);

    final lStore = myStorage.lStore;
    bool isNew = true;
    if(lStore != null){
      var res = await lStore.get('isNew');
      isNew = res == null? true: res;
    }
    return isNew;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if(UniversalPlatform.isAndroid || UniversalPlatform.isIOS){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
      ]);
    } else DesktopWindow.setFullScreen(true);

    return new FutureBuilder<bool>(
      future: _getCredentials(context: context),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        bool isNew = snapshot.data;
        switch(isNew){
          case null: return MaterialApp(
            //locale: Locale.fromSubtags(languageCode: 'en'),
            title: 'eLibrary',
            theme: new ThemeData(
              primarySwatch: Colors.pink,
              brightness: Brightness.light,
            ),
            home: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              body: Container(
                child: Center(
                  child: SpinKitFadingFour(
                    size: 40.0,
                    color: Color(0xff138c09),
                  ),
                ),
              ),
            ),
          );
          default: return new MaterialApp(
            title: 'eLibrary',
            theme: new ThemeData(
              primarySwatch: Colors.green,
              brightness: Brightness.light,
              primaryColor: Color(0xff138c09),
              accentColor: Colors.white54,
              backgroundColor: Colors.black26,
              buttonColor: Colors.blue,
              disabledColor: Colors.grey,
              indicatorColor: Colors.white,
              tabBarTheme: TabBarTheme(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white30,
              ),
              hintColor: Colors.blueAccent,
              scaffoldBackgroundColor: Colors.white24,
              unselectedWidgetColor: Colors.black45,
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.white54,
                shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.black45
              ),
              appBarTheme: AppBarTheme(
                color: Colors.black38,
                iconTheme: IconThemeData(
                  color: Colors.white54
                ),
                textTheme: TextTheme(
                  headline6: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      letterSpacing: 0.7,
                      fontFamily: "OpenSans-Regular"
                  ),
                ),
              ),
              // Define the default font family.
              fontFamily: 'Lato-Italic',

              // Define the default TextTheme. Use this to specify the default
              // text styling for headlines, titles, bodies of text, and more.
              textTheme: TextTheme(
                headline5: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                ),
                headline6: TextStyle(
                    fontSize: 36.0,
                    fontFamily: "OpenSans-Bold",
                    color: Colors.black87
                ),
                headline4: TextStyle(
                  fontSize: 17.0,
                  fontFamily: 'OpenSans-Regular',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                headline3: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'NexaDemo-Bold',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                headline2: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'NexaDemo-Light',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                headline1: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Lato-LightItalic',
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                subtitle2: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Lato-Italic',
                    color: Colors.black87,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
            home: isNew?  SignUp() : MyHomePage(title: "Electronic Library",),
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}
