import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto/src/model/computadora_model.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/model/reserva_model.dart';
import 'package:proyecto/src/model/server_model.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketInfo with ChangeNotifier {
// var channel = IOWebSocketChannel.connect("wss://proyectoescom.herokuapp.com/");
  final _url = "wss://proyectoescom.herokuapp.com/";
  final storage = new FlutterSecureStorage();
  final prefs = new PreferenciasUsuario();
  WebSocketChannel _channel;
  bool inicio = true;
  bool listenCompus = true;
  bool _canReservarLab = true;
  bool _reservarCompu = true;
  bool _reservarLab = true;
  int _lastLab;
  int _lastHora;
  final _serverStreamController = StreamController<Server>.broadcast();
  Server server;

  List<Reserva> _reservas = new List();
  final _reservaStreamController = StreamController<List<Reserva>>.broadcast();

  List<Laboratorio> _laboratorios = new List();
  final _laboratoriosStreamController =
      StreamController<List<Laboratorio>>.broadcast();

  List<Computadora> _computadoras = new List();
  final _computadorasStreamController =
      StreamController<List<Computadora>>.broadcast();

  void disposeStreams() {
    inicio = true;
    _serverStreamController?.close();
    _laboratoriosStreamController?.close();
    _computadorasStreamController?.close();
    _reservaStreamController?.close();
  }

  Function(Server) get serverSink => _serverStreamController.sink.add;
  Stream<Server> get serverStream => _serverStreamController.stream;

  Function(List<Reserva>) get reservaSink => _reservaStreamController.sink.add;
  Stream<List<Reserva>> get reservarStream => _reservaStreamController.stream;

  Function(List<Laboratorio>) get laboratoriosSink =>
      _laboratoriosStreamController.sink.add;
  Stream<List<Laboratorio>> get laboratoriosStream =>
      _laboratoriosStreamController.stream;

  Function(List<Computadora>) get computadorasSink =>
      _computadorasStreamController.sink.add;
  Stream<List<Computadora>> get computadorasStream =>
      _computadorasStreamController.stream;
  get canReservaLab {
    return this._canReservarLab;
  }

  set canReservaLab(bool val) {
    this._canReservarLab = val;
    notifyListeners();
  }

  get reservaLab {
    return this._reservarLab;
  }

  set reservaLab(bool val) {
    this._reservarLab = val;
    notifyListeners();
  }

  get reservaCompu {
    return this._reservarCompu;
  }

  set reservaCompu(bool val) {
    this._reservarCompu = val;
    notifyListeners();
  }

  get lastLab {
    return this._lastLab;
  }

  set lastLab(int val) {
    this._lastLab = val;
    notifyListeners();
  }

  get lastHora {
    return this._lastHora;
  }

  set lastHora(int val) {
    this._lastHora = val;
    notifyListeners();
  }

  init() async {
    if (inicio) {
      print(
          '================== ininiando socket provider =========================');
      inicio = false;
      try {
        _channel = IOWebSocketChannel.connect(_url);
        _channel.stream.listen(
          _onMessageFromServer,
          onDone: () async {
            debugPrint('ws channel closed');
            reconnect();
          },
          onError: (error) async {
            debugPrint('ws error $error');
            reconnect();
          },
        );
        await intIdCLient();
        intServer();
        intMiReserva();
      } catch (e) {
        debugPrint('Connection exception $e');
      }
    } else {
      await intIdCLient();
      intServer();
      intMiReserva();
    }
  }

  _onMessageFromServer(message) {
    print('message from socket');
    var valueMap = json.decode(message);
    print('comando valueMap ${valueMap['comando']}');
    switch (valueMap['comando']) {
      case '/labs':
        print('/labs response socket');
        getLabs(valueMap['info']);
        break;
      case '/infoS':
        print('/infoS response socket');
        getServer(valueMap);
        break;
      case '/computadoras':
        if (prefs.paginaActual == 'reserva_page') {
          print('/computadoras response socket');
          String l = '${valueMap['lab']}';
          if (int.parse(l) == _lastLab) getCompus(valueMap['info']);
        }
        break;
      case '/computadorasFuture':
        if (prefs.paginaActual == 'reserva_page') {
          print('/computadorasFuture');
          String l = '${valueMap['lab']}';
          String h = '${valueMap['hora']}';
          if (int.parse(l) == _lastLab && int.parse(h) == _lastHora)
            getCompus(valueMap['info']);
        }
        break;
      case '/miReserva':
        print('/miReserva response socket');
        getReserva(valueMap);
        break;
      case '/reservaLaboratorio':
        print('/reservaLaboratorio response socket');
        String l = '${valueMap['lab']}';
        String h = '${valueMap['hora']}';
        if (int.parse(l) == _lastLab && int.parse(h) == _lastHora)
          reservaLab = !valueMap['info'];
        break;
      default:
        print(message);
        break;
    }
  }

  reconnect() async {
    inicio = true;
    serverSink(null);
    reservaSink(null);
    laboratoriosSink(null);
    computadorasSink(null);
    if (_channel != null) {
      // add in a reconnect delay
      await Future.delayed(Duration(seconds: 4));
    }
    print(new DateTime.now().toString() + " Starting connection attempt...");
    _channel = IOWebSocketChannel.connect(_url);
    print(new DateTime.now().toString() + " Connection attempt completed.");
    inicio = true;
    await intIdCLient();
    intServer();
    intMiReserva();

    _channel.stream.listen(
      _onMessageFromServer,
      onDone: () {
        debugPrint('ws channel closed');
        reconnect();
      },
      onError: (error) {
        debugPrint('ws error $error');
        reconnect();
      },
    );
  }

  intLabs() {
    _channel.sink.add('/labs');
  }

  Future<bool> intIdCLient() async {
    String id = await storage.read(key: 'numUsuario');
    print('/id/$id');
    _channel.sink.add('/id/$id');
    return true;
  }

  intMiReserva() async {
    _channel.sink.add('/miReserva');
  }

  intServer() {
    _channel.sink.add('/infoS');
  }

  intComputadoras(int lab) {
    print('/computadoras/$lab');
    _lastLab = lab;
    _lastHora = server.horaID;
    initReservaLab(lab, server.horaID);
    _channel.sink.add('/computadoras/$lab');
  }

  intComputadorasFuture(int lab, int hora) {
    print('/computadorasFuture/$lab/$hora');
    _lastLab = lab;
    _lastHora = hora;
    initReservaLab(lab, hora);
    _channel.sink.add('/computadorasFuture/$lab/$hora');
  }

  initReservaLab(int lab, int hora) {
    if (hora == null) 
      hora = server.horaID;
    print('/reservaLaboratorio/$lab/$hora');
    _channel.sink.add('/reservaLaboratorio/$lab/$hora');
  }

  Future<Server> getServer(var valueMap) async {
    server = new Server.fromJson(valueMap);
    serverSink(server);
    return server;
  }

  Future<List<Laboratorio>> getLabs(List<dynamic> datos) async {
    final laboratorios = new Laboratorios.fromJsonList(datos, server.fecha);
    final resp = laboratorios.items;
    _laboratorios.clear();
    _laboratorios.addAll(resp);
    await new Future.delayed(const Duration(milliseconds: 500));
    laboratoriosSink(_laboratorios);
    return resp;
  }

  Future<List<Computadora>> getCompus(List<dynamic> datos) async {
    final computadoras = new Computadoras.fromJsonList(datos);
    final resp = computadoras.items;
    _computadoras.clear();
    _computadoras.addAll(resp);
    await new Future.delayed(const Duration(milliseconds: 500));
    computadorasSink(_computadoras);
    print(resp[0].idLaboratorio);
    return resp;
  }

  Future<List<Reserva>> getReserva(var datos) async {
    final reser = new Reservas.fromJsonList(datos['info']);
    final resp = reser.items;
    _reservas.clear();
    _reservas.addAll(resp);
    await new Future.delayed(const Duration(milliseconds: 500));
    if (resp.length == 0) {
      reservaCompu = true;
      canReservaLab = true;
    } else if (resp.length == 1) {
      var item = resp[0];
      if (item.tipo == 1) {
        reservaCompu = false;
        canReservaLab = true;
      }

      if (item.tipo == 2) {
        reservaCompu = true;
        canReservaLab = false;
      }
    } else {
      reservaCompu = false;
      canReservaLab = false;
    }
    print('reserva validators $reservaCompu,$canReservaLab');
    reservaSink(resp);
    return resp;
  }
}
