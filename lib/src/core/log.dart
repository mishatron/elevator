import 'package:flutter/material.dart';

/// custom logger
class Log {

  /// call this function to log something in console
  static void log({String tag, @required String msg}) {
    if (tag == null)
      print(msg);
    else
      print("$tag : $msg");
  }
}