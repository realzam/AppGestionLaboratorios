
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketInfo  with ChangeNotifier{
  
var channel = IOWebSocketChannel.connect("wss://proyectoescom.herokuapp.com/");
bool inicio=false;
final _laboratoriosStreamController=StreamController<List<Laboratorio>>.broadcast();

List<Laboratorio> _laboratorios = new List();


 void disposeStreams() {
   inicio=false;
   _laboratoriosStreamController?.close();
  }

Function(List<Laboratorio>) get laboratoriosSink =>_laboratoriosStreamController.sink.add;
Stream<List<Laboratorio>> get laboratoriosStream =>_laboratoriosStreamController.stream;


init()
{
  inicio=true;
    channel.stream.listen((message) {
     print('message');
      var valueMap = json.decode(message);
      if(valueMap['comando']=='/labs')
      {
        getLabs(valueMap['info']);
      }
   });

  
}
intLabs(){
  channel.sink.add('/labs');
}

Future <List<Laboratorio>> getLabs(List<dynamic> datos) async
{
  
final laboratorios=new Laboratorios.fromJsonList(datos);
   final resp = laboratorios.items;
   _laboratorios.clear();
    _laboratorios.addAll(resp);
    laboratoriosSink( _laboratorios);
    return resp;

}






}