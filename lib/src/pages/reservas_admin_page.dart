import 'package:flutter/material.dart';
import 'package:proyecto/src/pages/docentes_reservas_tab.dart';
import 'alumnos_reservas_tab.dart';

class ReservasAdminPage extends StatefulWidget {
  @override
  _ReservasAdminPageState createState() => _ReservasAdminPageState();
}

class _ReservasAdminPageState extends State<ReservasAdminPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                  color: Color.fromRGBO(1, 127, 255, 1.0),
                  width: size.width,
                  height: 50.0,
                  child: getTabBar()),
              Expanded(
                child: Container(
                  child: getTabBarView(
                      <Widget>[AlumnosReservaTab(), DocentesReservaTab()]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Tab>[Tab(child: Text('Alumnos')), Tab(child: Text('Docentes'))],
    );
  }

  TabBarView getTabBarView(var displays) {
    return TabBarView(
      children: displays,
    );
  }
}
