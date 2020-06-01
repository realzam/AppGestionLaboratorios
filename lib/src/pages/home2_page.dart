import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/src/pages/configuracion_page.dart';
import 'package:proyecto/src/pages/horarios_page.dart';
import 'package:proyecto/src/pages/laboratorios_page.dart';
import 'package:proyecto/src/pages/registro_salida_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final prefs = new PreferenciasUsuario();
  int currentIndex = 0;
  Widget _showPage = LaboratoriosPage();
  final LaboratoriosPage _dispo = LaboratoriosPage();
  final HorarioPage _horario = HorarioPage();
  final RegistrarSalidaPage _regSalida = RegistrarSalidaPage();
  final ConfiguracionPage _config = ConfiguracionPage();

  Widget _choosePage(int page) {
    switch (page) {
      case 0:
        return _dispo;
        break;
      case 1:
        return _horario;
        break;
      case 2:
        return _regSalida;
        break;
      case 3:
        return _config;
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(1, 127, 255, 1.0),
        title: Text('Home'),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pushNamed(context, prefs.ultimaPagina),
              child: Text('Cerrar sesion',style: TextStyle(fontSize: 16.0, color: Colors.white),))
        ],
      ),
      body: _showPage,
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
          _showPage = _choosePage(index);
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(FontAwesomeIcons.desktop),
            title: Text('Disponible'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(FontAwesomeIcons.calendar),
            title: Text('Horarios'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.exit_to_app),
            title: Text(
              'Salida',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
