import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:proyecto/src/model/computadora_model.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/model/reserva_model.dart';
import 'package:proyecto/src/model/server_model.dart';

import 'package:web_socket_channel/io.dart';

class WebSocketInfo with ChangeNotifier {
// var channel = IOWebSocketChannel.connect("wss://proyectoescom.herokuapp.com/");
  final _url = "wss://proyectoescom.herokuapp.com/";
  final storage = new FlutterSecureStorage();
  var _channel;
  bool inicio = true;
  bool listenCompus;

  Server server;
  final _serverStreamController = StreamController<Server>.broadcast();

  Reserva reserva;
  final _reservaStreamController = StreamController<Reserva>.broadcast();

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

  Function(Reserva) get reservaSink => _reservaStreamController.sink.add;
  Stream<Reserva> get reservarStream => _reservaStreamController.stream;

  Function(List<Laboratorio>) get laboratoriosSink =>
      _laboratoriosStreamController.sink.add;
  Stream<List<Laboratorio>> get laboratoriosStream =>
      _laboratoriosStreamController.stream;

  Function(List<Computadora>) get computadorasSink =>
      _computadorasStreamController.sink.add;
  Stream<List<Computadora>> get computadorasStream =>
      _computadorasStreamController.stream;

  init() {
    if (inicio) {
      print('ininiando socket provider');
      inicio = false;
      try {
        _channel = IOWebSocketChannel.connect(_url);
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
        intServer();
        intIdCLient();
        intMiReserva();
      } catch (e) {
        debugPrint('Connection exception $e');
      }
    }
  }

  _onMessageFromServer(message) {
    print('message from socket');
    var valueMap = json.decode(message);
    print('comando valueMap ${valueMap['comando']}');
    switch (valueMap['comando']) {
      case '/labs':
        print('/labs');
        getLabs(valueMap['info']);
        break;
      case '/infoS':
        print('/infoS');
        server = new Server.fromJson(valueMap);
        serverSink(server);
        break;
      case '/computadoras':
        if (!listenCompus) break;
        print('/computadoras');
        getCompus(valueMap['info']);
        break;
      case '/computadorasFuture':
        if (listenCompus) {
          print('/computadorasFuture');
          getCompus(valueMap['info']);
        }
        break;
      case '/miReserva':
        print('/miReserva');
        getReserva(valueMap);
        break;
      default:
        print(message);
        break;
    }
  }

  reconnect() async {
    if (_channel != null) {
      // add in a reconnect delay
      await Future.delayed(Duration(seconds: 4));
    }
    print(new DateTime.now().toString() + " Starting connection attempt...");
    _channel = IOWebSocketChannel.connect(_url);
    print(new DateTime.now().toString() + " Connection attempt completed.");
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

  intIdCLient() async {
    String id = await storage.read(key: 'numUsuario');
    _channel.sink.add('/id/$id');
  }

  intMiReserva() async {
    _channel.sink.add('/miReserva');
  }

  intServer() {
    _channel.sink.add('/infoS');
  }

  intComputadoras(int lab) {
    print('/computadoras/$lab');
    _channel.sink.add('/computadoras/$lab');
  }

  intComputadorasFuture(int lab, int hora) {
    print('/computadorasFuture/$lab/$hora');
    _channel.sink.add('/computadorasFuture/$lab/$hora');
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
    return resp;
  }

  Future<List<Computadora>> getReserva(var datos) async {
    if (datos.containsKey('info'))
      reserva = new Reserva.fromJson(datos['info']);
    else
      reserva = new Reserva.nothing();
      await new Future.delayed(const Duration(milliseconds: 500));
    reservaSink(reserva);
  }
}
