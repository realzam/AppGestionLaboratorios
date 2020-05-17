import 'package:flutter/material.dart';

class Server  with ChangeNotifier{
  int _horaId=0;
  DateTime _fecha=new DateTime.now();
  get hora {
    return this._horaId;
  }
  set hora(int id)
  {
    this._horaId=id;
    notifyListeners();
  }

  get fecha {
    return this._fecha;
  }
  set fecha(DateTime d)
  {
    this._fecha=d;
    notifyListeners();
  }


}