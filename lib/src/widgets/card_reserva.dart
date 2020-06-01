import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardReserva extends StatelessWidget {
  int boleta;
  int lab;
  String fecha;
  String hora;
  int compu;

  Size tam;

  CardReserva(
      {@required this.boleta,
      @required this.lab,
      @required this.fecha,
      @required this.hora,
      @required this.compu});

  @override
  Widget build(BuildContext context) {
    tam = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 0.3,
          ),
          topCard(),
          bottomCard()
        ],
      ),
    );
  }

  Widget topCard() {
    return Container(
      width: tam.width * 0.8,
      height: 100.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: tam.width * 0.8,
            height: 100.0,
            decoration: new BoxDecoration(
                color: Color.fromRGBO(13, 83, 138, 1.0),
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(17.0),
                    topRight: Radius.circular(17.0))),
          ),
          Positioned(
            top: -42.0,
            left: tam.width * 0.4 - 35.0,
            child: Container(
              width: 65.0,
              height: 60.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(65.0),
                  color: Color.fromRGBO(237, 239, 245, 1.0)),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomCard() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Container(
        color: Colors.white,
        height: (tam.height * 0.65) - 100.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[locationInfo(), dateInfo(), horaInfo(), myInfo()],
        ),
      ),
    );
  }

  Widget locationInfo() {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.mapMarkerAlt,
            color: Color.fromRGBO(221, 221, 221, 1.0)),
        SizedBox(
          width: 10.0,
        ),
        Text(
          'Laboratorio $lab',
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget dateInfo() {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.calendar,
            color: Color.fromRGBO(221, 221, 221, 1.0)),
        SizedBox(
          width: 10.0,
        ),
        Text(
          '$fecha',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget horaInfo() {
    return Row(
      children: <Widget>[
        FaIcon(FontAwesomeIcons.clock,
            color: Color.fromRGBO(221, 221, 221, 1.0)),
        SizedBox(
          width: 10.0,
        ),
        Text(
          '$hora',
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget myInfo() {
    return Row(
      children: <Widget>[
        computadoraInfo(),
        SizedBox(
          width: 15.0,
        ),
        boletaInfo(),
      ],
    );
  }

  Widget computadoraInfo() {
    return Column(
      children: <Widget>[
        Text(
          'COMPUTADORA',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color.fromRGBO(221, 221, 221, 1.0)),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          '$compu',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget boletaInfo() {
    return Column(
      children: <Widget>[
        Text(
          'BOLETA',
          style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Color.fromRGBO(221, 221, 221, 1.0)),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          '$boleta',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
