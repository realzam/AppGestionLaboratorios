import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/providers/recoveryInfo.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';

class RecuperarPasswordPage extends StatefulWidget {
  @override
  _RecuperarPasswordPageState createState() => _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState extends State<RecuperarPasswordPage> {
  final usuarioProvider = new UsuarioProvider();
  Color mainColor = Color.fromRGBO(1, 127, 255, 1.0);
  Color secondColor = Color.fromRGBO(0, 102, 151, 1.0);
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  RecoveryInfo recoveryInfo;
  String token = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    recoveryInfo.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context).settings.arguments;
    recoveryInfo = Provider.of<RecoveryInfo>(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _crearFondo(context),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 10.0,
          )),
          Container(
            width: size.width * 0.85,
            height: 430.0,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ingresa tu nueva contraseña',
                  style: TextStyle(fontSize: 16.0),
                ),
                _crearPassword(),
                _crearConfirmarPassword(),
                _crearBoton(context),
                FlatButton(
                  child: Text('Regresar al inicio'),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, 'ingreso'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
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
          errorText: recoveryInfo.errorPassword,
        ),
        onChanged: (val) {
          recoveryInfo.errorPassword=null;
          recoveryInfo.password = val;
        },
      ),
    );
  }

  Widget _crearConfirmarPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
          obscureText: !passwordVisible2,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(
                    passwordVisible2 ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    passwordVisible2 = !passwordVisible2;
                  });
                }),
            icon: Icon(
              Icons.lock_open,
              color: mainColor,
            ),
            labelText: 'Confirmar contraseña',
            errorText: recoveryInfo.errorPasswordConfirm,
          ),
          onChanged: (val) {
             recoveryInfo.errorPasswordConfirm=null;
            recoveryInfo.passwordConfirm = val;
          }),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return ArgonButton(
      height: 50,
      roundLoadingShape: true,
      width: MediaQuery.of(context).size.width * 0.45,
      onTap: (startLoading, stopLoading, btnState) {
        if (btnState == ButtonState.Idle) {
          _register(context, startLoading, stopLoading);
        }
      },
      child: Text(
        "Enviar al correo",
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

  _register(BuildContext context, Function start, Function stop) async {
    bool res = recoveryInfo.validForm();
    if (res) {
      FocusScope.of(context).requestFocus(new FocusNode());
      start();
      Uri aux=Uri.parse(token);
      Map<String, dynamic> response = await usuarioProvider.resetPassword(
          recoveryInfo.password, recoveryInfo.passwordConfirm,aux.queryParameters['token']);
      if (!response['ok']) {
        stop();
        showInSnackBar(response['message']);
      } else {
        stop();
        showInSnackBar('Contraseña cambiada');
        await new Future.delayed(const Duration(milliseconds: 2000));
        Navigator.pushReplacementNamed(context, 'ingreso',
            arguments: {"show": true, "message": "Contraseña cambiada"});
      }
    }
  }

  void showInSnackBar(String value) {
    if (value != null)
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMoroado = Container(
      height: size.height * 1.0,
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
        )
      ],
    );
  }
}
