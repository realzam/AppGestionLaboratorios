import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/model/reserva_model.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegistrarSalidaPage extends StatefulWidget {
  @override
  _RegistrarSalidaPageState createState() => _RegistrarSalidaPageState();
}

class _RegistrarSalidaPageState extends State<RegistrarSalidaPage> {
  Size tam;
  bool start = true;
  WebSocketInfo webSocketInfo;
  final usuarioProvider = new UsuarioProvider();
  Color fondoColor;

  @override
  Widget build(BuildContext context) {
    webSocketInfo = Provider.of<WebSocketInfo>(context);
    if (start) {
      webSocketInfo.intMiReserva();
      fondoColor = Colors.white;
      start = false;
    }
    tam = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fondo(),
          _contenido(),
        ],
      ),
    );
  }

  Widget _fondo() {
    return Container(width: tam.width, height: tam.height, color: fondoColor);
  }

  Widget _contenido() {
    return StreamBuilder(
      stream: webSocketInfo.reservarStream,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              if (snapshot.data.length == 0)
                fondoColor = Colors.white;
              else
                fondoColor = Color.fromRGBO(92, 124, 250, 1.0);
            });
          });
          if (snapshot.data.length == 0)
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _reservaEmpty(),
              ],
            ));
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int i) {
              return _reservaCard(snapshot.data[i]);
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
      },
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
        Text('No tienes reservación', style: TextStyle(fontSize: 16.0))
      ],
    );
  }

  Widget _reservaCard(Reserva reserva) {
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
                      (reserva.idComputadora==-2)?'Todas':'${reserva.idComputadora}',
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
                      locationInfo(reserva.idLaboratorio),
                      dateInfo(reserva.fecha),
                      horaInfo(reserva.horaS),
                      esteInfo(reserva.estado),
                      _boton(reserva.estado,reserva.tipo),
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

  Widget locationInfo(int lab) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 2.0,
        ),
        FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Colors.white),
        SizedBox(
          width: 10.0,
        ),
        Text(
          'Laboratorio $lab',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        )
      ],
    );
  }

  Widget dateInfo(String fecha) {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.calendar, color: Colors.white),
        SizedBox(
          width: 10.0,
        ),
        Text(
          fecha,
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ],
    );
  }

  Widget horaInfo(String hora) {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.clock, color: Colors.white),
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

  Widget esteInfo(String edo) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 6.0,
        ),
        FaIcon(FontAwesomeIcons.info, color: Colors.white),
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

  Widget _boton(String estado,int tipo) {
    return GestureDetector(
      onTap: () => _send(estado,tipo),
      child: Container(
        width: 150.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Center(
            child: Text(
          (estado=="En espera")?'Cancelar reserva':'Finalizar reserva',
          style: TextStyle(
              fontSize: 16.0, color: Color.fromRGBO(92, 124, 250, 1.0)),
        )),
      ),
    );
  }

  void _send(String estado,int tipo) {
    if(estado=="En espera")
    {
      if(tipo==1)
        usuarioProvider.cancelarReservaComputadora();
      else
       usuarioProvider.cancelarReservaLaboratorio();
    }
    
  }
}
