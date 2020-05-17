import 'package:flutter/material.dart';
import 'package:proyecto/src/model/laboratorio_model.dart';
import 'package:proyecto/src/providers/laboratorios_providers.dart';
import 'package:proyecto/src/providers/productos_provider.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
class HomePage extends StatelessWidget {
  final productosProvier= new ProductosProvider();
final prefs = new PreferenciasUsuario();
  final laboratoriosProvider = new LaboratoriosProvider ();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('home page'),
        actions: <Widget>[
           FlatButton(
            onPressed: ()=>Navigator.pushReplacementNamed(context, prefs.pagina),
            child: Text('Cerar sesion')),
        ],
      ),
      body: _listaLab(),
      floatingActionButton: _crearBoton(context),
    );
  }
Widget _listaLab()
{
  return FutureBuilder(
    future: laboratoriosProvider.getLaborotorios(),
    builder: (BuildContext context, AsyncSnapshot< List> snapshot) {
      if(snapshot.hasData)
      {
          return ListView.builder(
          itemCount:snapshot.data.length,
          itemBuilder: (context,i)=> _laboratorio(snapshot.data[i])
          );
      }else
      {
        return Container(
          height: 400.0,
          child: Center(
            child: CircularProgressIndicator()
            )
        );
      }
      
    },
  );
/*
  laboratoriosProvider.getLaborotorios();
  return ListView(
    children: <Widget>[
      _laboratorio()
    ],
  );*/
}
Widget _laboratorio(Laboratorio l)
{
  return Card(
    child: Column(
      children: <Widget>[
         Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
          color:Colors.lightBlue,
          height: 45.0,
          width: double.infinity,
          child: Text('Laboratorio ${l.idLaboratorio}',style: TextStyle(color: Colors.white,fontSize: 18.0),),
        ),
        SizedBox(height: 70.0,),
        Divider(color: Colors.black,),
          Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
          height: 25.0,
          width: double.infinity,
          child: Text('Computadoras diponibles: ${l.disponibles}',style: TextStyle(color: Colors.black,fontSize: 15.0),),
        ), Divider(color: Colors.black,),
          Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
          height: 30.0,
          width: double.infinity,
          child: Text('${l.estado}',style: TextStyle(color: Colors.black,fontSize: 15.0),),
        ),
      ],
    ),
  );
}

 _crearBoton(BuildContext context)
  {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: ()=>Navigator.pushNamed(context, 'producto'),
      backgroundColor: Colors.deepPurple,
    );
  }

  void datoslog()
  {
       if(prefs.recordarme  && prefs.numUser!="")
    {
      prefs.pagina='fast';
    }else{
      prefs.pagina='ingreso';
    }
     print('regreso a'+prefs.pagina);
      print('uusario'+prefs.numUser);
  }
}