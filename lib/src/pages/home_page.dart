import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:proyecto/src/pages/horarios_page.dart';
import 'package:proyecto/src/pages/laboratorios_page.dart';
import 'package:proyecto/src/pages/registro_salida_page.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final prefs = new PreferenciasUsuario();
  List<ScreenHiddenDrawer> items = new List();
  @override
  void initState() {
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Laboratorios",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.blue,
        ),
        LaboratoriosPage()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Horarios",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.blue,
        ),
        HorarioPage()));

    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          name: "Reservación",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.blue,
        ),
        RegistrarSalidaPage()));
    items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          onTap: () {
            if (prefs.recordarme && prefs.numUser != "") {
              prefs.pagina = 'fast';
            } else {
              prefs.pagina = 'ingreso';
            }
              Navigator.pushNamed(context, prefs.pagina );
            
          },
          name: "Cerrar sesión",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.blue,
        ),
        null));


         items.add(new ScreenHiddenDrawer(
        new ItemHiddenMenu(
          onTap: () {
              SystemNavigator.pop();
        
          },
          name: "Salir",
          baseStyle:
              TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 28.0),
          colorLineSelected: Colors.blue,
        ),
        null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int page = ModalRoute.of(context).settings.arguments;
    return HiddenDrawerMenu(
      backgroundColorMenu: Color.fromRGBO(75, 75, 89, 1.0),
      backgroundColorAppBar: Color.fromRGBO(1, 127, 255, 1.0),
      screens: items,
      initPositionSelected: (page != null) ? page : 0,
      //    typeOpen: TypeOpen.FROM_RIGHT,
      //    enableScaleAnimin: true,
      //    enableCornerAnimin: true,
      slidePercent: 60.0,
      verticalScalePercent: 90.0,
      contentCornerRadius: 40.0,
      //    iconMenuAppBar: Icon(Icons.menu),
      //    backgroundContent: DecorationImage((image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
      //    whithAutoTittleName: true,
      //    styleAutoTittleName: TextStyle(color: Colors.red),
      //    actionsAppBar: <Widget>[],
      //    backgroundColorContent: Colors.blue,
      //    elevationAppBar: 4.0,
      //    tittleAppBar: Center(child: Icon(Icons.ac_unit),),
      //    enableShadowItensMenu: true,
      //    backgroundMenu: DecorationImage(image: ExactAssetImage('assets/bg_news.jpg'),fit: BoxFit.cover),
    );
  }
}
