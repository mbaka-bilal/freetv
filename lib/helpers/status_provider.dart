import 'package:flutter/cupertino.dart';

class Status with ChangeNotifier {
  bool offline = false;

  bool get() {
    return offline;
  }

  set(bool status) {
    offline = status;
    notifyListeners();
  }
}
