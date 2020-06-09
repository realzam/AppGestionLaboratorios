import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:proyecto/src/model/reserva_reporte_model.dart';
import 'package:proyecto/src/pages/pdf_view_page.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class ReportesPage extends StatefulWidget {
  @override
  _ReportesPageState createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  String assetPdfPath = "";
  String urlPDFPath = "";
  int _currentColumn = 0;
  bool _acendente = true;
  bool start = true;
  List<String> _tipos = ['Computadoras', 'Laboratorios'];
  List<String> _tiempo = ['Hoy', 'Semana', 'Mes'];
  String _tiposSeleccionado = 'Computadoras';
  String _tiempoSeleccionado = 'Semana';
  WebSocketInfo webSocketInfo;
  bool isEmpty = false;
  bool isLoading = false;
  final usuarioProvider = new UsuarioProvider();

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");
      File asstFile = await file.writeAsBytes(bytes);
      return asstFile;
    } catch (e) {
      throw Exception("error opening asset file");
    }
  }

  /* Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("error opening url file");
    }
  }

  final url = '$_url/reservaComputadora';
    final authdata = {
      "usuario": int.parse(usu),
      "compu": compu,
      "lab": lab,
      "hora": hora
    };
    final uu = json.encode(authdata);

    final res = await http
        .post(url, body: uu, headers: {'content-type': 'application/json'});
*/

  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("error opening url file");
    }
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).height - reducedBy) / dividedBy;
  }

  double screenWidth(BuildContext context,
      {double dividedBy = 1, double reducedBy = 0.0}) {
    return (screenSize(context).width - reducedBy) / dividedBy;
  }

  double screenHeightExcludingToolbar(BuildContext context,
      {double dividedBy = 1}) {
    return screenHeight(context,
        dividedBy: dividedBy,
        reducedBy: kToolbarHeight + AppBar().preferredSize.height);
  }

  @override
  Widget build(BuildContext context) {
    webSocketInfo = Provider.of<WebSocketInfo>(context);
    if (start) {
      webSocketInfo.initReservasReporte(2, 1);
      //   webSocketInfo.initReservasReporte(2, 1);
      start = false;
    }
    Size tam = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  height: 60.0,
                  width: tam.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _crearDropdownTiempos(),
                      _crearDropdownTipo()
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: StreamBuilder(
                      stream: webSocketInfo.reservarReporteStream,
                      builder:
                          (BuildContext context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.hasData) {
                          if (isLoading) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => setState(() {
                                      print('1');
                                      isLoading = false;
                                    }));
                          }
                          if (snapshot.data.length == 0) {
                            if (!isEmpty) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => setState(() {
                                        print('2');
                                        isEmpty = true;
                                      }));
                            }

                            return Container();
                          }
                          if (isEmpty) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => setState(() {
                                      print('3');
                                      isEmpty = false;
                                    }));
                          }

                          return bodyData(snapshot.data);
                        }
                        if (!isLoading) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => setState(() {
                                    print('4');
                                    isLoading = true;
                                  }));
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          (isEmpty) ? _regitrosEmpty(context) : Container(),
          (isLoading) ? _regirosLoad(context) : Container(),
        ],
      ),
      floatingActionButton: SpeedDial(
        curve: Curves.bounceIn,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white70,
        animatedIconTheme: IconThemeData(color: Colors.white),
        children: [
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.filePdf),
              backgroundColor: Colors.lightBlue,
              label: "Generar PDF",
              onTap: () {
                SnackBar mySnackBar = SnackBar(
                  content: Text('Generando pdf ...'),
                  duration: Duration(days: 1),
                );
                Scaffold.of(context).showSnackBar(mySnackBar);
                _generarPdf(context);
              }),
          SpeedDialChild(
              child: Icon(FontAwesomeIcons.envelope),
              backgroundColor: Colors.redAccent,
              label: "Enviar reporte al correo",
              onTap: () {
                SnackBar mySnackBar = SnackBar(
                  content: Text('Enviando pdf ...'),
                  duration: Duration(days: 1),
                );
                Scaffold.of(context).showSnackBar(mySnackBar);
                _enviarPdf(context);
              }),
        ],
      ),
    );
  }

  _enviarPdf(BuildContext context) async {
    int tipo;
    int tiempo;
    if (_tiposSeleccionado == 'Laboratorios') {
      tipo = 2;
    } else
      tipo = 1;
    if (_tiempoSeleccionado == 'Hoy') {
      tiempo = 1;
    } else if (_tiempoSeleccionado == 'Semana')
      tiempo = 2;
    else
      tiempo = 3;
    Map<String, dynamic> resp =
        await usuarioProvider.getEnviarPdf(tiempo, tipo);
    Scaffold.of(context).hideCurrentSnackBar();
    SnackBar mySnackBar = SnackBar(content: Text(resp['message']));
    Scaffold.of(context).showSnackBar(mySnackBar);
  }

  _generarPdf(BuildContext context) async {
    int tipo;
    int tiempo;
    if (_tiposSeleccionado == 'Laboratorios') {
      tipo = 2;
    } else
      tipo = 1;
    if (_tiempoSeleccionado == 'Hoy') {
      tiempo = 1;
    } else if (_tiempoSeleccionado == 'Semana')
      tiempo = 2;
    else
      tiempo = 3;
    Map<String, dynamic> f = await usuarioProvider.getFileFromUrl(tiempo, tipo);
    Scaffold.of(context).hideCurrentSnackBar();
    if (f['status']) {
      print('neww plugin');
      File pdf = f['file'];
      PDFDocument document=await PDFDocument.fromFile(pdf);
      SnackBar mySnackBar = SnackBar(
          duration: Duration(seconds: 10),
          content: Text('Pdf generado correctamente'),
          action: SnackBarAction(
            label: 'Abrir',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewPage(document: document)));
            },
          ));
      Scaffold.of(context).showSnackBar(mySnackBar);

    } else {
      SnackBar mySnackBar =
          SnackBar(content: Text('Hubo un error al generar el pdf'));
      Scaffold.of(context).showSnackBar(mySnackBar);
    }
