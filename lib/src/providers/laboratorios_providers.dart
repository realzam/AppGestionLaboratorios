import 'dart:async';
import 'dart:convert';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:http/http.dart' as http;


class LaboratoriosProvider{

  String _url='https://proyectoescom.herokuapp.com';
  
  final _labsStreamController = StreamController<List<Laboratorio>>.broadcast();
  Function (List<Laboratorio>) get labsSink => _labsStreamController.sink.add;
  Stream<List<Laboratorio>> get labsStream => _labsStreamController.stream;

  

  void disposeStreams()
  {
    _labsStreamController?.close();
  }

  Future< List<Laboratorio> > getLaborotorios() async
  {

    final resp = await http.get(_url);
    final decodeData=json.decode(resp.body);
    final laboraotrios=new Laboratorios.fromJsonList(decodeData);
     return laboraotrios.items;
  }

  Future< List<Laboratorio> > procesar(String data) async
  {
 
    final decodeData=json.decode(data);
    if(decodeData['ok'])
    {
    print('data');
    print(decodeData['info']);
    
    final laboraotrios=  Laboratorios.fromJsonList(decodeData['info']);
    
    labsSink(laboraotrios.items);
    
    return laboraotrios.items;
    }
    else
    {
      return [];
    }

  }
  

}