import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ToastUtil{


  /**
   * 短toast显示
   */
   static void showShortToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 10.0,
      textColor: Colors.black,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }


  /**
   * 长toast显示
   */
   static void showLongToast(String msg){
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 10.0,
      textColor: Colors.black,
      backgroundColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );


  }




}