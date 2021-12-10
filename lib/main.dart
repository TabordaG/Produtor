import 'package:produtor/splash.dart';
import 'package:flutter/material.dart';
import 'package:produtor/pages/login.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// // meus pacotes
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF004d4d), //or set color with: Color(0xFF0000FF)
  ));
  debugPaintSizeEnabled = false; // mostra posi;'ao dos widgts no layout
  runApp(MaterialApp(
    builder: (context, child) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      return ScrollConfiguration(behavior: MyBehavior(), child: child);
    },
    theme: ThemeData(primaryColor: Color(0xFF004d4d)),
    debugShowCheckedModeBanner: false,
    //home: Login(),
    home: new Splash(),
  ));
}
