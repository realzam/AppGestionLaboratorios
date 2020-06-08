import 'package:flutter/material.dart';

class UniLiksInfo with ChangeNotifier {
  String _lastUniLink;

  set lastUniLink(String val) {
    this._lastUniLink = val;
    notifyListeners();
  }

  get lastUniLink {
    return this._lastUniLink;
  }
}
