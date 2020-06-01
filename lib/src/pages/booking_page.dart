import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  Size tam;
  int _index = -1;
  var datos;
  Widget _hijo;
  double _height;
  double _width;
  bool start=true;
  bool visible=true;
  bool load=false;
  final usuarioProvider = new UsuarioProvider();
 

  @override
  Widget build(BuildContext context) {
    datos = ModalRoute.of(context).settings.arguments;
    tam = MediaQuery.of(context).size;
if(start)
{
_cambiarHijo(null);
start=false;
}

    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(1, 127, 255, 1.0),
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              if(_index==0 || _index==1)
              {
                Navigator.pushNamed(context, 'home',arguments: 2);
                }else{
                Navigator.pop(context);
              }
            }), 
        title: Text("Confirmar reserva"),
      ),
      body: Stack(
        children: <Widget>[
          _fondo(),
          _contenido(),
          (visible)?boton(context):Container(),
        ],
      ),
    );
  }

  Widget _fondo() {
    return Container(
        width: tam.width,
        height: tam.height,
        color: Color.fromRGBO(237, 239, 245, 1.0));
  }

  Widget _contenido() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17.0)),
                height: _height,
                width: _width,
                child: _hijo,
              ),
          ],
        ),
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
          children: <Widget>[locationInfo(), dateInfo(),horaInfo(), myInfo()],
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
          'Laboratorio ${datos['lab']}',
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
          '${datos['fecha']}',
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
          '${datos['hora']}',
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  Widget myInfo() {
    return Row(
      children: <Widget>[
        computadoreInfo(),
        SizedBox(
          width: 15.0,
        ),
        boletaInfo(),
      ],
    );
  }

  Widget computadoreInfo() {
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
          '${datos['compu']}',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget boletaInfo() {
    return Column(
      children: <Widget>[
        Text(
          'USUARIO',
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
          '${datos['boleta']}',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget boton(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: GestureDetector(
        onTap: () {
          _submit(context, datos);
        },
        child: Container(
          width: 130.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(1, 127, 255, 1.0),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Confirmar',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                FontAwesomeIcons.check,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context, Map datos) async {
    if(!load)
    {
      load=true;
      Map info;
      if(datos['compu']!=-1)
        info =await usuarioProvider.reservarComputadora(datos['compu'], datos['lab'], datos['horaId']);
      else if(datos['compu']=="Todas" && datos['tipoUsu']==2)
        info =await usuarioProvider.reservarComputadora(datos['compu'], datos['lab'], datos['horaId']);

      _index=info['status'];
    _cambiarHijo(info['mensaje']);
    load=false;
    }
    
    
  }



  void _cambiarHijo(String mensaje) {
   
      print('cambiar hijo$_index');
      if(_index!=-1)
      {
        visible=false;
      }

      if (_index == -1) {
        _height = tam.height * 0.65;
        _width = tam.width * 0.8;
        _hijo = Column(
          children: <Widget>[
            SizedBox(
              height: 0.3,
            ),
            topCard(),
            bottomCard()
          ],
        );
      } else if (_index == 0) {
        _height = 200.0;
        _width = 200.0;
        _hijo = Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(173, 222, 184, 1.0),
              borderRadius: BorderRadius.circular(17.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.check,
                color: Color.fromRGBO(21, 87, 36, 1.0),
                size: 30.0,
              ),
              SizedBox(height: 30.0,),
              Text(
                mensaje,
                style: TextStyle(
                  color: Color.fromRGBO(21, 87, 36, 1.0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              )
            ],
          ),
        );
      }else if (_index==1){
         _height = 200.0;
        _width = 230.0;
        _hijo = Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(226, 227, 229, 1.0),
              borderRadius: BorderRadius.circular(17.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.exclamationCircle,
                color: Color.fromRGBO(56, 61, 65, 1.0),
                size: 30.0,
              ),
              SizedBox(height: 30.0,),
              Text(
                mensaje,
                style: TextStyle(
                  
                  color: Color.fromRGBO(56, 61, 65, 1.0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              )
            ],
          ),
        );
      }else
      {
        _height = 190.0;
        _width = 200.0;
        _hijo = Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(245, 198, 203, 1.0),
              borderRadius: BorderRadius.circular(17.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.times,
                color: Color.fromRGBO(114, 28, 36, 1.0),
                size: 30.0,
              ),
              SizedBox(height: 30.0,),
              Text(
                mensaje,
                style: TextStyle(
                  color: Color.fromRGBO(114, 28, 36, 1.0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              )
            ],
          ),
        );
      }
     setState(() {});
  }
}
