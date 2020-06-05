import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/providers/agregarUsuarioInfo.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AgregarUsuarioPage extends StatefulWidget {
  @override
  _AgregarUsuarioPageState createState() => _AgregarUsuarioPageState();
}

class _AgregarUsuarioPageState extends State<AgregarUsuarioPage> {
  final storage = new FlutterSecureStorage();
  final usuarioProvider = new UsuarioProvider();
  Color mainColor = Color.fromRGBO(1, 127, 255, 1.0);
  Color secondColor = Color.fromRGBO(0, 102, 151, 1.0);
  List<String> _usuarios = ['Docente', 'Administrador'];
  List<String> _labs = ['1105', '1106', '1107', '2103'];
  bool passwordVisible = false;
  bool passwordVisible2 = false;
  AgregarUsuarioInfo agregarUsuarioInfo;
  String _usuarioSeleccionado = 'Docente';
  String _labSeleccionado = '1105';
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    agregarUsuarioInfo.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    agregarUsuarioInfo = Provider.of<AgregarUsuarioInfo>(context);
    return Scaffold(
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
                _crearNumeroUsuario(),
                SizedBox(height: 30.0),
                _crearNombre(),
                SizedBox(height: 30.0),
                _crearEmail(),
                SizedBox(height: 30.0),
                _crearDropdownUsu(),
                SizedBox(height: 30.0),
                (_usuarioSeleccionado == 'Administrador')
                    ? _crearDropdownLab()
                    : Container(),
                (_usuarioSeleccionado == 'Administrador')
                    ? SizedBox(height: 30.0)
                    : Container(),
                _crearBoton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpciones() {
    List<DropdownMenuItem<String>> lista = new List();
    _usuarios.forEach((element) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    return lista;
  }

  List<DropdownMenuItem<String>> getOpcionesLab() {
    List<DropdownMenuItem<String>> lista = new List();
    _labs.forEach((element) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    return lista;
  }

  Widget _crearDropdownUsu() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.chalkboardTeacher, color: secondColor),
          SizedBox(
            width: 17.0,
          ),
          Expanded(
            child: DropdownButton(
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                });
              },
              isExpanded: true,
              value: _usuarioSeleccionado,
              items: getOpciones(),
              onChanged: (opt) {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _usuarioSeleccionado = opt;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearDropdownLab() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.chalkboard, color: secondColor),
          SizedBox(
            width: 17.0,
          ),
          Expanded(
            child: DropdownButton(
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                });
              },
              isExpanded: true,
              value: _labSeleccionado,
              items: getOpcionesLab(),
              onChanged: (opt) {
                setState(() {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _labSeleccionado = opt;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearNumeroUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: secondColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondColor),
            ),
            icon: Icon(FontAwesomeIcons.idCard, color: secondColor),
            // hintText: '2016961245',
            labelText: 'No.Boleta/No.Empleado',
            errorText: agregarUsuarioInfo.errorId),
        onChanged: (val) {
          agregarUsuarioInfo.errorId = null;
          agregarUsuarioInfo.id = val;
        },
      ),
    );
  }

  Widget _crearNombre() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        decoration: InputDecoration(
            labelStyle: TextStyle(color: secondColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondColor),
            ),
            icon: Icon(FontAwesomeIcons.user, color: secondColor),
            // hintText: '2016961245',
            labelText: 'Nombre completo',
            errorText: agregarUsuarioInfo.errorNombre),
        onChanged: (val) {
          agregarUsuarioInfo.errorNombre = null;
          agregarUsuarioInfo.nombre = val;
        },
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        cursorColor: secondColor,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: secondColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondColor),
            ),
            icon: Icon(Icons.alternate_email, color: secondColor),
            hintText: 'ejemplo@gmail.com',
            labelText: 'Correo electrónico',
            errorText: agregarUsuarioInfo.errorCorreo),
        onChanged: (val) {
          agregarUsuarioInfo.errorCorreo = null;
          agregarUsuarioInfo.correo = val;
        },
      ),
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
        "Agregar",
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
    bool res = agregarUsuarioInfo.validForm();

    if (res) {
      FocusScope.of(context).requestFocus(new FocusNode());
      final ConfirmAction action =
          await asyncConfirmDialog(context, '¿Los datos son correctos?');
      print('accion $action');

      if (action == ConfirmAction.Accept) {
        String message;
        String res = await creatAlertDialog(context);
        if (res != null) {
          start();
          String pass = await storage.read(key: 'password');
          if (res != pass) {
            message = 'Contraseña incorrecta';
            await new Future.delayed(const Duration(milliseconds: 500));
            SnackBar mySnackBar = SnackBar(content: Text(message));
            Scaffold.of(context).showSnackBar(mySnackBar);
            stop();
            return 0;
          }
          Scaffold.of(context).hideCurrentSnackBar();
          Map<String, dynamic> info;
          if (_usuarioSeleccionado == 'Administrador') {
            info = await usuarioProvider.nuevoUsuario(
                agregarUsuarioInfo.id,
                agregarUsuarioInfo.correo,
                "12345678",
                agregarUsuarioInfo.nombre,
                3,
                lab: int.parse(_labSeleccionado));
          } else
            info = await usuarioProvider.nuevoUsuario(
                agregarUsuarioInfo.id,
                agregarUsuarioInfo.correo,
                "12345678",
                agregarUsuarioInfo.nombre,
                2);
          if (info['ok']) {
            message = '$_usuarioSeleccionado agregado';
          } else {
            message = info['mensaje'];
          }
          await new Future.delayed(const Duration(milliseconds: 500));
          SnackBar mySnackBar = SnackBar(content: Text(message));
          Scaffold.of(context).showSnackBar(mySnackBar);
          stop();
        }
      }
    }
    stop();
  }

  Future<String> creatAlertDialog(BuildContext context) {
    bool passwordVisible = false;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Validar'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 130.0,
                child: Column(
                  children: <Widget>[
                    Text(
                        'Ingresa tu contraseña de administrador para validar la operacion'),
                    TextField(
                      autofocus: true,
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(1, 127, 255, 1.0)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(1, 127, 255, 1.0)),
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color.fromRGBO(1, 127, 255, 1.0)),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                                print('$passwordVisible');
                              });
                            }),
                      ),
                      controller: controller,
                    ),
                  ],
                ),
              );
            }),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                onPressed: () {
                  String res = controller.text.toString();
                  controller.clear();
                  if (res == null) res = '';
                  Navigator.of(context).pop(res);
                },
                child: Text('Confrimar'),
              ),
              MaterialButton(
                elevation: 5.0,
                onPressed: () {
                  controller.clear();
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              )
            ],
          );
        });
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
