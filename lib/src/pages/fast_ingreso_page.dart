import 'package:flutter/material.dart';
import 'package:proyecto/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:proyecto/src/providers/usuario_provider.dart';
import 'package:proyecto/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class FastLoginPage extends StatefulWidget {

  @override
  _FastLoginPageState createState() => _FastLoginPageState();
}

class _FastLoginPageState extends State<FastLoginPage> {
Color mainColor= Color.fromRGBO(1, 127, 255, 1.0);
Color secondColor= Color.fromRGBO(0, 102, 151, 1.0);
   final storage = new FlutterSecureStorage();
  bool passwordVisible=false;
final usuarioProvider= new UsuarioProvider();
final prefs = new PreferenciasUsuario();
final formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   initializeDateFormatting();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

Widget _loginForm(BuildContext context)
{
  Intl.defaultLocale = 'es';
DateFormat.jm().format(DateTime.now());
var now = new DateTime.now();
String hoy=new DateFormat('d').format(now)+" de "+new DateFormat('MMMM').format(now)+", "+new DateFormat('y').format(now);
  final size =MediaQuery.of(context).size;

  
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: size.height*0.4,
          )
        ),


        Container(
          width:size.width*0.85 ,
          padding: EdgeInsets.symmetric(vertical: 50.0),
          margin: EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0,
                offset: Offset(0.0,5.0),
                spreadRadius: 3.0
              )
            ]
              
            
          ),
          child: Column(
            children: <Widget>[
              Text(hoy,style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 20.0,),
              Text("Bienvenido",style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 60.0,),
              Text(prefs.numUser, style: TextStyle(fontSize: 20.0),),
              SizedBox(height: 60.0,),          
               _crearBoton(),
            ],
          ),
        ),
        FlatButton(
          child: Text('Crear una nueva cuenta'),
          onPressed: ()=>Navigator.pushReplacementNamed(context, 'registro'),
          ),
           FlatButton(
          child: Text('Ingresar con otra Cuenta'),
          onPressed: (){
            prefs.ultimaPagina='fast';
            Navigator.pushReplacementNamed(context, 'ingreso');
            },
          ),
      ],
    ),
  );
}


Widget _crearBoton()
{
 
  
      return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0,vertical: 15.0),
          child:Text("ingresar")
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
        ),
        elevation: 0.0,
        color: mainColor,
        textColor: Colors.white,
        onPressed: _submit

        ,
      );
   
  
}

void _submit() async{
String numUsuario = await storage.read(key: 'numUsuario');
String password = await storage.read(key: 'password');
   Map info= await usuarioProvider.login(numUsuario, password);
   if(info['ok'] )
   {
        if(prefs.recordarme)
        prefs.pagina='fast';
    else 
        prefs.pagina='ingreso';

   Navigator.pushReplacementNamed(context, 'home');

   }else
   {
     mostrarAlerta(context,info['mensaje']);
   }

}

Widget _crearFondo(BuildContext context)
{
  final size =MediaQuery.of(context).size;
  final fondoMoroado=  Container(
    height: size.height *0.5,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          mainColor,
          Color.fromRGBO(1, 92, 190, 1.0)
        ]
        ),

    ),
  );
  final circulo=Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      color:Color.fromRGBO(255, 255, 255, 0.25)
    ),
  );
  return Stack(
    children: <Widget>[
      fondoMoroado,
      Positioned(top: 90.0,left: 30.0,child: circulo,),
      Positioned(top: -40.0,left: -30.0,child: circulo,),
      Positioned(top: -40.0,right: -80.0,child: circulo,),
      Positioned(top: 250.0,right: 20.0,child: circulo,),
      Positioned(bottom: -50.0,left: -20.0,child: circulo,),
      Container(
        padding: EdgeInsets.only(top:size.height *0.1,),
        child: Column(

          children: <Widget>[
            Icon(Icons.person_pin_circle, color:Colors.white,size:100.0),
            SizedBox(height: 10.0,width: double.infinity,),
            Text('control com', style: TextStyle(color:Colors.white, fontSize: 25.0),)
          ],
        ),
      )
    ],
  );
}
}