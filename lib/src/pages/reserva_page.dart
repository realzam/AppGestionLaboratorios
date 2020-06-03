import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/model/computadora_model.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ReservaPage extends StatefulWidget {
  @override
  _ReservaPageState createState() => _ReservaPageState();
}

class _ReservaPageState extends State<ReservaPage> {
  final prefs = new PreferenciasUsuario();
  var timer;
  Laboratorio lab;
  String selected;
  int selectedID;
  List<String> horasLibres = new List();
  List<int> horasId = new List();
  bool visible = false;
  WebSocketInfo webSocketInfo;
  List<Computadora> _computadoras = new List();
  Size tam;
  bool start = true;
  Color mainColor = Color.fromRGBO(1, 127, 255, 1.0);
  Color secondColor = Color.fromRGBO(0, 102, 151, 1.0);
  Color ed1 = Color.fromRGBO(1, 127, 255, 1.0);
  Color ed2 =
      Color.fromRGBO(200, 200, 200, 1.0); //Color.fromRGBO(63, 148,255, 1.0);
  Color ed3 = Colors.white;
  var servidorInfo;
  var storage;
  int seleccionada = -1;
  int tipoUsu;
  TextStyle style1 = TextStyle(color: Colors.black);
  IOWebSocketChannel channel;
  StreamSubscription subscription;
  @override
  void initState() { 
    super.initState();
    prefs.paginaActual = 'reserva_page';
  }
  @override
  void dispose() {
    subscription.cancel();
    print('subscription cancel');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    storage = new FlutterSecureStorage();
    initializeDateFormatting();
    List arg = ModalRoute.of(context).settings.arguments;
    lab = arg[0];
    tipoUsu = arg[1];
    tam = MediaQuery.of(context).size;

    if (start) {
      webSocketInfo = Provider.of<WebSocketInfo>(context);
      webSocketInfo.listenCompus = true;
      webSocketInfo.intMiReserva();
      webSocketInfo.intComputadoras(lab.idLaboratorio);
    }
    webSocketInfo.listenCompus = true;
    int i = 0;
    horasLibres.clear();
    horasId.clear();
    lab.horasIDLibres.forEach((element) {
      if (element >= webSocketInfo.server.horaID) {
        horasId.add(element);
        horasLibres.add(
            '${lab.horasLibres[i].horaInicio} - ${lab.horasLibres[i].horaFin}');
      }
      if (element == webSocketInfo.server.horaID && start) {
        //  print('add first elemtne to array true iif ');

        selected = horasLibres[0];
        selectedID = horasId[0];
      }
      i++;
    });
    //  print('fin for eche');
    start = false;
    subscription = webSocketInfo.reservarStream.listen((event) {
      print('hubo un cambien en tu reserva');
      if (!webSocketInfo.reservaCompu && seleccionada != -1) seleccionada = -1;
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                prefs.paginaActual = 'Laboratorios_page';
                Navigator.of(context).pop();
              }),
          title: Text("Elegir computadora"),
        ),
        body: Stack(
          children: <Widget>[
            _fondo(),
            _contenido(),
            (seleccionada != -1 && webSocketInfo.reservaCompu && webSocketInfo.reservaLab)
                ? boton(context, 1)
                : (tipoUsu == 2 &&
                        seleccionada == -1 &&
                        webSocketInfo.canReservaLab && webSocketInfo.reservaLab)
                    ? boton(context, 2)
                    : empty()
          ],
        ));
  }

  Widget empty() {
    visible = false;
    return Container();
  }

  Widget _fondo() {
    return Container(
        width: tam.width,
        height: tam.height,
        color: Color.fromRGBO(234, 238, 241, 1.0));
  }

  Widget locationInfo(int lab) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 2.0,
        ),
        FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Colors.black),
        SizedBox(
          width: 10.0,
        ),
        Text(
          'Laboratorio $lab',
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        )
      ],
    );
  }

  Widget _contenido() {
    return SingleChildScrollView(
      //['07:00','08:00','09:00','10:00','11:00','12:00']
      child: Column(
        children: <Widget>[
          //ListHorizontal(horas: horasLibres,selected: (lab.estado=="Tiempo libre")?horasLibres[0]:null),
          SizedBox(
            height: 5.0,
          ),
          locationInfo(lab.idLaboratorio),
          SizedBox(
            height: 10.0,
          ),
          horizontal2(),
          SizedBox(
            height: 20.0,
          ),
          estados(),
          SizedBox(
            height: 20.0,
          ),
          pizaron(),
          SizedBox(
            height: 20.0,
          ),
          StreamBuilder(
              stream: webSocketInfo.computadorasStream,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  _computadoras = snapshot.data;
                  return computadoras();
                } else {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                      ),
                      SpinKitDoubleBounce(
                        color: ed1,
                        size: 50.0,
                      ),
                    ],
                  );
                }
              }),
          SizedBox(
            height: 60.0,
          )
        ],
      ),
    );
  }

  Widget pizaron() {
    return Center(
        child: Container(
            color: Colors.white,
            height: 12.0,
            width: 0.5 * tam.width,
            child: Center(
                child: Text(
              'pizarrón',
              style: TextStyle(color: Colors.black, fontSize: 12.0),
            ))));
  }

  Widget computadoras() {
    List nums = [1, 3, 5, 7];
    List nums2 = [2, 4, 6, 8];
    List nums3 = [9, 10, 11, 12, 13, 14, 15, 16, 17];
    List nums4 = [18, 19, 20, 21, 22, 23, 24, 25, 26];
    List nums5 = [27, 29, 31, 33];
    List nums6 = [28, 30, 32, 34];
    return Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      columna1(nums),
      spaceRow1(),
      columna1(nums2),
      spaceRow1(),
      spaceRow1(),
      columna2(nums3),
      spaceRow1(),
      columna2(nums4),
      spaceRow1(),
      spaceRow1(),
      columna1(nums5),
      spaceRow1(),
      columna1(nums6),
    ]));
  }

  Widget spaceCol() {
    return SizedBox(height: 0.01 * tam.height);
  }

  Widget spaceRow1() {
    return SizedBox(width: 0.025 * tam.width);
  }

  Widget fakeCompu() {
    return Container(
      width: 0.08 * tam.width,
      height: 0.08 * tam.width,
      color: Colors.transparent,
    );
  }

  Widget columna1(List n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        parFakeCompu(),
        parFakeCompu(),
        parCompu(a: n[0]),
        parFakeCompu(),
        parCompu(a: n[1]),
        parFakeCompu(),
        parCompu(a: n[2]),
        parFakeCompu(),
        parCompu(a: n[3]),
        parFakeCompu(),
      ],
    );
  }

  Widget columna2(List n) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        parCompu(a: n[0]),
        parCompu(a: n[1]),
        parCompu(a: n[2]),
        parCompu(a: n[3]),
        parFakeCompu(),
        parCompu(a: n[4]),
        parCompu(a: n[5]),
        parCompu(a: n[6]),
        parCompu(a: n[7]),
        parCompu(a: n[8]),
      ],
    );
  }

  Widget parCompu({a: 1}) {
    return Column(
      children: <Widget>[
        compu(id: a),
        spaceCol(),
      ],
    );
  }

  Widget parFakeCompu() {
    return Column(
      children: <Widget>[
        fakeCompu(),
        spaceCol(),
      ],
    );
  }

  Widget compu({id: 0}) {
    Color myestado;

    String ed = _computadoras[id - 1].estado;
    //print('${id-1} $ed');
    if (seleccionada == id && ed == "Disponible") {
      myestado = ed1;
      ed = "Seleccionada";
    } else {
      switch (ed) {
        case 'Disponible':
          myestado = ed3;
          break;
        default:
          myestado = ed2;
          break;
      }
    }
    return Container(
      width: 0.11 * tam.width,
      height: 0.11 * tam.width,
      decoration: BoxDecoration(
        color: myestado,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if ((ed == "Seleccionada" || ed == "Disponible") &&
              webSocketInfo.reservaCompu) {
            if (seleccionada == id)
              seleccionada = -1;
            else
              seleccionada = id;
            setState(() {});
          }
        },
        child: Center(
            child: Text(
          id.toString(),
          style: TextStyle(
              color: (ed == "Disponible") ? Colors.black : Colors.white),
        )),
      ),
    );
  }

  Widget estados() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        estado1(),
        spaceCol(),
        estado2(),
        spaceCol(),
        estado3()
      ],
    );
  }

  Widget estado1() {
    return Column(
      children: <Widget>[
        Container(
          width: 0.06 * tam.width,
          height: 0.06 * tam.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0), color: ed1),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          'Seleccionado',
          style: style1,
        )
      ],
    );
  }

  Widget estado2() {
    return Column(
      children: <Widget>[
        Container(
          width: 0.06 * tam.width,
          height: 0.06 * tam.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0), color: ed2),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          'No disponible',
          style: style1,
        )
      ],
    );
  }

  Widget estado3() {
    return Column(
      children: <Widget>[
        Container(
          width: 0.06 * tam.width,
          height: 0.06 * tam.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: ed3,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          'Disponible',
          style: style1,
        )
      ],
    );
  }

  Widget horizontal2() {
    webSocketInfo.intServer();
    return StreamBuilder(
        stream: webSocketInfo.serverStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 60.0,
              child: PageView(
                pageSnapping: false,
                controller:
                    PageController(initialPage: 1, viewportFraction: 0.35),
                children: _tarjetas(),
              ),
            );
          } else
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitDoubleBounce(
                  color: ed1,
                  size: 50.0,
                )
              ],
            );
        });
  }

  void horasLibresfor() {}
  List<Widget> _tarjetas() {
    return horasLibres.map((hora) {
      return Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected = hora;
                selectedID = horasId[horasLibres.indexOf(selected)];
                webSocketInfo.computadorasSink(null);
                print('${lab.estado == "Tiempo libre"} - ${horasLibres.indexOf(selected) == 0}');
                if (lab.estado == "Tiempo libre" && horasLibres.indexOf(selected) == 0)
                  webSocketInfo.intComputadoras(lab.idLaboratorio);
                else
                  webSocketInfo.intComputadorasFuture(
                      lab.idLaboratorio, horasId[horasLibres.indexOf(hora)]);
              });
            },
            child: Container(
              width: 105.0,
              height: 35.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: (selected == hora)
                      ? Color.fromRGBO(1, 127, 255, 1.0)
                      : Colors.transparent),
              child: Center(
                  child: Text(hora,
                      style: TextStyle(
                          color:
                              (selected == hora) ? Colors.white : Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold))),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget boton(BuildContext context, int t) {
    visible = true;
    return Positioned(
      bottom: 0.0,
      right: (t == 1) ? 0.0 : null,
      left: (t == 1) ? null : 0.0,
      child: GestureDetector(
        onTap: () async {
          if (seleccionada == -1 && tipoUsu == 1) return null;
          var datos = new Map();
          Intl.defaultLocale = 'es';
          String date;
          date = DateFormat('d MMM').format(webSocketInfo.server.fecha);
          String value = await storage.read(key: 'numUsuario');
          print('datos');
          datos['lab'] = lab.idLaboratorio;
          datos['fecha'] = date;
          datos['hora'] = selected;
          datos['compu'] =
              (tipoUsu == 2 && seleccionada == -1) ? "Todas" : seleccionada;
          datos['boleta'] = value;
          datos['horaId'] = selectedID;
          datos['tipoUsu'] = tipoUsu;
          if (datos['compu'] == -1) return null;
          seleccionada = -1;
          prefs.paginaActual = 'booking_page';
          Navigator.pushNamed(context, 'booking', arguments: datos);
        },
        child: Container(
          width: (t == 1) ? 140.0 : 120.0,
          height: 70.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(13, 8, 70, 1.0),
            borderRadius: (t == 1)
                ? BorderRadius.only(topLeft: Radius.circular(30.0))
                : BorderRadius.only(topRight: Radius.circular(30.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Reservar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  Text(
                    (t == 1) ? 'computadora' : 'laboratorio',
                    style: TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                FontAwesomeIcons.arrowRight,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
