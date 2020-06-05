import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:proyecto/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IngresoPage extends StatefulWidget {
  @override
  _IngresoPageState createState() => _IngresoPageState();
}

class _IngresoPageState extends State<IngresoPage> {
  final storage = new FlutterSecureStorage();
  final usuarioProvider = new UsuarioProvider();
  final formKey = GlobalKey<FormState>();
  final prefs = new PreferenciasUsuario();
  Color mainColor = Color.fromRGBO(1, 127, 255, 1.0);
  Color secondColor = Color.fromRGBO(0, 102, 151, 1.0);
  bool passwordVisible = false;
  String pass = '';
  String numUs;
  WebSocketInfo webSocketInfo;
  @override
  Widget build(BuildContext context) {
    webSocketInfo = Provider.of<WebSocketInfo>(context);
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String res = timeOfDay.format(context);
    bool is12HoursFormat = res.contains(new RegExp(r'[A-Z]'));
    prefs.formatHora = is12HoursFormat;
    initializeDateFormatting();
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    Intl.defaultLocale = 'es';
    DateFormat.jm().format(DateTime.now());
    var now = new DateTime.now();
    String hoy = new DateFormat('d').format(now) +
        " de " +
        new DateFormat('MMMM').format(now) +
        ", " +
        new DateFormat('y').format(now);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: size.height * 0.4,
          )),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text(
                  "ingreso",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  hoy,
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 60.0,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      _crearNumeroUsuario(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _crearPassword(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _crearRecordarme(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _crearBoton(),
                    ],
                  ),
                )
              ],
            ),
          ),
          FlatButton(
            child: Text('Crear una nueva cuenta'),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'registro'),
          ),
          goFast(context),
        ],
      ),
    );
  }

  Widget _crearNumeroUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          icon: Icon(
            Icons.accessibility,
            color: mainColor,
          ),
          // hintText: '2016961245',
          labelText: 'No.Boleta/No.Empleado',
        ),
        onSaved: (value) => numUs = value,
        validator: (value) {
          if (isNumeric(value) && value.length > 9) {
            return null;
          } else {
            return "Deben ser 10 o mas  numeros";
          }
        },
      ),
    );
  }

  Widget _crearRecordarme() {
    return SwitchListTile(
      value: prefs.recordarme,
      title: Text('Recordarme en este dispositivo'),
      activeColor: mainColor,
      onChanged: (value) => setState(() {
        prefs.recordarme = value;
      }),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: mainColor),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              }),
          icon: Icon(
            Icons.lock_open,
            color: mainColor,
          ),
          labelText: 'Contraseña',
        ),
        onSaved: (value) => pass = value,
        validator: (value) {
          if (value.length < 8) {
            return 'Debe tener al menos 8 caracteres';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearBoton() {
    /*
    return RaisedButton(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text("Ingresar")),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: secondColor,
      textColor: Colors.white,
      onPressed: _submit,
    );*/
    return ArgonButton(
      height: 50,
      roundLoadingShape: true,
      width: MediaQuery.of(context).size.width * 0.45,
      onTap: (startLoading, stopLoading, btnState) {
        if (btnState == ButtonState.Idle) {
          startLoading();
          _submit(stopLoading);
        }
      },
      child: Text(
        "Ingresar",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      loader: Container(
        padding: EdgeInsets.all(10),
        child: SpinKitRotatingCircle(
          color: Colors.white,
          // size: loaderWidth ,
        ),
      ),
      borderRadius: 5.0,
      color: secondColor,
    );
  }

  Widget goFast(BuildContext context) {
    if (prefs.numUser != '') {
      return FlatButton(
        child: Text('Ingresar con cuenta guardada'),
        onPressed: () {
          prefs.ultimaPagina = 'ingreso';
          Navigator.pushReplacementNamed(context, 'fast');
        },
      );
    }
    return Container();
  }

  void _submit(Function stop) async {
    if (!formKey.currentState.validate()) {
      stop();
      return;
    }
    formKey.currentState.save();
    Map info = await usuarioProvider.login(numUs, pass);

    if (info['ok']) {
      if (prefs.recordarme && prefs.numUser != "") {
        prefs.pagina = 'fast';
      } else {
        prefs.pagina = 'ingreso';
      }
      await webSocketInfo.init();
      await new Future.delayed(const Duration(milliseconds: 500));
      stop();
      await new Future.delayed(const Duration(milliseconds: 460));
      String usu = await storage.read(key: 'tipo');
      if (usu == "3")
        Navigator.pushReplacementNamed(context, 'home2');
      else
        Navigator.pushReplacementNamed(context, 'home');
    } else {
      stop();
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMoroado = Container(
      height: size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[mainColor, Color.fromRGBO(1, 92, 190, 1.0)]),
      ),
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.25)),
    );
    return Stack(
      children: <Widget>[
        fondoMoroado,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          left: -30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          right: -80.0,
          child: circulo,
        ),
        Positioned(
          top: 250.0,
          right: 20.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          left: -20.0,
          child: circulo,
        ),
        Container(
          padding: EdgeInsets.only(
            top: size.height * 0.1,
          ),
          child: Column(
            children: <Widget>[
              Container(
                  width: size.width * 0.35,
                  height: size.width * 0.35,
                  child: Image(
                    image: AssetImage('assets/icon.png'),
                    fit: BoxFit.contain,
                  )),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'Control laboratorios',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              )
            ],
          ),
        )
      ],
    );
  }
}
