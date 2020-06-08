import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto/src/model/computadora_model.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/model/reserva_model.dart';
import 'package:proyecto/src/model/reserva_admin_model.dart';
import 'package:proyecto/src/model/reserva_reporte_model.dart';
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
  int _tipo;
  int _lastTipo;
  int _lastTipoReporte;
  int _lastTimeReporte ;
  final _serverStreamController = StreamController<Server>.broadcast();
  Server server;

  List<ReservaReporte> _reservasReportes = new List();
  final _reservasReportesStreamController =
      StreamController<List<ReservaReporte>>.broadcast();

  List<Reserva> _reservas = new List();
  final _reservaStreamController = StreamController<List<Reserva>>.broadcast();

  List<ReservaAdmin> _reservasAdmin = new List();
  final _reservasAdminStreamController =
      StreamController<List<ReservaAdmin>>.broadcast();

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
    _reservasAdminStreamController?.close();
    _reservasReportesStreamController?.close();
  }

  Function(Server) get serverSink => _serverStreamController.sink.add;
  Stream<Server> get serverStream => _serverStreamController.stream;

  Function(List<ReservaReporte>) get reservaReportesSink =>
      _reservasReportesStreamController.sink.add;
  Stream<List<ReservaReporte>> get reservarReporteStream =>
      _reservasReportesStreamController.stream;

  Function(List<Reserva>) get reservaSink => _reservaStreamController.sink.add;
  Stream<List<Reserva>> get reservarStream => _reservaStreamController.stream;

  Function(List<ReservaAdmin>) get reservasAdminSink =>
      _reservasAdminStreamController.sink.add;
  Stream<List<ReservaAdmin>> get reservarsAdminStream =>
      _reservasAdminStreamController.stream;

  Function(List<Laboratorio>) get laboratoriosSink =>
      _laboratoriosStreamController.sink.add;
  Stream<List<Laboratorio>> get laboratoriosStream =>
      _laboratoriosStreamController.stream;

  Function(List<Computadora>) get computadorasSink =>
      _computadorasStreamController.sink.add;
  Stream<List<Computadora>> get computadorasStream =>
      _computadorasStreamController.stream;

  get lastTipo {
    return this._lastTipo;
  }

  set lastTipo(int val) {
    this._lastTipo = val;
    notifyListeners();
  }

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

  Future<bool> init() async {
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
        return true;
      } catch (e) {
        debugPrint('Connection exception $e');
        return true;
      }
    } else {
      await intIdCLient();
      intServer();
      intMiReserva();
      return true;
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
      case '/reservasAdmin':
        print('/reservasAdmin response socket');
        if (valueMap['ok'] && _tipo == 3) getReservasAdmin(valueMap);
        break;

      case '/reservasReportes':
        print('/reservasReportes response socket');
        
        if (valueMap['ok'] && _tipo == 3 && _lastTipoReporte==valueMap['tipo'] && _lastTimeReporte==valueMap['time']) getReservaReportes(valueMap);
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
    reservasAdminSink(null);
    reservaReportesSink(null);
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
    initReservasAdmin(_lastTipo);
    initReservasReporte(_lastTimeReporte, _lastTipoReporte);
    try {
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
    } catch (e) {
      print('erro en listen');
      print(e.toString());
    }
  }

  intLabs() {
    _channel.sink.add('/labs');
  }

  Future<bool> intIdCLient() async {
    String id = await storage.read(key: 'numUsuario');
    String tipo = await storage.read(key: 'tipo');
    _tipo = int.parse(tipo);
    if (_tipo == 3) {
      String lab = await storage.read(key: 'laboratorio');
      print('/id/$id/$lab');
      _channel.sink.add('/id/$id/$lab');
    } else {
      print('/id/$id');
      _channel.sink.add('/id/$id');
    }

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
    if (hora == null) hora = server.horaID;
    print('/reservaLaboratorio/$lab/$hora');
    _channel.sink.add('/reservaLaboratorio/$lab/$hora');
  }

  initReservasAdmin(int type) async {
    _lastTipo = type;
    String tipo = await storage.read(key: 'tipo');
    if (tipo == "3") {
      print('/reservasAdmin/$type');
      _channel.sink.add('/reservasAdmin/$type');
    }
  }

  initReservasReporte(int time,int type) async {
    _lastTipoReporte = type;
    _lastTimeReporte = time;
    String tipo = await storage.read(key: 'tipo');
    if (tipo == "3") {
      print('/reservasReportes/$time/$type');
      _channel.sink.add('/reservasReportes/$time/$type');
    }
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

  Future<List<ReservaAdmin>> getReservasAdmin(var datos) async {
    String lab = await storage.read(key: 'laboratorio');
    int ilab = int.parse(lab);
    if (ilab == datos['lab'] && _lastTipo == datos['tipo']) {
      final reservasX = new ReservasAdmin.fromJsonList(datos['info']);
      final resp = reservasX.items;
      _reservasAdmin.clear();
      _reservasAdmin.addAll(resp);
      reservasAdminSink(_reservasAdmin);
      return resp;
    }
    return [];
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

  Future<List<ReservaReporte>> getReservaReportes(var datos) async {
    final reser = new ReservasReportes.fromJsonList(datos['info']);
    final resp = reser.items;
    _reservasReportes.clear();
    _reservasReportes.addAll(resp);
    await new Future.delayed(const Duration(milliseconds: 500));
    if (resp.length == 0) {
      reservaReportesSink([]);
      return [];
    }
    print('reserva reportes');
    reservaReportesSink(resp);
    return resp;
  }
}
