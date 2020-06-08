import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/model/reserva_admin_model.dart';
import 'package:proyecto/src/model/server_model.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:proyecto/src/utils/utils.dart';

class DocentesReservaTab extends StatefulWidget {
  @override
  _DocentesReservaTabState createState() => _DocentesReservaTabState();
}

class _DocentesReservaTabState extends State<DocentesReservaTab> {
  Size tam;
  bool start = true;
  WebSocketInfo webSocketInfo;
  final usuarioProvider = new UsuarioProvider();
  Color fondoColor;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (start) {
      webSocketInfo = Provider.of<WebSocketInfo>(context);
      webSocketInfo.initReservasAdmin(2);
      webSocketInfo.intServer();
      fondoColor = Colors.white;
      start = false;
    }
    tam = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fondo(),
          _contenido(context),
        ],
      ),
    );
  }

  Widget _fondo() {
    return Container(width: tam.width, height: tam.height, color: fondoColor);
  }

  Widget _contenido( BuildContext context2,) {
    return StreamBuilder(
      stream: webSocketInfo.reservarsAdminStream,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          if (fondoColor == Colors.white) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                if (snapshot.data.length == 0)
                  fondoColor = Colors.white;
                else
                  fondoColor = Color.fromRGBO(92, 124, 250, 1.0);
              });
            });
          }
          if (snapshot.data.length == 0)
          {
             if (fondoColor != Colors.white) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                    fondoColor = Colors.white;
                });
              });}
               return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _reservaEmpty(),
              ],
            ));
          

          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int i) {
              return _reservaCard(context2,snapshot.data[i]);
            },
            padding: EdgeInsets.all(20.0),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            fondoColor = Colors.white;
          });
        });
        return SpinKitDoubleBounce(
          color: Color.fromRGBO(1, 127, 255, 1.0),
          size: 50.0,
        );
      }
    );
  }

  Widget _reservaEmpty() {
    return Column(
      children: <Widget>[
        Container(
            width: tam.width * 0.7,
            height: 200.0,
            color: Colors.white,
            child: Image(
              image: AssetImage('assets/empty-data.png'),
              fit: BoxFit.contain,
            )),
        SizedBox(
          height: 10.0,
        ),
        Text('No hay reservaciones', style: TextStyle(fontSize: 16.0))
      ],
    );
  }

  Widget _reservaCard( BuildContext context2,ReservaAdmin reserva) {
    return Container(
      width: tam.width * 0.9,
      height: 210.0,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          children: <Widget>[
            Container(
              width: 70.0,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0))),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.desktop,
                      color: Color.fromRGBO(92, 124, 250, 1.0),
                      size: 40.0,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      (reserva.idComputadora == -2)
                          ? 'Todas'
                          : '${reserva.idComputadora}',
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: new BoxDecoration(
                    color: Color.fromRGBO(0, 102, 151, 1.0),
                    borderRadius: new BorderRadius.only(
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      nombreInfo(reserva.nombre),
                      horaInfo(
                          '${reserva.horaH.horaInicio} - ${reserva.horaH.horaFin}'),
                      esteInfo(reserva.estado),
                      _boton(context2,reserva.estado, reserva.hora,reserva),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget idInfo(int id) {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.idCard, color: Colors.white, size: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Text(
          '$id',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ],
    );
  }

  Widget nombreInfo(String nombre) {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.user, color: Colors.white, size: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(nombre,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.left),
        )
      ],
    );
  }

  Widget esteInfo(String edo) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 6.0,
        ),
        FaIcon(FontAwesomeIcons.info, color: Colors.white, size: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Text(
          edo,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        )
      ],
    );
  }

  Widget horaInfo(String hora) {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.clock, color: Colors.white, size: 20.0),
        SizedBox(
          width: 10.0,
        ),
        Text(
          hora,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        )
      ],
    );
  }

  Widget _boton( BuildContext context2,String estado, int hora,ReservaAdmin r) {
    return StreamBuilder(
        stream: webSocketInfo.serverStream,
        builder: (BuildContext context, AsyncSnapshot<Server> snapshot) {
          if (snapshot.hasData) {
            //print('$hora ${snapshot.data.horaID}');
            if (snapshot.data.horaID == hora && estado == "En espera") {
              return GestureDetector(
                onTap: ()  {_send(context2, r);},
                child: Container(
                  width: 150.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Center(
                      child: Text(
                    'Aceptar reserva',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromRGBO(92, 124, 250, 1.0)),
                  )),
                ),
              );
            } else
              return Container();
          }
          webSocketInfo.intServer();
          return Container();
        });
  }

  void _send(BuildContext context, ReservaAdmin r) async {
    final ConfirmAction action =
        await asyncConfirmDialog(context, 'Confirmar registro');
    print('accion $action');
    if (action == ConfirmAction.Accept) {
      int op=(r.idComputadora == -2)?2:1;
      final res = await usuarioProvider.setNextEdoReserva(r.idUsuario, op, r.estado, r.hora, r.idLaboratorio, r.idComputadora, r.tipoUsuario);

      SnackBar mySnackBar = SnackBar(content: Text(res['info']));
      Scaffold.of(context).showSnackBar(mySnackBar);
    }
  }
}
