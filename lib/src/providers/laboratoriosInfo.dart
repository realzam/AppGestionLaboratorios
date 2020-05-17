

import 'package:flutter/material.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';

class LaboratoriosInfo with ChangeNotifier{

String _mensaje='';
WebSocketInfo ww=WebSocketInfo();

get mensaje{
  return _mensaje;
}

set mensaje(String ms)
{
  this._mensaje=ms;
  notifyListeners();
}

}