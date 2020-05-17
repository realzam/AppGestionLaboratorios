import 'package:flutter/material.dart';


class WebInformacion with ChangeNotifier{
  
  int lab;
  List edos=List();
  int idLastpick=-1;
  iniEdos(){
    for(var i=0;i<34;i++)
    {
      edos.add(3);
    }
  }
  setEdoCompu(int i, int e)
  {
    if(idLastpick!=-1)
    {
      edos[idLastpick]=3;
    }
    idLastpick=i;
    edos[i]=e;
    print('i:$i e:$e');
    notifyListeners();
  }

  getEdoCompu(int i)
  {
    return edos[i];
  }


}