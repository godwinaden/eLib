import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:elib/components/page_transitions/slideright.dart';
import 'package:elib/pages/home/home.dart';
import 'package:elib/singletons/sharedLocalStorage.dart';

class SplashScreen extends StatefulWidget{
  SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => new SplashScreenState();
}


class SplashScreenState extends State<SplashScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "",
        description: "",
        backgroundImage: isPhone()? "assets/images/1a.jpg" : "assets/images/1.jpg",
        backgroundColor: Colors.white,
        backgroundOpacity: 1.0,
        backgroundOpacityColor: Colors.white,
        backgroundImageFit: BoxFit.cover
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description: "",
        backgroundImage: isPhone()? "assets/images/2a.jpg" : "assets/images/2.jpg",
        backgroundColor: Colors.white,
        backgroundOpacity: 1.0,
        backgroundOpacityColor: Colors.white,
        backgroundImageFit: BoxFit.cover
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description: "",
        backgroundImage: isPhone()? "assets/images/3a.jpg" : "assets/images/3.jpg",
        backgroundColor: Colors.white,
        backgroundOpacity: 1.0,
        backgroundOpacityColor: Colors.white,
        backgroundImageFit: BoxFit.cover
      ),
    );
    slides.add(
      new Slide(
        title: "",
        description: "",
        backgroundImage: isPhone()? "assets/images/4a.jpg" : "assets/images/4.jpg",
        backgroundColor: Colors.white,
        backgroundOpacity: 1.0,
        backgroundOpacityColor: Colors.white,
        backgroundImageFit: BoxFit.cover
      ),
    );
  }

  void onDonePress() async {
    await myStorage.addToStore(key: 'isNew', value: false);
    Navigator.push(
        context,
        SlideRightRoute(page: MyHomePage(title: 'eLib'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new IntroSlider(
        slides: this.slides,
        onDonePress: this.onDonePress,
        isShowPrevBtn: true,
        styleNameDoneBtn: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Oswald-Regular"),
        styleNamePrevBtn: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Oswald-Regular"),
        styleNameSkipBtn: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Oswald-Regular"),
      ),
    );
  }
}