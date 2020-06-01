import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/animation/bouncingPageRoute.dart';
import 'package:proyecto/src/model/mytile_model.dart';
import 'package:proyecto/src/providers/horarioInfo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HorarioPage extends StatelessWidget {
  List<String> laboratorios = ['Todos', '1105', '1106', '1107', '2103'];
  bool start = true;
  Color blue = Color.fromRGBO(1, 127, 255, 1.0);
  @override
  Widget build(BuildContext context) {
    final horarioInfo = Provider.of<HorarioInfo>(context);
   
      horarioInfo.gethorario(type: true);


    return Scaffold(
        body: StreamBuilder(
            stream: horarioInfo.horarioStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) return _reservaEmpty(context);
                return Stack(
                  children: <Widget>[
                    ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            //(index == 0) ? horizontal() : Container(),
                           new StuffInTiles(snapshot.data[index])//listOfTiles  snapshot.data
                          ],
                        );
                      },
                      itemCount: snapshot.data.length,
                    ),
                    _filtroBoton(context),
                  ],
                );

              } else
                return Center(
                  child: SpinKitDoubleBounce(
                        color: Color.fromRGBO(1, 127, 255, 1.0),
                        size: 50.0,
                      ),
                );
            }));
  }

  Widget _reservaEmpty(BuildContext context) {
    Size tam = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: tam.width,
            ),
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
            Text('No hay datos', style: TextStyle(fontSize: 16.0))
          ],
        ),
         _filtroBoton(context),
      ],
    );
  }

  Widget horizontal() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: <Widget>[
          Text('hi'),
          Text('hi'),
          Text('hi'),
        ]));
  }

  Widget _filtroBoton(BuildContext context) {
    return Positioned(
        bottom: 0.0,
        right: 0.0,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, BouncingPageRoute(widget: SecondScreen()));
          },
          child: Hero(
            tag: 'boton',
            child: Container(
                height: 55.0,
                width: 105.0,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0)),
                ),
                child: Center(
                    child: Material(
                  color: Colors.transparent,
                  child: Text('Filtros',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ))),
          ),
        ));
  }
}

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;
  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
      return new ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => {},
          leading: new Text("${t.inicio} - ${t.fin}"),
          selected: true,
          title: new Text(t.clase));

    return new ExpansionTile(
      key: Key(t.key),
      title: new Text(t.title),
      children: t.children.map(_buildTiles).toList()
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  Color blue = Color.fromRGBO(1, 127, 255, 1.0);

  Color gris = Color.fromRGBO(144, 152, 171, 1.0);

  Color fondo = Color.fromRGBO(231, 239, 247, 1.0);

  HorarioInfo horarioInfo;

  @override
  Widget build(BuildContext context) {
    horarioInfo = Provider.of<HorarioInfo>(context);
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          _contenido(context),
          _aplyBoton(context),
          _closeBoton(context),
        ],
      )),
    );
  }

  List<Widget> _filtros() {
    List<Widget> items = new List();
    int i = 0;
    for (var item in horarioInfo.filtros) {
      if (item != '') {
        items.add(_chip(item, i));
      }
      i++;
    }
    return items;
  }

  Widget _chip(String nombre, int i) {
    double aux;
    if (nombre.length <= 7)
      aux = 7.5;
    else if (nombre.length > 7 && nombre.length <= 11)
      aux = 7;
    else
      aux = 6.5;

    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: blue),
      width: (nombre.length) * aux + 50.0,
      height: 35.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Text(
            nombre,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {
              if (i == 0)
                horarioInfo.labSelected = '';
              else if (i == 1)
                horarioInfo.diaSelected = '';
              else
                horarioInfo.claseSelected = '';
            },
            child: Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white),
              child: Icon(
                Icons.close,
                size: 18.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Filtros',
              style: TextStyle(
                  color: blue, fontSize: 30.0, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: (_filtros().length == 0)
              ? Text('No hay filtros aplicados',
                  style: TextStyle(
                    color: Color.fromRGBO(197, 203, 218, 1.0),
                    fontSize: 16.0,
                  ))
              : Wrap(
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: _filtros()),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            thickness: 1.0,
            color: Color.fromRGBO(197, 203, 218, 1.0),
          ),
        ),
        Expanded(
          child: Container(
            child: _Slides(),
          ),
        ),
      ],
    );
  }

  Widget _closeBoton(BuildContext context) {
    return Positioned(
        bottom: 0.0,
        left: 0.0,
        child: GestureDetector(
          onTap: ()  {
            horarioInfo.close();
            Navigator.pop(context);
          },
          child: Container(
            height: 55.0,
            width: 55.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(15.0)),
            ),
            child: Icon(
              Icons.close,
              color: blue,
              size: 25.0,
            ),
          ),
        ));
  }

  Widget _aplyBoton(BuildContext context) {
    return Positioned(
        bottom: 0.0,
        left: 75.0,
        child: GestureDetector(
          onTap: () {
           horarioInfo.aply();
            horarioInfo.gethorario(type: true);
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'boton',
            child: Container(
                height: 55.0,
                width: 175.0,
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      topLeft: Radius.circular(15.0)),
                ),
                child: Center(
                    child: Material(
                  color: Colors.transparent,
                  child: Text('Aplicar filtros',
                  softWrap: false,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ))),
          ),
        ));
  }
}

