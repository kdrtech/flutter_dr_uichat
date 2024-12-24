import 'package:flutter/foundation.dart';

class DrLogger {
  DrLogger._privateConstructor();
  static final DrLogger logger = DrLogger._privateConstructor();
  void log(String tag, String message) {
    if (kDebugMode) {
      print("$tag=$message");
    }
  }
}
