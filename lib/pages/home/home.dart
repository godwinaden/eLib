import 'dart:ui';

import 'package:elib/components/page_transitions/scale.dart';
import 'package:elib/pages/admin/admin.dart';
import 'package:elib/pages/home/recent.dart';
import 'package:elib/pages/home/tabs/auth_tab.dart';
import 'package:elib/pages/home/tabs/library_tab.dart';
import 'package:elib/pages/home/tabs/users_tab.dart';
import 'package:elib/pages/my_library/my_library.dart';
import 'package:elib/pages/read/library.dart';
import 'package:elib/pages/read/new.dart';
import 'package:elib/pages/read/notes.dart';
import 'package:elib/pages/read/old.dart';
import 'package:elib/pages/read/starred.dart';
import 'package:elib/pages/settings/settings.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:elib/singletons/tabData.dart';
import 'package:flurry_navigation/flurry_menu.dart';
import 'package:flurry_navigation/flurry_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_hamburger_scaffold/flutter_hamburger_scaffold.dart';
import 'package:fontisto_flutter/fontisto_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:elib/components/Translate.dart';


// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(title: title);
}

class _MyHomePageState extends State<MyHomePage> {
  String title;
  bool loading;
  final GlobalKey furryId = GlobalKey();
  final MethodChannel platform =
  MethodChannel('crossingthestreams.io/resourceResolver');
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'eLib_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
  );
  final TextStyle titleStyle = new TextStyle(
    fontFamily: "Oswald-Regular",
    fontWeight: FontWeight.w100,
    fontSize: 14,
    color: Colors.white,
    decoration: TextDecoration.none,
    shadows: [
      Shadow(
        color: Colors.black.withOpacity(0.4),
        offset: Offset(0.3, 0.3),
        blurRadius: 0.2,
      ),
    ],
  );
  final TextStyle tStyle = new TextStyle(
    fontFamily: "Lato-Italic",
    fontWeight: FontWeight.w600,
    fontSize: 18,
    color: Colors.black,
    decoration: TextDecoration.none,
  );
  Widget _widget;
  final GlobalKey widget0 = GlobalKey();
  final GlobalKey widget1 = GlobalKey();
  final GlobalKey widget2 = GlobalKey();
  final GlobalKey widget3 = GlobalKey();
  final GlobalKey widget4 = GlobalKey();
  final GlobalKey widget5 = GlobalKey();
  final GlobalKey widget6 = GlobalKey();
  final GlobalKey widget7 = GlobalKey();
  List<HamburgerMenuItem> _menuItems;
  bool showTabs = tabData.showTabs;
  String tabTitle = "Advance Settings";
  bool showUser = false;
  MenuController _menuController;

  _MyHomePageState({this.title}){
    _menuItems = [
      new HamburgerMenuItem('Recent Activities', Icons.local_activity_sharp, new RecentActivities(key: widget0,)),
      new HamburgerMenuItem('My Library', Icons.my_library_books, new MyLibrary(key: widget1)),
      new HamburgerMenuItem('My Notes', FeatherIcons.edit, new Notes(key: widget2,)),
      new HamburgerMenuItem('Reading/Read', FeatherIcons.bookOpen, new AlreadyReadOrReading(key: widget3,)),
      new HamburgerMenuItem('Unread Books', FeatherIcons.clock, new ToRead(key: widget4,)),
      new HamburgerMenuItem('Starred', Icons.star, new Starred(key: widget5,)),
      new HamburgerMenuItem('General Library', FeatherIcons.feather, new GeneralLibrary(key: widget6,)),
      new HamburgerMenuItem('Settings', Icons.settings, new Settings(key: widget7,)),
    ];
  }
  
  @override
  void initState(){
    _widget = _menuItems[0].child;
    tabData.lastWidget = _widget;
    super.initState();
    try{
      if(isPhone()){
        _rateMyApp.init().then((_) {
          if (_rateMyApp.shouldOpenDialog) {
            _rateMyApp.showRateDialog(
              context,
              title: 'FMT eLibrary',
              message: "If you like this app, kindly review it!",
              rateButton: 'RATE',
              noButton: 'NO THANKS',
              laterButton: 'MAYBE LATER',
              dialogStyle: DialogStyle(),
            );
          }
        });
      }
      if(mounted) setState(() {
        loading = false;
        title = tabData.mainTitle;
      });
    }catch(ex){
      print("Error: Home: $ex");
    }
    tabData.addListener(() {
      try{
        Future.delayed(Duration.zero, ()async{
          if(mounted) setState(() {
            if(tabData.menuChild != null){
              _widget = tabData.menuChild;
              tabData.menuChild = null;
            }
            showTabs = tabData.showTabs;
          });
        });
      }catch(ex){
        print('SetState: $ex');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void closeFurry(){
    _menuController.toggle();
    try{
      Future.delayed(Duration.zero, () => setState(() => showUser = !showUser));
    }catch(ex){
      print('SetState: $ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: showTabs? AppBar(
          title: Wrap(
            spacing: 7.0,
            children: [
              Text( tabData.title , style: titleStyle,),
              Translate(text: tabTitle, style: titleStyle,)
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(context, ScaleRoute(page: Admin())),
              icon: Icon(Icons.add),
              splashColor: Theme.of(context).accentColor,
              hoverColor: Theme.of(context).accentColor,
              color: Theme.of(context).primaryColor,
              tooltip: 'Add New Item',
              //splashRadius: ,
            ),
            IconButton(
              onPressed: (){
                tabData.updateTab(show: false);
                try{
                  Future.delayed(Duration.zero, (){
                    if(mounted) setState(() {
                      _widget = _menuItems[7].child;
                      tabData.lastWidget = _widget;
                    });
                  });
                }catch(ex){
                  print('SetState: $ex');
                }
              },
              icon: Icon(Icons.settings_backup_restore),
              splashColor: Theme.of(context).accentColor,
              hoverColor: Theme.of(context).accentColor,
              color: Theme.of(context).primaryColor,
              tooltip: 'Back To User Mode',
              //splashRadius: ,
            ),
          ],
          bottom: TabBar(
              tabs: [
                Tab(
                  text: "Library",
                  icon: ImageIcon(AssetImage("assets/images/un.png"), size: 30,),
                ),
                Tab(
                  text: "Users",
                  icon: ImageIcon(AssetImage("assets/images/ty.png"), size: 30),
                ),
                Tab(
                  text: "Authorisation",
                  icon: ImageIcon(AssetImage("assets/images/net.png"), size: 30),
                ),
              ],
            onTap: (value){
                switch(value){
                  case 0: {
                    try{
                      setState(() {
                        tabTitle = "Advanced Settings: Library Items";
                      });
                    }catch(ex){
                      print('SetState: $ex');
                    }
                    break;
                  }
                  case 1: {
                    try{
                      setState(() {
                        tabTitle = "Advanced Settings: Library Users";
                      });
                    }catch(ex){
                      print('SetState: $ex');
                    }
                    break;
                  }
                  default: {
                    try{
                      setState(() {
                        tabTitle = "Advanced Settings: Block Users";
                      });
                    }catch(ex){
                      print('SetState: $ex');
                    }
                    break;
                  }
                }
            },
          ),
        ) : null,
        body: showTabs?
        TabBarView(
          children: <Widget>[
            LibraryTab(),
            UsersTab(),
            AuthTab(),
          ],
        )
            :
        (
          isPhone()?
          new FlurryNavigation(
            key: furryId,
            curveRadius: (width * height)/500,
            label: "Make Reading A Hobby!",
            labelStyle: tStyle,
            onMounted: (_controller){
              Future.delayed(Duration.zero, () {
                _menuController = _controller;
              });
            },
            action: () {
              try{
                Future.delayed(Duration.zero, () {
                  setState(() {
                    showUser = !showUser;
                  });
                });
              }catch(ex){
                print('SetState: $ex');
              }
            },
            expandIcon: Image.asset("assets/images/user.png", width: 30, height: 30, fit: BoxFit.contain),
            iconSize: ((width * height)/15420),
            contentScreen: Screen(contentBuilder: (context){ return _widget;}),
            menuScreen: new FlurryMenu(
              bgColor: Colors.black38,
              bottomSection: Container(
                margin: EdgeInsets.only(top: height/6.0),
                padding: EdgeInsets.all(10.0),
                child: showUser? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(FeatherIcons.settings, color: Colors.white),
                      splashColor: Theme.of(context).primaryColor.withOpacity(0.7),
                      iconSize: 40.0,
                      onPressed: (){
                        try{
                          if(mounted)setState(() {
                            _widget = _menuItems[7].child;
                            tabData.lastWidget = _widget;
                            closeFurry();
                          });
                        }catch(ex){
                          print('SetState: $ex');
                        }
                      },
                    ),
                    InkWell(
                      onTap: (){

                      },
                      splashColor: Colors.pink,
                      hoverColor: Colors.pink,
                      child: Wrap(
                        children: [
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                                boxShadow: [
                                  BoxShadow(blurRadius: 0.2, offset: Offset(2,2), color: Colors.black12, spreadRadius: 0.2),
                                ]
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              child: Image.asset(myStorage.user!=null && myStorage.user.gender=='Female'? "assets/images/u.jpg" : "assets/images/hj.jpg"),
                            ),
                          ),
                          SizedBox(width: 0.5,),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20,5,20, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  myStorage.user!=null && myStorage.user.fullName!=null? '${myStorage.user?.title}. ${myStorage.user?.fullName}' : 'Ananymous Ananymous Ananymous',
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 12.0,
                                    color: Colors.white
                                  ),
                                ),
                                Text(
                                  myStorage.user!=null && myStorage.user.email!=null? '${myStorage.user?.email}' : 'ananymous@gmail.com',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Lato-Italic",
                                      fontSize: 14.0,
                                      color: Colors.white70
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ) : SizedBox(),
              ),
              // The content of the bottom section of the menu screen
              menu: new SideMenu(
                items: [
                  new SideMenuItem(
                      id:'recent', //You can set this to whatever you want but dont duplicate it
                      icon:'assets/images/work-time.png', //Set this to the data for the icon of the button
                      isSelected: true,
                      selectedBtnColor: Colors.pink,
                      selectedShadowColor: Colors.transparent,
                  ),
                  new SideMenuItem(
                    id:'lib',
                    icon:'assets/images/bookshelf.png',
                    isSelected:false,
                    selectedBtnColor:Colors.pink,
                    selectedShadowColor: Colors.transparent,
                  ),
                  new SideMenuItem(
                    id: 'myLib',
                    icon: 'assets/images/books.png',
                    isSelected: false,
                    selectedBtnColor: Colors.pink,
                    selectedShadowColor: Colors.transparent,
                  ),
                  new SideMenuItem(
                    id:'notes',
                    icon:'assets/images/notes.png',
                    isSelected: false,
                    selectedBtnColor: Colors.pink,
                    selectedShadowColor: Colors.transparent,
                  ),
                  new SideMenuItem(
                    id:'reading',
                    icon:'assets/images/reading-book.png',
                    isSelected:false,
                    selectedBtnColor:Colors.pink,
                    selectedShadowColor: Colors.transparent,
                  ),
                  new SideMenuItem(
                    id:'notRead',
                    icon:'assets/images/ty.png',
                    isSelected:false,
                    selectedBtnColor:Colors.pink,
                    selectedShadowColor: Colors.transparent,
                  ),
                  new SideMenuItem(
                    id:'settings',
                    icon:'assets/images/settings.png',
                    isSelected:false,
                    selectedBtnColor:Colors.pink,
                  ),
                  new SideMenuItem(
                    id:'starred',
                    icon:'assets/images/starred.png',
                    isSelected:false,
                    selectedBtnColor:Colors.pink,
                  )
                ],
              ),
              onMenuItemSelected: (String itemId) {
                try{
                  if (itemId == 'recent') {
                    setState(() => _widget = new RecentActivities(key: widget0,));
                  } else if (itemId == 'myLib') {
                    setState(() => _widget = new MyLibrary(key: widget1));
                  } else if (itemId == 'notes') {
                    setState(() => _widget = new Notes(key: widget2,));
                  } else if (itemId == 'reading') {
                    setState(() => _widget = new AlreadyReadOrReading(key: widget3,));
                  } else if (itemId == 'notRead') {
                    setState(() => _widget = new ToRead(key: widget4,));
                  } else if (itemId == 'starred') {
                    setState(() => _widget = new Starred(key: widget5,));
                  } else if (itemId == 'lib') {
                    setState(() => _widget = new GeneralLibrary(key: widget6,));
                  } else if (itemId == 'settings') {
                    setState(() => _widget = new Settings(key: widget7,));
                  }
                  tabData.lastWidget = _widget;
                  if(mounted) setState(() {
                    showUser = false;
                  });
                }catch(ex){
                  print('SetState: $ex');
                }
              },
            ),
          )
              :
          HamburgerScaffold(
            expandable: true,
            backgroundColor: Colors.black38,
            appBarActions: [
              InkWell(
                onTap: (){
                  try{
                    if(mounted)setState(() {
                      _widget = _menuItems[1].child;
                      tabData.lastWidget = _widget;
                    });
                  } catch(ex){
                    print('$ex');
                  }
                },
                splashColor: Colors.pink,
                hoverColor: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 0.2, offset: Offset(2,2), color: Colors.black12, spreadRadius: 0.2),
                              ]
                          ),
                          child: Center(
                            child: Icon(FeatherIcons.bookOpen, size: 20, color: Colors.black,),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5,),
                      Translate(text: "My Library")
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              InkWell(
                onTap: (){
                  try{
                    if(mounted)setState(() {
                      _widget = _menuItems[6].child;
                      tabData.lastWidget = _widget;
                    });
                  } catch(ex){
                    print('$ex');
                  }
                },
                splashColor: Colors.pink,
                hoverColor: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.all(Radius.circular(40.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 0.2, offset: Offset(2,2), color: Colors.black12, spreadRadius: 0.2),
                              ]
                          ),
                          child: Center(
                            child: Icon(Istos.cloud_down, size: 20, color: Colors.black,),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5,),
                      Translate(text: "Cloud Library")
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              InkWell(
                onTap: (){

                },
                splashColor: Colors.pink,
                hoverColor: Colors.pink,
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Wrap(
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 0.2, offset: Offset(2,2), color: Colors.black12, spreadRadius: 0.2),
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          child: Image.asset(myStorage.user!=null && myStorage.user.gender=='Female'? "assets/images/u.jpg" : "assets/images/hj.jpg"),
                        ),
                      ),
                      SizedBox(width: 0.5,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20,5,20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              myStorage.user!=null && myStorage.user.fullName!=null? '${myStorage.user?.title}. ${myStorage.user?.fullName}' : 'Ananymous Ananymous Ananymous',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 12.0,
                                  color: Colors.white
                              ),
                            ),
                            Text(
                              myStorage.user!=null && myStorage.user.email!=null? '${myStorage.user?.email}' : 'ananymous@gmail.com',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Lato-Italic",
                                  fontSize: 14.0,
                                  color: Colors.white70
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
            appBarTitle: Wrap(
              spacing: 7.0,
              children: [
                Text( tabData.title , style: titleStyle,),
                Translate(text: title, style: titleStyle,)
              ],
            ),
            centerTitle: false,
            body: _widget,
            hamburgerMenu: new HamburgerMenu(
              onClick: (Widget widget){
                try{
                  var widgetKey = widget.key;
                  if(mounted) setState(() {
                    if(widgetKey == widget0) title = "Recent Activities";
                    else if(widgetKey == widget1) title = "My Library";
                    else if(widgetKey == widget2) title = "My Notes From Library Items.";
                    else if(widgetKey == widget3) title = "Used/Using Library Documents";
                    else if(widgetKey == widget4) title = "To-Use Library Documents";
                    else if(widgetKey == widget5) title = "Starred/Favorite Documents";
                    else if(widgetKey == widget6) title = "General Library - Online";
                    else if(widgetKey == widget7) title = "Preferences";
                    _widget = widget;
                    tabData.lastWidget = _widget;
                  });
                } catch(ex){
                  print('$ex');
                }
              },
              indicatorColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor,
              unselectedColor: Colors.white,
              expanded: true,
              children: _menuItems,
            ),
          )
        ),
      ),
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: ListTile(
          title: Translate(text: message['notification']['title']),
          subtitle: Translate(text: message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);

  }

}