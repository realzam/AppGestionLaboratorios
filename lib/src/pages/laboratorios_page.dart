import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/providers/webSocketInformation.dart';


class LaboratoriosPage extends StatelessWidget {
  Size tam;
final webSocketInfo = new WebSocketInfo();

  @override
  Widget build(BuildContext context) {
    tam =MediaQuery.of(context).size;
    final webSocketInfo =Provider.of<WebSocketInfo>(context);
    if(!webSocketInfo.inicio)
    webSocketInfo.init();
    webSocketInfo.intLabs();
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 127, 255, 1.0),
      body: 
        StreamBuilder(
          stream: webSocketInfo.laboratoriosStream,
         builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if ( snapshot.hasData ) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context,int i){
                    return cardLab(snapshot.data[i],context);
                  },
                  padding: EdgeInsets.all(20.0),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } ,
        )
    
    );
  }

Widget cardLab(Laboratorio l,BuildContext context)
{
  return Container(
    height: 100.0,
    child: GestureDetector(
      onTap: (){
        if(l.estado=="Tiempo libre")
        Navigator.pushNamed(context, "reservar",arguments: l);
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
                color: (l.estado=="En clase")?Colors.red:Colors.green,
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0)
                )
              ),
            height: 100.0,
            width: 30.0,
          ),
          SizedBox(width: 10.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.0,),
              Text('Laboratorio ${l.idLaboratorio}'),
              SizedBox(height: 10.0,),
              Text(l.estado),
               SizedBox(height: 10.0,),
              Text('Computadoras libres:${l.disponibles}'),
            ],
          )
        ],
      )
      ),
    ),
  );
}

}