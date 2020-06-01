import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:proyecto/src/model/horario_model.dart';
import 'package:proyecto/src/model/mytile_model.dart';

class HorarioInfo with ChangeNotifier {
  HorarioModel _horario;
  double _currentPage = 0;

  List<String> _filtros = ['Todos - Labs', 'Todos - Dias', 'Todas - Clases'];
  String _labSelect='Todos';
  String _diaSelected='Todos';
  String _claseSelected='Todas';

  List<String> _applyflitros = ['Todos - Labs', 'Todos - Dias', 'Todas - Clases'];
  String _applylabSelect='Todos';
  String _applydiaSelected='Todos';
  String _applyclaseSelected='Todas';

  get labSelected {
    return _labSelect;
  }

  set labSelected(String val) {
    this._labSelect = val;
    if (val == 'Todos')
      _filtros[0] = val + ' - Labs';
    else
      _filtros[0] = val;
    notifyListeners();
  }

  get diaSelected {
    return _diaSelected;
  }

  set diaSelected(String val) {
    this._diaSelected = val;
    if (val == 'Todos')
      _filtros[1] = val + ' - Dias';
    else
      _filtros[1] = val;
    notifyListeners();
  }

  get claseSelected {
    return _claseSelected;
  }

  set claseSelected(String val) {
    this._claseSelected = val;
    if (val == 'Todas')
     _filtros[2] = val + ' - Clases';
    else
      _filtros[2] = val;
    notifyListeners();
  }

  get filtros {
    return _filtros;
  }
  aply()
  {
    print('aply');
    this._applylabSelect     = this._labSelect;
    this._applydiaSelected   = this._diaSelected;
    this._applyclaseSelected = this._claseSelected;
    this._applyflitros       = this._filtros;
  }
  close()
  {
    print('close');
    this._labSelect=this._applylabSelect;
    this._diaSelected=this._applydiaSelected;
    this._claseSelected=this._applyclaseSelected;
    this._filtros=[_labSelect,_diaSelected,_claseSelected];
  }

//_flitros[0]=val;

  double get currentPage => this._currentPage;

  set currentPage(double val) {
    this._currentPage = val;
    notifyListeners();
  }

  final _url = "https://proyectoescom.herokuapp.com";

  final _horarioStreamController = StreamController<List<MyTile>>.broadcast();
  Function(List<MyTile>) get horarioSink => _horarioStreamController.sink.add;
  Stream<List<MyTile>> get horarioStream => _horarioStreamController.stream;

  Future<Map<String, dynamic>> gethorario(
      {int lab, int dia, int hora, String clase,bool type:false}) async {
    print('getHorario');
    final url = '$_url/horario';
    var authdata;
    if(type)
    {
      int labb=(_applylabSelect==null || _applylabSelect=='' || _applylabSelect=="Todos")?null:int.parse(_applylabSelect);
      int diaa=(_applydiaSelected==null ||_applydiaSelected=='' || _applydiaSelected=="Todos")?null:diaSemanaID(_applydiaSelected);
      String clas;
      if(_claseSelected==null || _applyclaseSelected=='' ||_applyclaseSelected=="Todas")
        clas=null;
      else
        clas=_applyclaseSelected;
  
      authdata = {"lab": labb, "dia": diaa, "hora": hora, "clase": clas};
      print(authdata);
    }else{

    authdata = {"lab": lab, "dia": dia, "hora": hora, "clase": clase};
    }
    final uu = json.encode(authdata);

    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
    Map<String, dynamic> decodeResp = json.decode(res.body);
    if (!decodeResp['ok'] || decodeResp.containsKey('info')) {
      _horario = HorarioModel(status: false);
      List<MyTile> lista = new List();
      horarioSink(lista);
      return {'ok': false};
    }
    _horario = HorarioModel.fromJson(decodeResp);
    List<MyTile> lista = await _crearLista(_horario);
    await new Future.delayed(const Duration(milliseconds: 500));
    horarioSink(lista);
    return {'ok': true};
  }

  void disposeStreams() {
    _horarioStreamController?.close();
  }

  Future<List<MyTile>> _crearLista(HorarioModel horario) async {
    int i = 0;
    List<MyTile> lista = new List();
    List<MyTile> dias = new List();
    List<MyTile> clases = new List();
    for (var ilab in horario.lab) {
      dias = new List();
      for (var idia in ilab.dias) {
        clases = new List();
        for (var item in idia.clases) {
          clases.add(MyTile(
              '', '${item.inicio}-$i', [], item.inicio, item.fin, item.clase));
          i++;
        }
        i++;
        String nombre = diaDelaSemana(idia.dia);
        if (ilab.dias.length == 1)
          dias = clases;
        else
          dias.add(MyTile(nombre, '${idia.dia}-$i', clases));
      }
      i++;
      lista.add(MyTile('Laboratorio ${ilab.idLaboratorio}',
          '${ilab.idLaboratorio}-$i', dias));
    }

    return lista;
  }

  int diaSemanaID(String i) {
    int dia;
    switch (i) {
      case "Lunes":
        dia = 1;
        break;
      case "Martes":
        dia = 2;
        break;
      case "Miércoles":
        dia = 3;
        break;
      case "Jueves":
        dia = 4;
        break;
      case "Viernes":
        dia = 5;
        break;
      default:
        dia = 1;
    }
    return dia;
  }
  String diaDelaSemana(int i) {
    String dia;
    switch (i) {
      case 1:
        dia = "Lunes";
        break;
      case 2:
        dia = "Martes";
        break;
      case 3:
        dia = "Miércoles";
        break;
      case 4:
        dia = "Jueves";
        break;
      case 5:
        dia = "Viernes";
        break;
      default:
        dia = "Lunes";
    }
    return dia;
  }
}