/*setState(() {
        urlPDFPath = f.path;
        print(urlPDFPath);
      });*/
  }

  Widget _regitrosEmpty(BuildContext context) {
    Size tam = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: tam.width * 0.7,
            height: 200.0,
            child: Image(
              image: AssetImage('assets/empty-data.png'),
              fit: BoxFit.contain,
            )),
        SizedBox(
          height: 10.0,
          width: double.infinity,
        ),
        Text('No hay reportes', style: TextStyle(fontSize: 16.0)),
      ],
    );
  }

  Widget _regirosLoad(BuildContext context) {
    Size tam = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: tam.width,
        ),
        SpinKitDoubleBounce(
          color: Color.fromRGBO(1, 127, 255, 1.0),
          size: 50.0,
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getTipos() {
    List<DropdownMenuItem<String>> lista = new List();
    _tipos.forEach((element) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    return lista;
  }

  List<DropdownMenuItem<String>> getTiempo() {
    List<DropdownMenuItem<String>> lista = new List();
    _tiempo.forEach((element) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    return lista;
  }

  Widget _crearDropdownTipo() {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: DropdownButton(
        value: _tiposSeleccionado,
        items: getTipos(),
        onChanged: (opt) {
          setState(() {
            _tiposSeleccionado = opt;
            _pedirReservas();
          });
        },
      ),
    );
  }

  _pedirReservas() {
    int tipo;
    int tiempo;
    if (_tiposSeleccionado == 'Laboratorios') {
      tipo = 2;
    } else
      tipo = 1;
    if (_tiempoSeleccionado == 'Hoy') {
      tiempo = 1;
    } else if (_tiempoSeleccionado == 'Semana')
      tiempo = 2;
    else
      tiempo = 3;
    webSocketInfo.reservaReportesSink(null);
    webSocketInfo.initReservasReporte(tiempo, tipo);
    isLoading = true;
    isEmpty = false;
  }

  Widget _crearDropdownTiempos() {
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: DropdownButton(
        value: _tiempoSeleccionado,
        items: getTiempo(),
        onChanged: (opt) {
          setState(() {
            _tiempoSeleccionado = opt;
            _pedirReservas();
          });
        },
      ),
    );
  }

// bodyData()
  Widget bodyData(List<ReservaReporte> names) => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: _currentColumn,
      sortAscending: _acendente,
      columns: <DataColumn>[
        DataColumn(
            label: Text('Nombre'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.nombre.compareTo(b.nombre));
                else
                  names.sort((a, b) => a.nombre.compareTo(b.nombre));
              });
            }),
        DataColumn(
            label: Text('Boleta'),
            numeric: true,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.idUsuario.compareTo(b.idUsuario));
                else
                  names.sort((a, b) => a.idUsuario.compareTo(b.idUsuario));
              });
            }),
        DataColumn(
            label: Text('Computadora'),
            numeric: true,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.computadora.compareTo(b.computadora));
                else
                  names.sort((a, b) => a.computadora.compareTo(b.computadora));
              });
            }),
        DataColumn(
            label: Text('Estado'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.estado.compareTo(b.estado));
                else
                  names.sort((a, b) => a.estado.compareTo(b.estado));
              });
            }),
        DataColumn(
            label: Text('Observaciones'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.observacion.compareTo(b.observacion));
                else
                  names.sort((a, b) => a.observacion.compareTo(b.observacion));
              });
            }),
        DataColumn(
            label: Text('Dia'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.dia.compareTo(b.dia));
                else
                  names.sort((a, b) => a.dia.compareTo(b.dia));
              });
            }),
        DataColumn(
            label: Text('Hora'),
            numeric: false,
            onSort: (i, b) {
              setState(() {
                if (_currentColumn == i) _acendente = !_acendente;
                _currentColumn = i;
                if (_acendente)
                  names.sort((b, a) => a.hora.compareTo(b.hora));
                else
                  names.sort((a, b) => a.hora.compareTo(b.hora));
              });
            }),
      ],
      rows: names
          .map((name) => DataRow(cells: [
                DataCell(Text(name.nombre)),
                DataCell(Text('${name.idUsuario}')),
                DataCell(Text('${name.computadora}')),
                DataCell(Text('${name.estado}')),
                DataCell(Text('${name.observacion}')),
                DataCell(Text('${name.dia}')),
                DataCell(Text('${name.hora}')),
              ]))
          .toList());
}
