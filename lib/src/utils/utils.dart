


import 'package:flutter/material.dart';
import 'dart:convert';
bool isNumeric(String s)
{
  if(s==null) return false;
  if(s.isEmpty)return false;
  final n=num.tryParse(s);
  return (n==null)?false:true;
}


void mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text('informacion incorecta'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=>Navigator.of(context).pop(),
            child: Text('ok')),
        ],
      );
    }
  );
}

void mostrarConfirmacion(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text('Confirmar'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            onPressed: ()=>Navigator.of(context).pop(),
            child: Text('Si')),
            FlatButton(
            onPressed: ()=>Navigator.of(context).pop(),
            child: Text('no')),
        ],
      );
    }
  );
}
enum ConfirmAction { Cancel, Accept}  

Future<ConfirmAction> asyncConfirmDialog(BuildContext context,String mensaje) async {  
  return showDialog<ConfirmAction>(  
    context: context,  
    barrierDismissible: false, // user must tap button for close dialog!  
    builder: (BuildContext context) {  
      return AlertDialog( 
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))), 
        title: Text('Confirmar'),  
        content: Text(mensaje),  
        actions: <Widget>[  
          FlatButton(  
            child: const Text('Si'),  
            onPressed: () {  
              Navigator.of(context).pop(ConfirmAction.Accept);  
            },  
          ),  
          FlatButton(  
            child: const Text('No'),  
            onPressed: () {  
              Navigator.of(context).pop(ConfirmAction.Cancel);  
            },  
          ),  
        ],  
      );  
    },  
  ); 
 
} 

Future<List<Map<String, dynamic>>> datajson(data) async {
  List<Map<String, dynamic>> items=List();

  //String data='[{"id_laboratorio":1106,"estado":"Limpiando","disponibles":32},{"id_laboratorio":1107,"estado":"En clase","disponibles":32},{"id_laboratorio":2103,"estado":"Tiempo Libre","disponibles":28},{"id_laboratorio":1105,"estado":"Tiempo libre","disponibles":30}]';
String aux="";
    print('util');
    print(data);
    data=data.substring(1,data.length-1);
    int s=0;
    List<String> subitem=List();
    //print(data.substring(61));
    for(var i=0;i<data.length;i++)
    {
      if(s==1)
      {
        s--;

        continue;
      }
      aux=aux+data[i];
      if(data[i]=="}")
      {
        s++;
        subitem.add(aux);
        aux="";
      }
      
    }
  for(var i=0;i<subitem.length;i++)
  {
      Map<String, dynamic> item = jsonDecode(subitem[i]);
    items.add(item);
  }
  print('util 2');
    print(items);
  return items;

  }