class _Slides extends StatefulWidget {
  @override
  __SlidesState createState() => __SlidesState();
}

class __SlidesState extends State<_Slides> {
  final pageViewController =
      new PageController(viewportFraction: 0.60, initialPage: 0);

  @override
  void initState() {
    super.initState();
    pageViewController.addListener(() {
      //print('pagina acutal ${pageViewController.page}');
      Provider.of<HorarioInfo>(context, listen: false).currentPage =
          pageViewController.page;
    });
  }

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  //String labSelected;

  Color blue = Color.fromRGBO(1, 127, 255, 1.0);

  Color gris = Color.fromRGBO(144, 152, 171, 1.0);

  Color fondo = Color.fromRGBO(231, 239, 247, 1.0);

  Color lightGris = Color.fromRGBO(197, 203, 218, 1.0);
  HorarioInfo horarioInfo;
  @override
  Widget build(BuildContext context) {
    horarioInfo = Provider.of<HorarioInfo>(context);
    return Container(
      child: PageView(
        controller: pageViewController,
        children: <Widget>[
          labColumn(horarioInfo.currentPage),
          diaColumn(horarioInfo.currentPage),
          claseColumn(horarioInfo.currentPage),
        ],
      ),
    );
  }

  Widget labColumn(double index) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: Text('Laboratorios',
                style: TextStyle(
                    color: (index >= -0.5 && index < 0.5) ? blue : lightGris,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Todos', 1),
          SizedBox(
            height: 20.0,
          ),
          _opcion('1105', 1),
          SizedBox(
            height: 20.0,
          ),
          _opcion('1106', 1),
          SizedBox(
            height: 20.0,
          ),
          _opcion('1107', 1),
          SizedBox(
            height: 20.0,
          ),
          _opcion('2103', 1),
          SizedBox(
            height: 70.0,
          )
        ],
      ),
    );
  }

  Widget diaColumn(double index) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: Text('Dias',
                style: TextStyle(
                    color: (index >= 0.5 && index < 1.5) ? blue : lightGris,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Todos', 2),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Lunes', 2),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Martes', 2),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Miércoles', 2),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Jueves', 2),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Viernes', 2),
          SizedBox(
            height: 70.0,
          )
        ],
      ),
    );
  }

  Widget claseColumn(double index) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: Text('Clase',
                style: TextStyle(
                    color: (index >= 1.5 && index < 2.5) ? blue : lightGris,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Todas', 3),
          SizedBox(
            height: 20.0,
          ),
          _opcion('Tiempo libre', 3),
          SizedBox(
            height: 70.0,
          )
        ],
      ),
    );
  }

  Widget _opcion(String opc, int i) {
    bool selected = false;
    if (i == 1 && horarioInfo.labSelected == opc) {
      selected = true;
    } else if (i == 2 && horarioInfo.diaSelected == opc) {
      selected = true;
    } else if (i == 3 && horarioInfo.claseSelected == opc) {
      selected = true;
    }
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              if (i == 1) {
                if (horarioInfo.labSelected == opc)
                  horarioInfo.labSelected = '';
                else
                  horarioInfo.labSelected = opc;
              } else if (i == 2) {
                if (horarioInfo.diaSelected == opc)
                  horarioInfo.diaSelected = '';
                else
                  horarioInfo.diaSelected = opc;
              } else {
                if (horarioInfo.claseSelected == opc)
                  horarioInfo.claseSelected = '';
                else
                  horarioInfo.claseSelected = opc;
              }
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            width: 25.0,
            height: 25.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(color: (selected) ? blue : gris, width: 2.0),
              color: (selected) ? blue : fondo,
            ),
            child: (selected)
                ? Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  )
                : Container(),
          ),
        ),
        SizedBox(
          width: (selected) ? 12.0 : 10.0,
        ),
        Text(opc,
            style: TextStyle(
                color: (selected) ? blue : gris,
                fontSize: 16.0,
                fontWeight: FontWeight.bold))
      ],
    );
  }
}
