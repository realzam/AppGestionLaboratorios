import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LaboratoriosPage extends StatelessWidget {
  Size tam;
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String res = timeOfDay.format(context);
    bool is12HoursFormat = res.contains(new RegExp(r'[A-Z]'));
    prefs.formatHora = is12HoursFormat;
    tam = MediaQuery.of(context).size;
    final webSocketInfo = Provider.of<WebSocketInfo>(context);
    webSocketInfo.init();
    webSocketInfo.intServer();
    webSocketInfo.listenCompus = false;
    webSocketInfo.intLabs();
    return Scaffold(
        backgroundColor: Color.fromRGBO(1, 127, 255, 1.0),
        body: StreamBuilder(
          stream: webSocketInfo.laboratoriosStream,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i) {
                  return cardLab(snapshot.data[i], context);
                },
                padding: EdgeInsets.all(20.0),
              );
            } else {
              return Center(
                  child: SpinKitDoubleBounce(
                color: Colors.white,
                size: 50.0,
              ));
            }
          },
        ));
  }

  Widget cardLab(Laboratorio l, BuildContext context) {
    return Container(
      height: 100.0,
      child: GestureDetector(
        onTap: () async{
          final storage = new FlutterSecureStorage();
          String t=await storage.read(key: 'tipo');
          int tipo=int.parse(t);
          List <dynamic> ar=[l,tipo];
          //if(dia==6||dia==0||hora==0)return null;
          Navigator.pushNamed(context, "reservar", arguments: ar);
        },
        child: Card(
            elevation: 10.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      color:
                          (l.estado == "En clase") ? Colors.red : Colors.green,
                      borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0))),
                  height: 100.0,
                  width: 20.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Laboratorio ${l.idLaboratorio}'),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(l.estado),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text('Computadoras libres:${l.disponibles}'),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
