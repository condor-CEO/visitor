import 'package:flutter/material.dart';
import 'splash.dart';


void main() {
  runApp(new MaterialApp(
    title: "朋悦比邻",
    theme: new ThemeData(
      primaryIconTheme: const IconThemeData(color: Colors.white),
      brightness: Brightness.light,
      primaryColor:Colors.blue,
      accentColor: Colors.purple,
    ),
    home: SplashPage(),
  ));
}